CREATE PROCEDURE AddNewUserWithRole
    @Username VARCHAR(30),
    @FirstName VARCHAR(30),
    @LastName VARCHAR(30),
    @Salary DECIMAL(10,2),
    @Email VARCHAR(100),
    @DateOfBirth DATE,
    @Gender CHAR(1),
    @PasswordHash VARCHAR(255),
    @BranchID INT,
    @Address VARCHAR(200),

    @Role VARCHAR(30), -- 'Student', 'Instructor', 'Admin'

    -- Student-specific
    @Major VARCHAR(100) = NULL,
    @GPA DECIMAL(3,2) = NULL,
    @IntakeID VARCHAR(20) = NULL,
    @TrackID INT = NULL,

    -- Instructor-specific
    @ExpertiseArea VARCHAR(100) = NULL,
    @InstructorHiringDate DATE = NULL,
    @ContractType VARCHAR(20) = NULL,
    @InstructorDegree VARCHAR(20) = NULL,

    -- Admin-specific
    @AdminPosition VARCHAR(50) = NULL,
    @AdminHiringDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if username or email already exists
        IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
            THROW 51001, 'Username already exists.', 1;

        IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
            THROW 51002, 'Email already exists.', 1;

        -- Insert User
        INSERT INTO Users (
            Username, FirstName, LastName, Salary, Email, DateOfBirth,
            Gender, PasswordHash, BranchID, [Address]
        )
        VALUES (
            @Username, @FirstName, @LastName, @Salary, @Email, @DateOfBirth,
            @Gender, @PasswordHash, @BranchID, @Address
        );

        DECLARE @NewUserID INT = SCOPE_IDENTITY();

        -- Add to UserRoles
        INSERT INTO UserRoles (UserID, Role)
        VALUES (@NewUserID, @Role);

        -- Insert into role-specific table
        IF @Role = 'Student'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Intake WHERE IntakeID = @IntakeID)
                THROW 51003, 'Invalid IntakeID.', 1;
            IF NOT EXISTS (SELECT 1 FROM Track WHERE TrackID = @TrackID)
                THROW 51004, 'Invalid TrackID.', 1;

            INSERT INTO Student (StudentID, Major, CollageGPA, IntakeID, TrackID)
            VALUES (@NewUserID, @Major, @GPA, @IntakeID, @TrackID);
        END
        ELSE IF @Role = 'Instructor'
        BEGIN
            INSERT INTO Instructor (InstructorID, ExpertiseArea, HiringDate, ContractType, InstructorDegrea)
            VALUES (@NewUserID, @ExpertiseArea, @InstructorHiringDate, @ContractType, @InstructorDegree);
        END
        ELSE IF @Role = 'Admin'
        BEGIN
            INSERT INTO Admin (AdminID, Position, HiringDate)
            VALUES (@NewUserID, @AdminPosition, @AdminHiringDate);
        END
        ELSE
        BEGIN
            THROW 51005, 'Invalid role provided.', 1;
        END

        COMMIT TRANSACTION;
        PRINT ' User added successfully with role: ' + @Role;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;

-- Student test

EXEC AddNewUserWithRole
    @Username = 'mona123',
    @FirstName = 'Mona',
    @LastName = 'Ali',
    @Salary = 3000,
    @Email = 'mona.ali@example.com',
    @DateOfBirth = '2001-08-10',
    @Gender = 'F',
    @PasswordHash = 'hashed_pw',
    @BranchID = 1,
    @Address = 'Mansoura',
    @Role = 'Student',
    @Major = 'Software Engineering',
    @GPA = 3.6,
    @IntakeID = 'P3-2024-S2',
    @TrackID = 5;


-- Instructor test
EXEC AddNewUserWithRole
    @Username = 'hassan.tech',
    @FirstName = 'Hassan',
    @LastName = 'Tarek',
    @Salary = 12000,
    @Email = 'hassan.tarek@example.com',
    @DateOfBirth = '1980-11-12',
    @Gender = 'M',
    @PasswordHash = 'hashed_pw',
    @BranchID = 2,
    @Address = 'Alexandria',
    @Role = 'Instructor',
    @ExpertiseArea = 'Machine Learning',
    @InstructorHiringDate = '2024-03-01',
    @ContractType = 'Internal',
    @InstructorDegree = 'Master';


-- admin test
EXEC AddNewUserWithRole
    @Username = 'nada.admin',
    @FirstName = 'Nada',
    @LastName = 'Fathy',
    @Salary = 15000,
    @Email = 'nada.fathy@example.com',
    @DateOfBirth = '1975-05-05',
    @Gender = 'F',
    @PasswordHash = 'hashed_pw',
    @BranchID = 3,
    @Address = 'Tanta',
    @Role = 'Admin',
    @AdminPosition = 'Program Manager',
    @AdminHiringDate = '2023-12-01';

select * from users;