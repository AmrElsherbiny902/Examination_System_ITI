---------------------------
-- branch stored procedure
---------------------------

-- (1) Insert branch Stored Procedure
CREATE PROCEDURE sp_InsertBranch
    @BranchName VARCHAR(100),
    @Location VARCHAR(100),
    @ContactEmail VARCHAR(100),
    @ContactPhone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Branch (BranchName, [Location], ContactEmail, ContactPhone)
    VALUES (@BranchName, @Location, @ContactEmail, @ContactPhone);

    PRINT ' Branch inserted successfully.';
END;
GO

-- (2) Update branch Stored Procedure

CREATE PROCEDURE sp_UpdateBranch
    @BranchID INT,
    @BranchName VARCHAR(100),
    @Location VARCHAR(100),
    @ContactEmail VARCHAR(100),
    @ContactPhone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Branch
    SET BranchName = @BranchName,
        [Location] = @Location,
        ContactEmail = @ContactEmail,
        ContactPhone = @ContactPhone
    WHERE BranchID = @BranchID;

    PRINT ' Branch updated successfully.';
END;
GO

-- (3) Select branch Stored Procedure
CREATE PROCEDURE sp_GetBranch
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @BranchID IS NULL
        SELECT * FROM Branch;
    ELSE
        SELECT * FROM Branch WHERE BranchID = @BranchID;
END;
GO

-- (4) delete branch Stored Procedure

CREATE PROCEDURE sp_DeleteBranch
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Branch WHERE BranchID = @BranchID;

    PRINT ' Branch deleted successfully.';
END;
GO

----------------------------------
-- branch stored procedure testing
----------------------------------

-- (1) Insert testing
EXEC sp_InsertBranch 
    @BranchName = ' Isamilia Branch ',
    @Location = 'Isamilia',
    @ContactEmail = 'Isamilia@iti.org',
    @ContactPhone = '01011112222';

-- (2) Update testing
EXEC sp_UpdateBranch
    @BranchID = 17,
    @BranchName = 'Qantra Branch',
    @Location = 'Qantra',
    @ContactEmail = 'Qantra@iti.org',
    @ContactPhone = '01066666666';

-- (3.1) Select one testing
EXEC sp_GetBranch @BranchID = 17;

-- (3.2) Select all testing
EXEC sp_GetBranch ;

-- (4) delete testing
EXEC sp_DeleteBranch @BranchID = 1;