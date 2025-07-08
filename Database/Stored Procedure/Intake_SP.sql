----------------------------
-- Intake Stored Procedures
----------------------------

-- (1) Insert Intake Stored Procedure
CREATE PROCEDURE sp_InsertIntake
    @IntakeID VARCHAR(20),
    @IntakeType VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @ProgramID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Intake (IntakeID, IntakeType, StartDate, EndDate, ProgramID)
    VALUES (@IntakeID, @IntakeType, @StartDate, @EndDate, @ProgramID);

    PRINT 'Intake inserted successfully.';
END;
GO

-- (2) Update Intake Stored Procedure
CREATE PROCEDURE sp_UpdateIntake
    @IntakeID VARCHAR(20),
    @IntakeType VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @ProgramID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Intake
    SET IntakeType = @IntakeType,
        StartDate = @StartDate,
        EndDate = @EndDate,
        ProgramID = @ProgramID
    WHERE IntakeID = @IntakeID;

    PRINT ' Intake updated successfully.';
END;
GO

-- (3) Select Intake Stored Procedure
CREATE PROCEDURE sp_GetIntake
    @IntakeID VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @IntakeID IS NULL
        SELECT * FROM Intake;
    ELSE
        SELECT * FROM Intake WHERE IntakeID = @IntakeID;
END;
GO

-- (4) Delete Intake Stored Procedure
CREATE PROCEDURE sp_DeleteIntake
    @IntakeID VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Intake WHERE IntakeID = @IntakeID;

    PRINT ' Intake deleted successfully.';
END;
GO

------------------------------------
-- Intake Stored Procedure Testing
------------------------------------

-- (1) Insert Testing
EXEC sp_InsertIntake 
    @IntakeID = 'PRG2025-FD',
    @IntakeType = 'Full-time Day',
    @StartDate = '2025-01-10',
    @EndDate = '2025-10-10',
    @ProgramID = 1;

-- (2) Update Testing
EXEC sp_UpdateIntake
    @IntakeID = 'PRG2025-FD',
    @IntakeType = 'Weekend Bootcamp',
    @StartDate = '2025-01-15',
    @EndDate = '2025-10-20',
    @ProgramID = 1;

-- (3.1) Select One Testing
EXEC sp_GetIntake @IntakeID = 'PRG2025-FD';

-- (3.2) Select All Testing
EXEC sp_GetIntake;

-- (4) Delete Testing
EXEC sp_DeleteIntake @IntakeID = 'PRG2025-FD';
