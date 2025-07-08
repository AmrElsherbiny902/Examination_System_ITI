---------------------------
-- Course Stored Procedures
---------------------------

-- (1) Insert Course Stored Procedure
CREATE PROCEDURE sp_InsertCourse
    @CourseCode VARCHAR(10),
    @CourseName VARCHAR(100),
    @Hours INT,
    @Credits INT,
    @Prerequisites VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Course (CourseCode, CourseName, Hours, Credits, Prerequisites)
    VALUES (@CourseCode, @CourseName, @Hours, @Credits, @Prerequisites);

    PRINT ' Course inserted successfully.';
END;
GO

-- (2) Update Course Stored Procedure
CREATE PROCEDURE sp_UpdateCourse
    @CourseCode VARCHAR(10),
    @CourseName VARCHAR(100),
    @Hours INT,
    @Credits INT,
    @Prerequisites VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Course
    SET CourseName = @CourseName,
        Hours = @Hours,
        Credits = @Credits,
        Prerequisites = @Prerequisites
    WHERE CourseCode = @CourseCode;

    PRINT ' Course updated successfully.';
END;
GO

-- (3) Select Course Stored Procedure
CREATE PROCEDURE sp_GetCourse
    @CourseCode VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @CourseCode IS NULL
        SELECT * FROM Course;
    ELSE
        SELECT * FROM Course WHERE CourseCode = @CourseCode;
END;
GO

-- (4) Delete Course Stored Procedure
CREATE PROCEDURE sp_DeleteCourse
    @CourseCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Course WHERE CourseCode = @CourseCode;

    PRINT ' Course deleted successfully.';
END;
GO

----------------------------------
-- Course Stored Procedure Testing
----------------------------------

-- (1.1) Insert Testing
EXEC sp_InsertCourse 
    @CourseCode = 'AM101',
    @CourseName = 'Data Mining',
    @Hours = 40,
    @Credits = 3,
    @Prerequisites = NULL;

-- (1.2) Insert Testing
EXEC sp_InsertCourse 
    @CourseCode = 'FE201',
    @CourseName = 'Front End Development',
    @Hours = 50,
    @Credits = 4,
    @Prerequisites = 'FE101';

-- (2) Update Testing
  

-- (3.1) Select One Testing
EXEC sp_GetCourse @CourseCode = 'AI17';

-- (3.2) Select All Testing
EXEC sp_GetCourse;

-- (4) Delete Testing
EXEC sp_DeleteCourse @CourseCode = 'DM101';

