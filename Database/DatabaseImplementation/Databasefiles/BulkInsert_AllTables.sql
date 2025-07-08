USE LearningManagementSystem;
GO
SET IDENTITY_INSERT Branch ON;
BULK INSERT Branch
FROM 'D:\2025\LMS\Data\Branch.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT Branch OFF;
GO
SET IDENTITY_INSERT Users ON;
BULK INSERT Users
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Users.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT Users OFF;
GO
BULK INSERT UserRoles
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\UserRoles.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Admin
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Admin.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
SET IDENTITY_INSERT Program ON;
BULK INSERT Program
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Program.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT Program OFF;
GO
BULK INSERT Intake
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Intake.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Track
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Track.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Student
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Student.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Instructor
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Instructor.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Course
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Course.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Branch_Intake_Track
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Branch_Intake_Track.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Course_Track
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Course_Track.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Instructor_Course
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Instructor_Course.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Instructor_Track
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Instructor_Track.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Student_Course
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Student_Course.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
SET IDENTITY_INSERT Exam ON;
BULK INSERT Exam
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Exam.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT Exam OFF;
GO
SET IDENTITY_INSERT Question ON;
BULK INSERT Question
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Real_Question_300_FINAL.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT Question OFF;
GO

SET IDENTITY_INSERT Options ON;

BULK INSERT Options
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Real_Options_300_FINAL_PIPE.csv'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);

SET IDENTITY_INSERT Options OFF;


GO
BULK INSERT Exam_Question
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Exam_Question.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
BULK INSERT Student_Exam
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Student_Exam.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO

-- For SQL Server
-- Correct BULK INSERT syntax for your case
BULK INSERT GraduatedStudent
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\GraduatedStudent_FINAL_STRIPPED_ANSI.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);


GO
BULK INSERT CertificateKPIs
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\CertificateKPIs.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
-- Find default constraint name for FeedbackDate



GO
SET IDENTITY_INSERT JobProfile ON;
BULK INSERT JobProfile
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\JobProfile.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT JobProfile OFF;
GO
BULK INSERT Track_JobProfile
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\Track_JobProfile.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
GO
SET IDENTITY_INSERT FreelanceJob ON;
BULK INSERT FreelanceJob
FROM 'D:\2025\ITI power BI intenseve program\graduation project\Data\FreelanceJob_FULL_FIXED.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK,
    KEEPIDENTITY
);
SET IDENTITY_INSERT FreelanceJob OFF;
GO

