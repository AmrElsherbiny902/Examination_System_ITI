----------------------------
-- (1) Insert Graduated Student
----------------------------
CREATE PROCEDURE sp_InsertGraduatedStudent
    @StudentID INT,
    @PositionTitle VARCHAR(100),
    @HiringStatus VARCHAR(30),
    @CompanyName VARCHAR(100),
    @CompanyLevel VARCHAR(30),
    @FinalEvaluation INT,
    @GradutationDate DATE
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student does not exist.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM GraduatedStudent WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('This student is already marked as graduated.', 16, 1);
            RETURN;
        END

        INSERT INTO GraduatedStudent (
            StudentID, PositionTitle, HiringStatus, CompanyName,
            CompanyLevel, FinalEvaluation, GradutationDate)
        VALUES (
            @StudentID, @PositionTitle, @HiringStatus, @CompanyName,
            @CompanyLevel, @FinalEvaluation, @GradutationDate);

        PRINT 'Graduated student inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

----------------------------
-- (2) Select All Graduated Students
----------------------------
CREATE PROCEDURE sp_SelectAllGraduatedStudents
AS
BEGIN
    SELECT * FROM GraduatedStudent;
END;
GO

----------------------------
-- (3) Select Graduated Student by ID
----------------------------
CREATE PROCEDURE sp_SelectGraduatedStudentByID
    @StudentID INT
AS
BEGIN
    SELECT * FROM GraduatedStudent WHERE StudentID = @StudentID;
END;
GO

----------------------------
-- (4) Update Graduated Student
----------------------------
CREATE PROCEDURE sp_UpdateGraduatedStudent
    @StudentID INT,
    @PositionTitle VARCHAR(100),
    @HiringStatus VARCHAR(30),
    @CompanyName VARCHAR(100),
    @CompanyLevel VARCHAR(30),
    @FinalEvaluation INT,
    @GradutationDate DATE
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM GraduatedStudent WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Graduated student not found.', 16, 1);
            RETURN;
        END

        UPDATE GraduatedStudent
        SET PositionTitle = @PositionTitle,
            HiringStatus = @HiringStatus,
            CompanyName = @CompanyName,
            CompanyLevel = @CompanyLevel,
            FinalEvaluation = @FinalEvaluation,
            GradutationDate = @GradutationDate
        WHERE StudentID = @StudentID;

        PRINT 'Graduated student updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

----------------------------
-- (5) Delete Graduated Student
----------------------------
CREATE PROCEDURE sp_DeleteGraduatedStudent
    @StudentID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM GraduatedStudent WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Graduated student not found.', 16, 1);
            RETURN;
        END

        DELETE FROM GraduatedStudent WHERE StudentID = @StudentID;
        PRINT 'Graduated student deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insert Test
EXEC sp_InsertGraduatedStudent
    @StudentID = 314,
    @PositionTitle = 'Junior BI Analyst',
    @HiringStatus = 'Hired',
    @CompanyName = 'Vodafone',
    @CompanyLevel = 'Multinational',
    @FinalEvaluation = 85,
    @GradutationDate = '2025-06-01';

-- Select All
EXEC sp_SelectAllGraduatedStudents;

-- Select by ID
EXEC sp_SelectGraduatedStudentByID @StudentID = 1;

-- Update
EXEC sp_UpdateGraduatedStudent
    @StudentID = 1,
    @PositionTitle = 'BI Analyst',
    @HiringStatus = 'Promoted',
    @CompanyName = 'Vodafone Egypt',
    @CompanyLevel = 'Multinational',
    @FinalEvaluation = 90,
    @GradutationDate = '2025-06-01';

-- Delete
EXEC sp_DeleteGraduatedStudent @StudentID = 1;
