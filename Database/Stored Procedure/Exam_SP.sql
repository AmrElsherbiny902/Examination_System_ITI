----------------------------
-- Exam Stored Procedures
----------------------------

-- (1) Insert Exam Stored Procedure
CREATE PROCEDURE sp_InsertExam
    @ExamType VARCHAR(20),
    @TotalMarks INT,
    @PassingScore INT,
    @Duration INT,
    @ScheduleDate DATETIME,
    @CourseCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Exam (ExamType, TotalMarks, PassingScore, Duration, ScheduleDate, CourseCode)
    VALUES (@ExamType, @TotalMarks, @PassingScore, @Duration, @ScheduleDate, @CourseCode);

    PRINT ' Exam inserted successfully.';
END;
GO

-- (2) Update Exam Stored Procedure
CREATE PROCEDURE sp_UpdateExam
    @ExamID INT,
    @ExamType VARCHAR(20),
    @TotalMarks INT,
    @PassingScore INT,
    @Duration INT,
    @ScheduleDate DATETIME,
    @CourseCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Exam
    SET ExamType = @ExamType,
        TotalMarks = @TotalMarks,
        PassingScore = @PassingScore,
        Duration = @Duration,
        ScheduleDate = @ScheduleDate,
        CourseCode = @CourseCode
    WHERE ExamID = @ExamID;

    PRINT ' Exam updated successfully.';
END;
GO

-- (3) Select Exam Stored Procedure
CREATE PROCEDURE sp_GetExam
    @ExamID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @ExamID IS NULL
        SELECT * FROM Exam;
    ELSE
        SELECT * FROM Exam WHERE ExamID = @ExamID;
END;
GO

-- (4) Delete Exam Stored Procedure

Create PROCEDURE sp_DeleteExam
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM Exam WHERE ExamID = @ExamID;

        PRINT ' Exam deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ' Error: Could not delete the exam. It may be linked to other tables like Exam_Question or Student_Exam.';
        PRINT ' SQL Error Message: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


------------------------------------
-- Exam Stored Procedure Testing
------------------------------------

-- (1) Insert Testing
EXEC sp_InsertExam 
    @ExamType = 'Midterm',
    @TotalMarks = 100,
    @PassingScore = 50,
    @Duration = 90,
    @ScheduleDate = '2025-07-10 10:00',
    @CourseCode = 'AI86';

-- (2) Update Testing
EXEC sp_UpdateExam
    @ExamID = 1,
    @ExamType = 'Final',
    @TotalMarks = 100,
    @PassingScore = 60,
    @Duration = 120,
    @ScheduleDate = '2025-07-20 09:00',
    @CourseCode = 'AM101';

-- (3.1) Select One Testing
EXEC sp_GetExam @ExamID = 1;

-- (3.2) Select All Testing
EXEC sp_GetExam;

-- (4) Delete Testing
EXEC sp_DeleteExam @ExamID = 1;
