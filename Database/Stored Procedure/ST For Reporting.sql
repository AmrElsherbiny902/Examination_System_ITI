Create PROCEDURE usp_GetTopicsByCourseCode
    @CourseCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
       
        t.TopicTitle
       
    FROM 
        Topic t
    WHERE 
        t.CourseCode = @CourseCode;
END;
GO

usp_GetTopicsByCourseCode CS04
 go 
CREATE PROCEDURE usp_GetExamQuestionsAndOptions
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        eq.ExamID,
        q.QuestionID,
        eq.QuestionOrder,
        q.QuestionText,
        q.DifficultyLevel,
        q.QuestionType,
        o.OptionID,
        o.OptionText,
        o.IsCorrect
    FROM 
        Exam_Question eq
    INNER JOIN Question q ON eq.QuestionID = q.QuestionID
    LEFT JOIN Options o ON q.QuestionID = o.QuestionID
    WHERE 
        eq.ExamID = @ExamID
    ORDER BY 
        eq.QuestionOrder, o.OptionID;
END;
GO

CREATE PROCEDURE usp_GetStudentExamAnswers
    @ExamID INT,
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        eq.ExamID,
        q.QuestionID,
        eq.QuestionOrder,
        q.QuestionText,
        q.QuestionType,
        q.DifficultyLevel,

        o.OptionID,
        o.OptionText,
        o.IsCorrect AS OptionIsCorrect,

        sa.StudentID,
        sa.SelectedOptionID,
        CASE 
            WHEN o.OptionID = sa.SelectedOptionID THEN 1 ELSE 0 
        END AS IsSelected,
        sa.IsCorrect AS StudentAnswerCorrect,
        sa.AnswerDateTime
    FROM 
        Exam_Question eq
    INNER JOIN Question q ON eq.QuestionID = q.QuestionID
    LEFT JOIN Options o ON q.QuestionID = o.QuestionID
    LEFT JOIN Student_Answers sa 
        ON sa.QuestionID = q.QuestionID 
        AND sa.ExamID = eq.ExamID 
        AND sa.StudentID = @StudentID
    WHERE eq.ExamID = @ExamID
    ORDER BY eq.QuestionOrder, o.OptionID;
END;
GO








usp_GetStudentExamAnswers 433,194










select * from Exam_Question e
inner join Question q
on q.QuestionID=e.QuestionID

inner join options o
on o.questionid =q.QuestionID
where q.QuestionID in (23,54,70,171)



select count(QuestionID) as no_questions  ,e.examID
from exam e
inner join exam_question eq
on eq.ExamID=e.ExamID
where e.ExamID=72
group by e.ExamID

select e.examid , q.*
from exam e
inner join Exam_Question q
on e.ExamID=q.ExamID
where e.ExamID=72




-- 1. Course
INSERT INTO Course (CourseCode, CourseName)
VALUES ('CS101', 'Introduction to Computer Science');

-- 2. Exam
INSERT INTO Exam (ExamType, TotalMarks, PassingScore, Duration, ScheduleDate, CourseCode)
VALUES ('Final', 100, 60, 90, GETDATE(), 'CS101');

select * from Exam
-- Get new ExamID
DECLARE @ExamID INT = (SELECT TOP 1 ExamID FROM Exam ORDER BY ExamID DESC); -- 1005

-- 3. Questions (4 questions)
INSERT INTO Question (QuestionText, DifficultyLevel, QuestionType, CourseCode)
VALUES 
('What does CPU stand for?', 'Easy', 'MCQ', 'CS101'),
('Which one is a programming language?', 'Easy', 'MCQ', 'CS101'),
('What is the output of 2 + 2 * 2?', 'Medium', 'MCQ', 'CS101'),
('Which device is used for permanent data storage?', 'Easy', 'MCQ', 'CS101');


-- 4. Link Questions to Exam
INSERT INTO Exam_Question (ExamID, QuestionID, QuestionOrder)
VALUES 
(1005, 1001, 1),
(1005, 1002, 2),
(1005, 1003, 3),
(1005, 1004, 4);

-- 5. Insert Options (4 per question)
-- Q1 Options
INSERT INTO Options (OptionText, QuestionID, IsCorrect)
VALUES 
('Central Processing Unit', 1001, 1),
('Computer Primary Unit', 1001, 0),
('Central Program Utility', 1001, 0),
('Control Panel Unit', 1001, 0);

-- Q2 Options
INSERT INTO Options (OptionText, QuestionID, IsCorrect)
VALUES 
('HTML', 1002, 0),
('Python', 1002, 1),
('HTTP', 1002, 0),
('USB', 1002, 0);

-- Q3 Options
INSERT INTO Options (OptionText, QuestionID, IsCorrect)
VALUES 
('6', 1003, 1),
('8', 1003, 0),
('4', 1003, 0),
('10', 1003, 0);

-- Q4 Options
INSERT INTO Options (OptionText, QuestionID, IsCorrect)
VALUES 
('RAM', 1004, 0),
('Hard Disk Drive', 1004, 1),
('Cache', 1004, 0),
('Monitor', 1004, 0);

select * from Student where StudentID=1001
select * from options where QuestionID=1004



-- 8. Student Answers (some correct, some wrong)
INSERT INTO Student_Answers (StudentID, ExamID, QuestionID, SelectedOptionID, IsCorrect)
VALUES
(1001, 1005, 1001, 2009, 1), -- correct
(1001, 1005, 1002, 2013, 0), -- incorrect
(1001, 1005, 1003, 2018, 1), -- correct
(1001, 1005, 1004, 2023, 0); -- incorrect

EXEC usp_GetStudentExamAnswers 1005,1001
