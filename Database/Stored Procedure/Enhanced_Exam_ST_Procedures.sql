CREATE PROCEDURE GenerateExam
    @CourseCode VARCHAR(10),
    @ExamType VARCHAR(20),       -- 'Midterm', 'Final', 'Quiz'
    @TotalQuestions INT,
    @MCQCount INT,
    @TFCount INT,
    @TotalMarks INT,
    @PassingScore INT,
    @ScheduleDate DATETIME,
    @Duration INT               -- Duration in minutes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ExamID INT;
    DECLARE @AvailableMCQ INT;
    DECLARE @AvailableTF INT;

    -- Validate total matches parts
    IF @TotalQuestions <> (@MCQCount + @TFCount)
    BEGIN
        RAISERROR('TotalQuestions must equal MCQCount + TFCount', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check question availability
        SELECT @AvailableMCQ = COUNT(*) FROM Question WHERE CourseCode = @CourseCode AND QuestionType = 'MCQ';
        SELECT @AvailableTF  = COUNT(*) FROM Question WHERE CourseCode = @CourseCode AND QuestionType = 'T/F';

        IF @AvailableMCQ < @MCQCount
        BEGIN
            RAISERROR('Not enough MCQ questions.', 16, 1); ROLLBACK TRANSACTION; RETURN;
        END

        IF @AvailableTF < @TFCount
        BEGIN
            RAISERROR('Not enough T/F questions.', 16, 1); ROLLBACK TRANSACTION; RETURN;
        END

        -- Insert the exam
        INSERT INTO Exam (ExamType, TotalMarks, PassingScore, Duration, ScheduleDate, CourseCode)
        VALUES (@ExamType, @TotalMarks, @PassingScore, @Duration, @ScheduleDate, @CourseCode);

        SET @ExamID = SCOPE_IDENTITY();  -- Capture new ExamID

        -- Pick random questions
        ;WITH SelectedQuestions AS (
            SELECT TOP (@MCQCount) QuestionID FROM Question WHERE CourseCode = @CourseCode AND QuestionType = 'MCQ' ORDER BY NEWID()
            UNION ALL
            SELECT TOP (@TFCount) QuestionID FROM Question WHERE CourseCode = @CourseCode AND QuestionType = 'T/F' ORDER BY NEWID()
        )
        INSERT INTO Exam_Question (ExamID, QuestionID, QuestionOrder)
        SELECT @ExamID, QuestionID, ROW_NUMBER() OVER (ORDER BY NEWID()) FROM SelectedQuestions;

        COMMIT TRANSACTION;
        SELECT @ExamID AS ExamID;  -- Return exam id
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE SubmitStudentAnswer
    @StudentID INT,
    @ExamID INT,
    @QuestionID INT,
    @SelectedOptionID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check option belongs to question
        IF NOT EXISTS (
            SELECT 1 FROM Options
            WHERE OptionID = @SelectedOptionID AND QuestionID = @QuestionID
        )
        BEGIN
            RAISERROR('Option not valid for question.', 16, 1); RETURN;
        END

        -- Check question belongs to exam
        IF NOT EXISTS (
            SELECT 1 FROM Exam_Question
            WHERE ExamID = @ExamID AND QuestionID = @QuestionID
        )
        BEGIN
            RAISERROR('Question not in exam.', 16, 1); RETURN;
        END

        -- Check time constraint
        DECLARE @ExamEndTime DATETIME;
        SELECT @ExamEndTime = DATEADD(MINUTE, Duration, ScheduleDate)
        FROM Exam WHERE ExamID = @ExamID;

        IF GETDATE() > @ExamEndTime
        BEGIN
            RAISERROR('Exam has ended.', 16, 1); RETURN;
        END

        -- Upsert: update if exists, insert if not
        IF EXISTS (
            SELECT 1 FROM Student_Answers
            WHERE StudentID = @StudentID AND ExamID = @ExamID AND QuestionID = @QuestionID
        )
        BEGIN
            UPDATE Student_Answers
            SET SelectedOptionID = @SelectedOptionID, AnswerDateTime = GETDATE(), IsCorrect = NULL
            WHERE StudentID = @StudentID AND ExamID = @ExamID AND QuestionID = @QuestionID;
        END
        ELSE
        BEGIN
            INSERT INTO Student_Answers (StudentID, ExamID, QuestionID, SelectedOptionID, IsCorrect, AnswerDateTime)
            VALUES (@StudentID, @ExamID, @QuestionID, @SelectedOptionID, NULL, GETDATE());
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE EvaluateExam
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CorrectCount INT = 0;
    DECLARE @TotalQuestions INT = 0;
    DECLARE @TotalMarks INT = 0;
    DECLARE @FinalScore DECIMAL(5,2);
    DECLARE @PassingScore INT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert skipped questions
        INSERT INTO Student_Answers (StudentID, ExamID, QuestionID, SelectedOptionID, IsCorrect)
        SELECT @StudentID, @ExamID, EQ.QuestionID, NULL, 0
        FROM Exam_Question EQ
        WHERE EQ.ExamID = @ExamID
        AND NOT EXISTS (
            SELECT 1 FROM Student_Answers SA
            WHERE SA.StudentID = @StudentID AND SA.ExamID = @ExamID AND SA.QuestionID = EQ.QuestionID
        );

        -- Mark correct answers
        UPDATE SA
        SET IsCorrect = 1
        FROM Student_Answers SA
        INNER JOIN Options O ON SA.SelectedOptionID = O.OptionID
        WHERE SA.StudentID = @StudentID AND SA.ExamID = @ExamID AND O.IsCorrect = 1;

        -- Mark remaining as incorrect
        UPDATE Student_Answers
        SET IsCorrect = 0
        WHERE StudentID = @StudentID AND ExamID = @ExamID AND IsCorrect IS NULL;

        -- Score
        SELECT @CorrectCount = COUNT(*) FROM Student_Answers WHERE StudentID = @StudentID AND ExamID = @ExamID AND IsCorrect = 1;
        SELECT @TotalQuestions = COUNT(*) FROM Exam_Question WHERE ExamID = @ExamID;
        SELECT @TotalMarks = TotalMarks, @PassingScore = PassingScore FROM Exam WHERE ExamID = @ExamID;

        IF @TotalQuestions = 0
            SET @FinalScore = 0;
        ELSE
            SET @FinalScore = (@CorrectCount * 1.0 / @TotalQuestions) * @TotalMarks;

        -- Insert/update Student_Exam
        IF EXISTS (
            SELECT 1 FROM Student_Exam WHERE StudentID = @StudentID AND ExamID = @ExamID
        )
        BEGIN
            UPDATE Student_Exam SET Score = @FinalScore
            WHERE StudentID = @StudentID AND ExamID = @ExamID;
        END
        ELSE
        BEGIN
            INSERT INTO Student_Exam (ExamID, StudentID, Score)
            VALUES (@ExamID, @StudentID, @FinalScore);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

