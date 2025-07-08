----------------------------
-- Program Stored Procedures
----------------------------

-- (1) Insert Program Stored Procedure
CREATE OR ALTER PROCEDURE sp_InsertProgram
    @ProgramName VARCHAR(100),
    @Description TEXT,
    @DurationInMonths INT,
    @AdminID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if Program Name already exists
        IF EXISTS (SELECT 1 FROM Program WHERE ProgramName = @ProgramName)
        BEGIN
            PRINT 'Error: Program with the same name already exists.';
            RETURN;
        END

        -- Check if Admin exists
        IF NOT EXISTS (SELECT 1 FROM Admin WHERE AdminID = @AdminID)
        BEGIN
            PRINT 'Error: AdminID not found.';
            RETURN;
        END

        -- Insert
        INSERT INTO Program (ProgramName, Description, DurationInMonths, AdminID)
        VALUES (@ProgramName, @Description, @DurationInMonths, @AdminID);

        PRINT 'Program inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error inserting program: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- (2) Update Program Stored Procedure
CREATE OR ALTER PROCEDURE sp_UpdateProgram
    @ProgramID INT,
    @ProgramName VARCHAR(100),
    @Description TEXT,
    @DurationInMonths INT,
    @AdminID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if ProgramID exists
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramID = @ProgramID)
        BEGIN
            PRINT 'Error: ProgramID does not exist.';
            RETURN;
        END

        -- Check if Admin exists
        IF NOT EXISTS (SELECT 1 FROM Admin WHERE AdminID = @AdminID)
        BEGIN
            PRINT 'Error: AdminID not found.';
            RETURN;
        END

        -- Update
        UPDATE Program
        SET ProgramName = @ProgramName,
            Description = @Description,
            DurationInMonths = @DurationInMonths,
            AdminID = @AdminID
        WHERE ProgramID = @ProgramID;

        PRINT 'Program updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error updating program: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- (3) Select Program Stored Procedure
CREATE OR ALTER PROCEDURE sp_GetProgram
    @ProgramID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @ProgramID IS NULL
        SELECT * FROM Program;
    ELSE
        SELECT * FROM Program WHERE ProgramID = @ProgramID;
END;
GO

-- (4) Delete Program Stored Procedure
CREATE OR ALTER PROCEDURE sp_DeleteProgram
    @ProgramID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramID = @ProgramID)
        BEGIN
            PRINT 'Error: ProgramID does not exist.';
            RETURN;
        END

        DELETE FROM Program WHERE ProgramID = @ProgramID;

        PRINT 'Program deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error deleting program: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-------------------------------------
-- Program Stored Procedure Testing
-------------------------------------

-- (1) Insert Testing
EXEC sp_InsertProgram 
    @ProgramName = 'Intensive Code Camp',
    @Description = 'Focused technical training on various development tracks.',
    @DurationInMonths = 4,
    @AdminID = 1;

-- (2) Update Testing
EXEC sp_UpdateProgram
    @ProgramID = 1,
    @ProgramName = 'Professional Training Program',
    @Description = 'A comprehensive 9-month program across multiple domains.',
    @DurationInMonths = 9,
    @AdminID = 1;

-- (3.1) Select One Testing
EXEC sp_GetProgram @ProgramID = 1;

-- (3.2) Select All Testing
EXEC sp_GetProgram;

-- (4) Delete Testing
EXEC sp_DeleteProgram @ProgramID = 14;


DBCC CHECKIDENT ('Program', RESEED, 3);
