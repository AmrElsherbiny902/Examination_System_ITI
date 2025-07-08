----------------------------
-- CertificateKPIs Stored Procedures
----------------------------

-- (1) Insert CertificateKPIs
CREATE PROCEDURE sp_InsertCertificate
    @CertID INT,
    @CertificateName VARCHAR(100),
    @CertificateSource VARCHAR(100),
    @Cost DECIMAL(10,2),
    @CrsHours INT,
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if Student exists
        IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student does not exist.', 16, 1);
            RETURN;
        END

        INSERT INTO CertificateKPIs (CertID, CertificateName, CertificateSource, Cost, CrsHours, StudentID)
        VALUES (@CertID, @CertificateName, @CertificateSource, @Cost, @CrsHours, @StudentID);

        PRINT 'Certificate inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- (2) Update CertificateKPIs
CREATE PROCEDURE sp_UpdateCertificate
    @CertID INT,
    @CertificateName VARCHAR(100),
    @CertificateSource VARCHAR(100),
    @Cost DECIMAL(10,2),
    @CrsHours INT,
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM CertificateKPIs WHERE CertID = @CertID)
        BEGIN
            RAISERROR('Certificate does not exist.', 16, 1);
            RETURN;
        END

        UPDATE CertificateKPIs
        SET CertificateName = @CertificateName,
            CertificateSource = @CertificateSource,
            Cost = @Cost,
            CrsHours = @CrsHours,
            StudentID = @StudentID
        WHERE CertID = @CertID;

        PRINT 'Certificate updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- (3) Select CertificateKPIs
CREATE PROCEDURE sp_GetCertificate
    @CertID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @CertID IS NULL
        SELECT * FROM CertificateKPIs;
    ELSE
        SELECT * FROM CertificateKPIs WHERE CertID = @CertID;
END;
GO

-- (4) Delete CertificateKPIs
CREATE PROCEDURE sp_DeleteCertificate
    @CertID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM CertificateKPIs WHERE CertID = @CertID;
        PRINT 'Certificate deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

----------------------------
-- CertificateKPIs Testing
----------------------------

-- Insert
EXEC sp_InsertCertificate
    @CertID = 1989,
    @CertificateName = 'Microsoft Azure Fundamentals',
    @CertificateSource = 'Microsoft',
    @Cost = 99.99,
    @CrsHours = 20,
    @StudentID = 301;

-- Update
EXEC sp_UpdateCertificate
    @CertID = 1989,
    @CertificateName = 'Azure AI Fundamentals',
    @CertificateSource = 'Microsoft',
    @Cost = 120.00,
    @CrsHours = 25,
    @StudentID = 301;

-- Select all
EXEC sp_GetCertificate;

-- Select one
EXEC sp_GetCertificate @CertID = 1989;

-- Delete
EXEC sp_DeleteCertificate @CertID = 1989;

