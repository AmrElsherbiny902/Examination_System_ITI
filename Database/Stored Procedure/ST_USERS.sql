CREATE PROCEDURE AddNewStudent
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
    @Major VARCHAR(100),
    @GPA DECIMAL(3,2),
    @IntakeID VARCHAR(20),
    @TrackID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Insert into Users
        INSERT INTO Users (
            Username, FirstName, LastName, Salary, Email, DateOfBirth,
            Gender, PasswordHash, BranchID, [Address]
        )
        VALUES (
            @Username, @FirstName, @LastName, @Salary, @Email, @DateOfBirth,
            @Gender, @PasswordHash, @BranchID, @Address
        );

        -- Capture the newly created UserID
        DECLARE @NewUserID INT = SCOPE_IDENTITY();

        -- Step 2: Assign 'Student' role
        INSERT INTO UserRoles (UserID, Role)
        VALUES (@NewUserID, 'Student');

        -- Step 3: Insert into Student table
        INSERT INTO Student (
            StudentID, Major, CollageGPA, IntakeID, TrackID
        )
        VALUES (
            @NewUserID, @Major, @GPA, @IntakeID, @TrackID
        );

        COMMIT TRANSACTION;
        PRINT 'Student added successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- CALLING ST

EXEC AddNewStudent
    @Username = 'ahmed1234577',
    @FirstName = 'Ahmed',
    @LastName = 'Samir',
    @Salary = 4500.00,
    @Email = 'ahmed.reda@example.com',
    @DateOfBirth = '2000-06-01',
    @Gender = 'M',
    @PasswordHash = 'hashed_password_here',
    @BranchID = 1,
    @Address = 'Nasr City, Cairo',
    @Major = 'Computer Engineering',
    @GPA = 3.75,
    @IntakeID = 'P3-2024-S2',
    @TrackID = 27;




/*  DBCC CHECKIDENT ('Users', NORESEED);
	  -- Reset seed to last known ID
DBCC CHECKIDENT ('Users', RESEED, 1303);

select * from Users where UserID=1305


delete from student where StudentID=1305
delete from users where UserID=2002*/




Alter PROCEDURE AddNewUserWithRoles
    -- Basic user details
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

    -- Role flags
    @IsInstructor BIT = 0,
    @IsAdmin BIT = 0,

    -- Admin-specific fields
    @AdminPosition VARCHAR(50) = NULL,
    @AdminHiringDate DATE = NULL,

    -- Instructor-specific fields
    @ExpertiseArea VARCHAR(100) = NULL,
    @InstructorHiringDate DATE = NULL,
    @ContractType VARCHAR(20) = NULL,
    @InstructorDegree VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate role assignment: Student is NOT allowed here
    IF @IsInstructor = 0 AND @IsAdmin = 0
    BEGIN
        RAISERROR('You must assign at least one valid role: Instructor or Admin.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 👤 Step 1: Insert user into Users table
        INSERT INTO Users (
            Username, FirstName, LastName, Salary, Email, DateOfBirth,
            Gender, PasswordHash, BranchID, [Address]
        )
        VALUES (
            @Username, @FirstName, @LastName, @Salary, @Email, @DateOfBirth,
            @Gender, @PasswordHash, @BranchID, @Address
        );

        -- 🆔 Capture the auto-generated UserID for use in other tables
        DECLARE @NewUserID INT = SCOPE_IDENTITY();

        -- 🎓 Step 2: Insert Instructor role + Instructor table (if selected)
        IF @IsInstructor = 1
        BEGIN
            -- Add role
            INSERT INTO UserRoles (UserID, Role)
            VALUES (@NewUserID, 'Instructor');

            -- Add to Instructor table
            INSERT INTO Instructor (
                InstructorID, ExpertiseArea, HiringDate, ContractType, InstructorDegrea
            )
            VALUES (
                @NewUserID, @ExpertiseArea, @InstructorHiringDate, @ContractType, @InstructorDegree
            );
        END

        --  Step 3: Insert Admin role + Admin table (if selected)
        IF @IsAdmin = 1
        BEGIN
            -- Add role
            INSERT INTO UserRoles (UserID, Role)
            VALUES (@NewUserID, 'Admin');

            -- Add to Admin table
            INSERT INTO Admin (
                AdminID, Position, HiringDate
            )
            VALUES (
                @NewUserID, @AdminPosition, @AdminHiringDate
            );
        END

        -- Commit transaction after all inserts succeed
        COMMIT TRANSACTION;
        PRINT 'User added successfully with the specified role(s).';
    END TRY
    BEGIN CATCH
        --  Rollback all changes if any error occurs
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



EXEC AddNewUserWithRoles
    @Username = 'tamer223',
    @FirstName = 'Tamer',
    @LastName = 'Osman',
    @Salary = 10000,
    @Email = 'tamer.osman@exampddle.com',
    @DateOfBirth = '1985-07-15',
    @Gender = 'M',
    @PasswordHash = 'hashed_pass_1',
    @BranchID = 2,
    @Address = 'Giza',

    @IsInstructor = 1,
    @ExpertiseArea = 'Cyber Security',
    @InstructorHiringDate = '2024-01-01',
    @ContractType = 'Internal',
    @InstructorDegree = 'PHD';

	/*select * from Instructor
	where ExpertiseArea='Cyber Security'

	select * from users 
	where UserID=1306*/












/*
information_schema.columns
select name , collation_name from sys.databases

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS*/

