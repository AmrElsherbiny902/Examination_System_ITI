
USE master;
GO

-- Create database with appropriate settings
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'LearningManagementSystem')
BEGIN
    CREATE DATABASE LearningManagementSystem
    COLLATE SQL_Latin1_General_CP1_CI_AS;          -- language(English ,Eruopean , how bytes are translated into characters (page1252) / case insentive  , accent sensistive)  
END
GO

USE LearningManagementSystem;
GO

-- 1. Create tables with no foreign key dependencies first
CREATE TABLE Branch(
    BranchID INT PRIMARY KEY IDENTITY(1,1),   -- may be like 21 branch LIKE THAT  
    BranchName VARCHAR(100) NOT NULL,          -- drived it from location name  
    [Location] VARCHAR(100),                  -- make names from governorate in Egypt
    ContactEmail VARCHAR(100),                -- make single value Email  
    ContactPhone VARCHAR(20)                  -- one value phone  
);
GO

-- 2. Create Users table which depends only on Branch
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),    
    Username VARCHAR(30) NOT NULL UNIQUE,
    FirstName VARCHAR(30) NOT NULL,        --- use arabic name written in English like "Mohamed , amr ,ahmed" AND DO ON  
    LastName VARCHAR(30) NOT NULL,          --- use arabic name written in English like "Mohamed , amr ,ahmed"
    Salary DECIMAL(10,2),
    Email VARCHAR(100) NOT NULL UNIQUE,
    DateOfBirth DATE,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')), -- M > male , F >> Female
    PasswordHash VARCHAR(255) NOT NULL,
    BranchID INT NOT NULL,
    [Address] VARCHAR(200),
    CONSTRAINT FK_Users_Branch FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
GO

-- 3. Create UserRoles table which depends on Users
CREATE TABLE UserRoles (
    UserID INT,
    Role VARCHAR(30), -- 'Admin', 'Instructor', 'Student'
    PRIMARY KEY (UserID, Role),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CHECK (Role IN ('Admin', 'Instructor', 'Student'))
);
GO

-- 4. Create Admin table which depends on Users
CREATE TABLE Admin (
    AdminID INT PRIMARY KEY,
    Position VARCHAR(50),
    HiringDate DATE,
    FOREIGN KEY (AdminID) REFERENCES Users(UserID)
);
GO

-- 5. Create Program table which depends on Admin
CREATE TABLE Program (
    ProgramID INT PRIMARY KEY IDENTITY(1,1),
    ProgramName VARCHAR(100) NOT NULL UNIQUE, -- e.g., 'Professional Training Program' >>> 30 different tracks to , 'IntensiveCodeCamp Program' ,'Early Career Build Up'
    Description TEXT,
    DurationInMonths INT,                      -- e.g., 9, 4 , 1
    AdminID INT NOT NULL,                      -- An admin is responsible for the program
    CONSTRAINT FK_Program_Admin FOREIGN KEY (AdminID) REFERENCES Admin(AdminID)
);
/*
INTENSIVE CODE CAMP HAS TRACKS such as: Web development with different technologies, Digital and
Social Media Marketing, 
e-content development, E-learning, Cyber Security, System Administration, 2D Graphic Design, 
Motion Graphics, Embedded Systems, Industrial Automation, Business Intelligence, 
UI/UX Design, and Software Testing.
*/

/*
'Early Career Build Up HAS 
technologies like Android development, Open source development.
IOT applications development, Cross platform mobile development, loS application development,
Computer Networks, Ethical Hacking, Embedded systems, Robotics, GIS, Digital marketing, 
Furniture Design & Visualization, Architecture Design & visualization and Digital Arts.
*/








GO 

-- 6. Create Intake table which depends on Program
CREATE TABLE Intake(
    IntakeID VARCHAR(20) PRIMARY KEY, --like that format [PROGRAM_CODE]-[YEAR]-[PERIOD_CODE]
    IntakeType VARCHAR(50), -- e.g., 'Full-time Day', 'Part-time Evening', 'Weekend Bootcamp'
    StartDate DATE,
    EndDate DATE,
    ProgramID INT NOT NULL,
    CONSTRAINT FK_Intake_Program FOREIGN KEY (ProgramID) REFERENCES Program(ProgramID) -- Corrected syntax
);
GO

-- 7. Create Track table which depends on Program and Admin
CREATE TABLE Track (
    TrackID INT PRIMARY KEY,    -- Consider IDENTITY(1,1) if you want auto-incrementing IDs
    TrackName VARCHAR(100) NOT NULL,    -- Tracks like (fullstack with python , powerBI Development , .net ) something like that  
    Description TEXT,
    -- TrackCategory VARCHAR(100),
    AdminID INT NOT NULL,  
    ProgramID INT NOT NULL,
    CONSTRAINT FK_Track_Program FOREIGN KEY (ProgramID) REFERENCES Program(ProgramID), -- Added comma here
    CONSTRAINT FK_Track_Admin FOREIGN KEY (AdminID) REFERENCES Admin(AdminID)
);
GO

-- 8. Create Student table which depends on Users, Intake, and Track
CREATE TABLE Student(
    StudentID INT PRIMARY KEY,
    Major VARCHAR(100),  
    CollageGPA DECIMAL(3,2),
    IntakeID VARCHAR(20) NOT NULL,        
    TrackID INT NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (IntakeID) REFERENCES Intake(IntakeID),
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID)
);
GO

-- 9. Create Instructor table which depends on Users
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    ExpertiseArea VARCHAR(100),
    HiringDate DATE,
    ContractType VARCHAR(20) CHECK (ContractType IN ('External','Internal')),
    InstructorDegrea VARCHAR(20) CHECK(InstructorDegrea IN('PHD','Master','Bechlor')),  -- adding to ERD  
    FOREIGN KEY (InstructorID) REFERENCES Users(UserID)
);
GO

-- 10. Create Course table (self-referencing, but doesn't depend on other custom tables yet)
CREATE TABLE Course (
    CourseCode VARCHAR(10) PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Hours INT,
    Credits INT,
    Prerequisites VARCHAR(10),
    FOREIGN KEY (Prerequisites) REFERENCES Course(CourseCode)    -- signal value / self relationship
);
GO

-- 11. Create junction tables for many-to-many relationships
CREATE TABLE Branch_Intake_Track (
    BranchID INT,
    TrackID INT,
    IntakeID VARCHAR(20),
    --AvgFinalEvaluation DECIMAL(5,2),      -- calculate the avefinalEvaluation to each branch For each track For each  intack
    --TotalNOStudents INT,                   -- will calculated in run time
    PRIMARY KEY (BranchID, TrackID, IntakeID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID),
    FOREIGN KEY (IntakeID) REFERENCES Intake(IntakeID)
);
GO

CREATE TABLE Course_Track (
    CourseCode VARCHAR(10),
    TrackID INT,
    CONSTRAINT Pk_crs_track PRIMARY KEY (CourseCode, TrackID),
    CONSTRAINT FK_CourseTrack_Course FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode),
    CONSTRAINT FK_CourseTrack_Track FOREIGN KEY (TrackID) REFERENCES Track(TrackID) -- Corrected typo from Fk_crs_tarck2
);
GO

CREATE TABLE Instructor_Course (
    InstructorID INT,
    CourseCode VARCHAR(10),
    TeachingHours INT,
    PRIMARY KEY (InstructorID, CourseCode),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode)
);
GO

CREATE TABLE Instructor_Track (
    InstructorID INT,
    TrackID INT,
    PRIMARY KEY (InstructorID, TrackID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID)
);
GO

CREATE TABLE Student_Course (
    StudentID INT,
    CourseCode VARCHAR(10),
    AttendanceStatus VARCHAR(30) CONSTRAINT CK_AttendanceStatus CHECK (AttendanceStatus IN ('Online', 'Offline')), --- online or offline
    Grade DECIMAL(4,2),
    PRIMARY KEY (StudentID, CourseCode),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode)
);
GO

CREATE TABLE Exam (
    ExamID INT PRIMARY KEY IDENTITY(1,1),
    ExamType VARCHAR(20) CONSTRAINT CK_Exam_Type CHECK (ExamType IN ('Midterm', 'Final', 'Quiz')),  -- Adding ERD  
    TotalMarks INT NOT NULL,
    PassingScore INT NOT NULL,
    Duration INT, -- in minutes
    ScheduleDate DATETIME,
    CourseCode VARCHAR(10) NOT NULL,    -- not null because Exam weak entity ,its parent course >> must have course
    FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode)
);
GO

CREATE TABLE Question (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionText TEXT NOT NULL,
    DifficultyLevel VARCHAR(20),
    QuestionType VARCHAR(20) CONSTRAINT CK_Qustion_Type CHECK (QuestionType IN ('T/F', 'MCQ')), -- T/F  or MCQ
    CourseCode VARCHAR(10) NOT NULL,            -- not null because course - Question (1:M)  (may-must)
    FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode)
);
GO

CREATE TABLE Options (
    OptionID INT PRIMARY KEY IDENTITY(1,1),
    OptionText VARCHAR(50),
    QuestionID INT NOT NULL,    --- options weak entity , its parent questions
    IsCorrect BIT,              -- BIT >>> True or False Boolean
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);
GO

CREATE TABLE Exam_Question (
    ExamID INT,
    QuestionID INT,
    QuestionOrder INT,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);
GO

CREATE TABLE Student_Exam(
    ExamID INT,
    StudentID INT,
    Score DECIMAL(5,2),
    PRIMARY KEY (ExamID, StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);
GO

CREATE TABLE GraduatedStudent (
    StudentID INT PRIMARY KEY,
    PositionTitle VARCHAR(100),
    HiringStatus VARCHAR(30),
    CompanyName VARCHAR(100),
    CompanyLevel VARCHAR(30),    -- multinational / national / startup  
    FinalEvaluation INT,          --int 90 - 80 -70  
    GradutationDate Date,          -- add it in ERD and Mapping
    FOREIGN KEY  (StudentID) REFERENCES Student(StudentID)  
);
GO

CREATE TABLE CertificateKPIs (
    CertID INT PRIMARY KEY,
    CertificateName VARCHAR(100),
    CertificateSource VARCHAR(100),
    Cost DECIMAL(10,2),
    CrsHours INT,
    StudentID INT NOT NULL,          --not null because it's a weak entity , must have parent (StudentID)
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);
GO

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    FeedbackText TEXT NOT NULL,
    FeedbackRate INT CHECK (FeedbackRate BETWEEN 1 AND 5),
    FeedbackDate DATE NOT NULL DEFAULT GETDATE(), -- Automatically set current date
    StudentID INT NOT NULL,                        -- Who is giving the feedback

    -- This column indicates what the feedback is about
    FeedbackType VARCHAR(50) NOT NULL CHECK (FeedbackType IN ('Instructor', 'Course', 'Track', 'General System')),

    -- Nullable foreign keys for the targets of the feedback
    -- Only one of these should be populated based on FeedbackType
    InstructorID INT NULL,
    CourseCode VARCHAR(10) NULL,
    TrackID INT NULL,
    
    CONSTRAINT FK_Feedback_Student FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    CONSTRAINT FK_Feedback_Instructor FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    CONSTRAINT FK_Feedback_Course FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode),
    CONSTRAINT FK_Feedback_Track FOREIGN KEY (TrackID) REFERENCES Track(TrackID),
    
    -- Simple CHECK constraint using FeedbackType to ensure logical consistency
    CONSTRAINT CK_Feedback_Target_Logic CHECK (
        (FeedbackType = 'Instructor' AND InstructorID IS NOT NULL AND CourseCode IS NULL AND TrackID IS NULL) OR
        (FeedbackType = 'Course' AND CourseCode IS NOT NULL AND InstructorID IS NULL AND TrackID IS NULL) OR
        (FeedbackType = 'Track' AND TrackID IS NOT NULL AND InstructorID IS NULL AND CourseCode IS NULL) OR
        (FeedbackType = 'General System' AND InstructorID IS NULL AND CourseCode IS NULL AND TrackID IS NULL)
    )
);
GO -- Removed the extra ');' that was here.



-- Create the JobProfile Table
CREATE TABLE JobProfile (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    JobTitle VARCHAR(100) NOT NULL UNIQUE,
    JobDescription TEXT
);
GO

-- Create the Junction Table for Track and JobProfile (Many-to-Many)
CREATE TABLE Track_JobProfile (
    TrackID INT NOT NULL, -- PK part, FK to Track
    JobID INT NOT NULL,            -- PK part, FK to JobProfile
    PRIMARY KEY (TrackID, JobID), -- Composite Primary Key
    CONSTRAINT FK_TrackJobProfile_Track FOREIGN KEY (TrackID) REFERENCES Track(TrackID),
    CONSTRAINT FK_TrackJobProfile_JobProfile FOREIGN KEY (JobID) REFERENCES JobProfile(JobID)
);
GO

CREATE TABLE FreelanceJob (
    FreelanceJobID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL, -- Foreign Key to the Student who performed the job
    JobTitle VARCHAR(200) NOT NULL,
    [Description] TEXT,
    ClientNationality VARCHAR(20),
    [Platform] VARCHAR(50), -- e.g., 'Upwork', 'Fiverr', 'Direct Client', 'Freelancer.com'
    CompensationAmountInDollar DECIMAL(10,2) NULL, -- Nullable if compensation isn't always tracked or relevant
    CONSTRAINT FK_FreelanceJob_Student FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);
GO


CREATE TABLE Student_Answer (
    StudentID INT ,
    ExamID INT ,
    QuestionID INT,
    SelectedOptionID INT NULL,
    IsCorrect BIT NULL,				-- Can be updated after evaluation
    AnswerDateTime DATETIME DEFAULT GETDATE(),

    PRIMARY KEY (StudentID, ExamID, QuestionID),

    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
    FOREIGN KEY (SelectedOptionID) REFERENCES Options(OptionID)
);

Go
CREATE TABLE Topic (
    TopicID INT PRIMARY KEY IDENTITY(1,1),
    TopicTitle VARCHAR(100) NOT NULL,
    CourseCode VARCHAR(10) NOT NULL,  -- FK to associate with a course

    CONSTRAINT FK_Topic_Course FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode)
);





