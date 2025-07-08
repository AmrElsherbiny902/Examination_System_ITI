----------------------------
-- Track Stored Procedures
----------------------------

-- (1) Insert Track Stored Procedure
CREATE PROCEDURE sp_InsertTrack
    @TrackID INT,
    @TrackName VARCHAR(100),
    @Description TEXT,
    @AdminID INT,
    @ProgramID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Admin WHERE AdminID = @AdminID)
    BEGIN
        PRINT ' Error: Admin ID does not exist.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramID = @ProgramID)
    BEGIN
        PRINT ' Error: Program ID does not exist.';
        RETURN;
    END

    INSERT INTO Track (TrackID, TrackName, Description, AdminID, ProgramID)
    VALUES (@TrackID, @TrackName, @Description, @AdminID, @ProgramID);

    PRINT 'Track inserted successfully.';
END;
GO

-- (2) Update Track Stored Procedure
CREATE PROCEDURE sp_UpdateTrack
    @TrackID INT,
    @TrackName VARCHAR(100),
    @Description TEXT,
    @AdminID INT,
    @ProgramID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Track WHERE TrackID = @TrackID)
    BEGIN
        PRINT ' Error: Track ID not found.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Admin WHERE AdminID = @AdminID)
    BEGIN
        PRINT ' Error: Admin ID does not exist.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramID = @ProgramID)
    BEGIN
        PRINT ' Error: Program ID does not exist.';
        RETURN;
    END

    UPDATE Track
    SET TrackName = @TrackName,
        Description = @Description,
        AdminID = @AdminID,
        ProgramID = @ProgramID
    WHERE TrackID = @TrackID;

    PRINT ' Track updated successfully.';
END;
GO

-- (3) Select Track Stored Procedure
CREATE PROCEDURE sp_GetTrack
    @TrackID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @TrackID IS NULL
        SELECT * FROM Track;
    ELSE
        SELECT * FROM Track WHERE TrackID = @TrackID;
END;
GO

-- (4) Delete Track Stored Procedure
CREATE PROCEDURE sp_DeleteTrack
    @TrackID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Track WHERE TrackID = @TrackID)
    BEGIN
        PRINT ' Error: Track ID not found.';
        RETURN;
    END

    DELETE FROM Track WHERE TrackID = @TrackID;
    PRINT 'Track deleted successfully.';
END;
GO

------------------------------------
-- Track Stored Procedure Testing
------------------------------------

-- (1) Insert Test
EXEC sp_InsertTrack 
    @TrackID = 101,
    @TrackName = 'Fullstack Python',
    @Description = 'Python + Django + React',
    @AdminID = 1,
    @ProgramID = 1;

-- (2) Update Test
EXEC sp_UpdateTrack 
    @TrackID = 101,
    @TrackName = 'Python Web Development',
    @Description = 'Django, React, PostgreSQL',
    @AdminID = 1,
    @ProgramID = 1;

-- (3.1) Select One Test
EXEC sp_GetTrack @TrackID = 101;

-- (3.2) Select All Test
EXEC sp_GetTrack;

-- (4) Delete Test
EXEC sp_DeleteTrack @TrackID = 101;
