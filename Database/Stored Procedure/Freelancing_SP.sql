----------------------------
-- (1) Insert Freelance Job
----------------------------
CREATE PROCEDURE sp_InsertFreelanceJob
    @StudentID INT,
    @JobTitle VARCHAR(200),
    @Description TEXT,
    @ClientNationality VARCHAR(20),
    @Platform VARCHAR(50),
    @CompensationAmountInDollar DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found.', 16, 1);
            RETURN;
        END

        INSERT INTO FreelanceJob (StudentID, JobTitle, Description, ClientNationality, Platform, CompensationAmountInDollar)
        VALUES (@StudentID, @JobTitle, @Description, @ClientNationality, @Platform, @CompensationAmountInDollar);

        PRINT 'Freelance job inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

----------------------------
-- (2) Select All Freelance Jobs
----------------------------
CREATE PROCEDURE sp_SelectAllFreelanceJobs
AS
BEGIN
    SELECT * FROM FreelanceJob;
END;
GO

----------------------------
-- (3) Select Freelance Jobs By Student
----------------------------
CREATE PROCEDURE sp_SelectFreelanceJobsByStudent
    @StudentID INT
AS
BEGIN
    SELECT * FROM FreelanceJob WHERE StudentID = @StudentID;
END;
GO

----------------------------
-- (4) Update Freelance Job
----------------------------
CREATE PROCEDURE sp_UpdateFreelanceJob
    @FreelanceJobID INT,
    @JobTitle VARCHAR(200),
    @Description TEXT,
    @ClientNationality VARCHAR(20),
    @Platform VARCHAR(50),
    @CompensationAmountInDollar DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM FreelanceJob WHERE FreelanceJobID = @FreelanceJobID)
        BEGIN
            RAISERROR('Freelance job not found.', 16, 1);
            RETURN;
        END

        UPDATE FreelanceJob
        SET JobTitle = @JobTitle,
            Description = @Description,
            ClientNationality = @ClientNationality,
            Platform = @Platform,
            CompensationAmountInDollar = @CompensationAmountInDollar
        WHERE FreelanceJobID = @FreelanceJobID;

        PRINT 'Freelance job updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

----------------------------
-- (5) Delete Freelance Job
----------------------------
CREATE PROCEDURE sp_DeleteFreelanceJob
    @FreelanceJobID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM FreelanceJob WHERE FreelanceJobID = @FreelanceJobID)
        BEGIN
            RAISERROR('Freelance job not found.', 16, 1);
            RETURN;
        END

        DELETE FROM FreelanceJob WHERE FreelanceJobID = @FreelanceJobID;
        PRINT 'Freelance job deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insert Test
EXEC sp_InsertFreelanceJob
    @StudentID = 301,
    @JobTitle = 'Mobile App Development',
    @Description = 'Built an Android app for e-commerce.',
    @ClientNationality = 'USA',
    @Platform = 'Upwork',
    @CompensationAmountInDollar = 750.00;

-- Select All
EXEC sp_SelectAllFreelanceJobs;

-- Select by Student
EXEC sp_SelectFreelanceJobsByStudent @StudentID = 301;

-- Update Job
EXEC sp_UpdateFreelanceJob
    @FreelanceJobID = 2001,
    @JobTitle = 'Mobile App + Dashboard',
    @Description = 'Upgraded the app and built admin dashboard.',
    @ClientNationality = 'USA',
    @Platform = 'Upwork',
    @CompensationAmountInDollar = 1200.00;

-- Delete Job
EXEC sp_DeleteFreelanceJob @FreelanceJobID = 2001;
