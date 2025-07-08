----------------------------
-- (1) Insert Question with Options Stored Procedure
----------------------------
CREATE PROCEDURE sp_InsertQuestionWithOptions
    @QuestionText TEXT,
    @DifficultyLevel VARCHAR(20),
    @QuestionType VARCHAR(20), -- 'T/F' or 'MCQ'
    @CourseCode VARCHAR(10),

    @Option1Text VARCHAR(50),
    @Option1IsCorrect BIT,

    @Option2Text VARCHAR(50),
    @Option2IsCorrect BIT,

    @Option3Text VARCHAR(50) = NULL,
    @Option3IsCorrect BIT = NULL,

    @Option4Text VARCHAR(50) = NULL,
    @Option4IsCorrect BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if course exists
        IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseCode = @CourseCode)
        BEGIN
            RAISERROR('Course does not exist.', 16, 1);
            RETURN;
        END

        -- T/F validation: Only allow 2 options
        IF @QuestionType = 'T/F' AND (@Option3Text IS NOT NULL OR @Option4Text IS NOT NULL)
        BEGIN
            RAISERROR('True/False questions must only have two options.', 16, 1);
            RETURN;
        END

        -- Insert into Question table
        INSERT INTO Question (QuestionText, DifficultyLevel, QuestionType, CourseCode)
        VALUES (@QuestionText, @DifficultyLevel, @QuestionType, @CourseCode);

        DECLARE @QuestionID INT = SCOPE_IDENTITY();

        -- Insert Options (only if not null)
        IF @Option1Text IS NOT NULL
            INSERT INTO Options (OptionText, IsCorrect, QuestionID) VALUES (@Option1Text, @Option1IsCorrect, @QuestionID);

        IF @Option2Text IS NOT NULL
            INSERT INTO Options (OptionText, IsCorrect, QuestionID) VALUES (@Option2Text, @Option2IsCorrect, @QuestionID);

        IF @Option3Text IS NOT NULL
            INSERT INTO Options (OptionText, IsCorrect, QuestionID) VALUES (@Option3Text, @Option3IsCorrect, @QuestionID);

        IF @Option4Text IS NOT NULL
            INSERT INTO Options (OptionText, IsCorrect, QuestionID) VALUES (@Option4Text, @Option4IsCorrect, @QuestionID);

        PRINT 'Question and options inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

----------------------------
-- (2) Update Question Only
----------------------------
CREATE PROCEDURE sp_UpdateQuestion
    @QuestionID INT,
    @QuestionText TEXT,
    @DifficultyLevel VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Question WHERE QuestionID = @QuestionID)
    BEGIN
        RAISERROR('Question not found.', 16, 1);
        RETURN;
    END

    UPDATE Question
    SET QuestionText = @QuestionText,
        DifficultyLevel = @DifficultyLevel
    WHERE QuestionID = @QuestionID;

    PRINT 'Question updated successfully.';
END;
GO

----------------------------
-- (3) Delete Question with Options
----------------------------
CREATE PROCEDURE sp_DeleteQuestion
    @QuestionID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Question WHERE QuestionID = @QuestionID)
    BEGIN
        RAISERROR('Question not found.', 16, 1);
        RETURN;
    END

    DELETE FROM Options WHERE QuestionID = @QuestionID;
    DELETE FROM Question WHERE QuestionID = @QuestionID;

    PRINT 'Question and related options deleted successfully.';
END;
GO

----------------------------
-- (4) Select Question (One or All)
----------------------------
CREATE PROCEDURE sp_GetQuestions
    @QuestionID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
    BEGIN
        SELECT Q.QuestionID, Q.QuestionText, Q.DifficultyLevel, Q.QuestionType, Q.CourseCode,
               O.OptionID, O.OptionText, O.IsCorrect
        FROM Question Q
        LEFT JOIN Options O ON Q.QuestionID = O.QuestionID
        ORDER BY Q.QuestionID;
    END
    ELSE
    BEGIN
        SELECT Q.QuestionID, Q.QuestionText, Q.DifficultyLevel, Q.QuestionType, Q.CourseCode,
               O.OptionID, O.OptionText, O.IsCorrect
        FROM Question Q
        LEFT JOIN Options O ON Q.QuestionID = O.QuestionID
        WHERE Q.QuestionID = @QuestionID;
    END
END;
GO

----------------------------
-- Testing Block
----------------------------

-- (1) Insert (MCQ)
EXEC sp_InsertQuestionWithOptions
    @QuestionText = 'Which of these is a SQL keyword?',
    @DifficultyLevel = 'Easy',
    @QuestionType = 'MCQ',
    @CourseCode = 'CS22',
    @Option1Text = 'SELECT',
    @Option1IsCorrect = 1,
    @Option2Text = 'PRINT',
    @Option2IsCorrect = 0,
    @Option3Text = 'IF',
    @Option3IsCorrect = 0,
    @Option4Text = 'ECHO',
    @Option4IsCorrect = 0;

select * from Question where QuestionID = '1003';

-- (2) Insert (T/F)
EXEC sp_InsertQuestionWithOptions
    @QuestionText = 'SQL stands for Structured Query Language.',
    @DifficultyLevel = 'Medium',
    @QuestionType = 'T/F',
    @CourseCode = 'CS101',
    @Option1Text = 'True',
    @Option1IsCorrect = 1,
    @Option2Text = 'False',
    @Option2IsCorrect = 0;

-- (3) Get All Questions
EXEC sp_GetQuestions;

-- (4) Get Specific Question
EXEC sp_GetQuestions @QuestionID = 1002;

-- (5) Update a Question
EXEC sp_UpdateQuestion
    @QuestionID = 1002,
    @QuestionText = 'Which one of these is a valid SQL command?',
    @DifficultyLevel = 'Hard';

-- (6) Delete a Question
EXEC sp_DeleteQuestion @QuestionID = 1003;
