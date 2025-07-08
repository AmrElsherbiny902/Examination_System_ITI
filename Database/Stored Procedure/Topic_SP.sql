----------------------------
-- Topic Stored Procedures
----------------------------

-- (1) Insert Topic Stored Procedure
CREATE PROCEDURE sp_InsertTopic
    @TopicTitle VARCHAR(100),
    @CourseCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if Course exists
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseCode = @CourseCode)
    BEGIN
        PRINT 'Error: CourseCode not found.';
        RETURN;
    END

    INSERT INTO Topic (TopicTitle, CourseCode)
    VALUES (@TopicTitle, @CourseCode);

    PRINT 'Topic inserted successfully.';
END;
GO

-- (2) Update Topic Stored Procedure
CREATE PROCEDURE sp_UpdateTopic
    @TopicID INT,
    @TopicTitle VARCHAR(100),
    @CourseCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if Topic exists
    IF NOT EXISTS (SELECT 1 FROM Topic WHERE TopicID = @TopicID)
    BEGIN
        PRINT 'Error: TopicID not found.';
        RETURN;
    END

    -- Check if Course exists
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseCode = @CourseCode)
    BEGIN
        PRINT 'Error: CourseCode not found.';
        RETURN;
    END

    UPDATE Topic
    SET TopicTitle = @TopicTitle,
        CourseCode = @CourseCode
    WHERE TopicID = @TopicID;

    PRINT 'Topic updated successfully.';
END;
GO

-- (3) Select Topic Stored Procedure
CREATE PROCEDURE sp_GetTopic
    @TopicID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @TopicID IS NULL
        SELECT * FROM Topic;
    ELSE
        SELECT * FROM Topic WHERE TopicID = @TopicID;
END;
GO

-- (4) Delete Topic Stored Procedure
CREATE PROCEDURE sp_DeleteTopic
    @TopicID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if Topic exists
    IF NOT EXISTS (SELECT 1 FROM Topic WHERE TopicID = @TopicID)
    BEGIN
        PRINT 'Error: TopicID not found.';
        RETURN;
    END

    DELETE FROM Topic WHERE TopicID = @TopicID;

    PRINT 'Topic deleted successfully.';
END;
GO

------------------------------------
-- Topic Stored Procedure Testing
------------------------------------

-- Step 0: Insert Course for FK
INSERT INTO Course (CourseCode, CourseName, Hours, Credits)
VALUES ('SQL101', 'SQL Basics', 30, 3);

-- (1) Insert Topic
EXEC sp_InsertTopic 
    @TopicTitle = 'Introduction to SQL',
    @CourseCode = 'SQL101';

-- (2) Update Topic
EXEC sp_UpdateTopic 
    @TopicID = 1,
    @TopicTitle = 'Advanced SQL Joins',
    @CourseCode = 'SQL101';

-- (3.1) Select one Topic
EXEC sp_GetTopic @TopicID = 101;

-- (3.2) Select all Topics
EXEC sp_GetTopic;

-- (4) Delete Topic
EXEC sp_DeleteTopic @TopicID = 102;
