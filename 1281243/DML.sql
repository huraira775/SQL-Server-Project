USE CourseDB
GO
--Insert data
/* insert tech subjects using spInserttechsubjects*/
DECLARE @id INT, @ret INT
EXEC @ret = spInserttechsubjects 'Computer', @id OUTPUT
IF @ret > 0
	PRINT 'new subject inserted with id ' + CAST(@id AS VARCHAR)
SET @id = NULL
SET @ret = NULL
EXEC @ret = spInserttechsubjects 'EEE', @id OUTPUT
IF @ret > 0
	PRINT 'new subject inserted with id ' + CAST(@id AS VARCHAR)
SET @id = NULL
SET @ret = NULL

EXEC @ret =spInserttechsubjects 'Arcitecture', @id OUTPUT
IF @ret > 0
	PRINT 'new subject inserted with id ' + CAST(@id AS VARCHAR)

SET @id = NULL
SET @ret = NULL

EXEC @ret =spInserttechsubjects 'Construction', @id OUTPUT
GO
SELECT * FROM techsubjects
GO
/* insert tech subjects using spInserttechsubjectslist*/
DECLARE @list subjectlist
INSERT INTO @list VALUES 
(5, 'Building Design'), 
(6,'Environmental Engineering'), 
(7,'Urban Design')
EXEC spInserttechsubjectslist @list
GO
/* Insert instructor using spInsertinstructors*/
DECLARE @id INT
EXEC spInsertinstructors 'Atik Hasan', 'shuvo@gmail.com', '01816547896', @id OUTPUT
SET @id = NULL
EXEC spInsertinstructors  'M Alom', 'alom@gmail.com', '01756487965', @id OUTPUT
SET @id = NULL
EXEC spInsertinstructors 'Jashim Ahmed', 'ahmed@gmail.com', '01956897856', @id OUTPUT
SET @id = NULL

EXEC spInsertinstructors 'Hasan Abedin', 'hasan@gmail.com', '01556987456', @id OUTPUT
SET @id = NULL

EXEC spInsertinstructors 'Moinul Hossain', 'moinul@gmail.com', '01865487954', @id OUTPUT
GO

SELECT * FROM instructors
GO
/* Insert course using spInsertcourses */
EXEC spInsertcourses 1, 'SQL', 77, 5, 10, 22000.00, 1

EXEC spInsertcourses 2, 'PHP', 60, 6, 100, 26000.00, 2

EXEC spInsertcourses 3, 'C#', 50, 7, 200, 21000.00, 3

EXEC spInsertcourses 4, 'Q#', 40, 6, 70, 19000.00, 4

EXEC spInsertcourses 5, 'F#', 30, 4, 30, 15000.00, 4
GO

SELECT * FROM courses
GO
EXEC spInsertinstructorsubjects 1, 1

EXEC spInsertinstructorsubjects 2, 2

EXEC spInsertinstructorsubjects 3, 3

EXEC spInsertinstructorsubjects 4, 4
GO

SELECT * FROM instructorsubjects
GO
/* insert batches using spInsertbatches */
EXEC spInsertbatches 5, '2024-01-15', 1

EXEC spInsertbatches 6, '2024-02-22', 2

EXEC spInsertbatches 7, '2024-03-18', 3
GO

SELECT * FROM [batches]
GO
/* insert students using spInsertstudents */
EXEC spInsertstudents 1, 'SM Atik', '017XXXXXXX', 5

EXEC spInsertstudents 2, 'S Raju', '017XXXXXXX', 6

EXEC spInsertstudents 3, 'Omar Faruk', '017XXXXXXX', 7
GO

SELECT * FROM students
GO
/*Update subject using spUdatetechsubjects */
EXEC spUdatetechsubjects 1, 'Computer fundamental'
GO
SELECT * FROM techsubjects
WHERE subjectid = 1
GO
/*Update subject using spUdateinstructors */
EXEC spUdateinstructors 3, 'Jamal Ahmed', 'jamal@ahmed', '01710XXXXXXX'
GO
SELECT * FROM instructors
WHERE instructorid = 3
GO
/* update course uisng spUdatecourses */
EXEC spUdatecourses 5, 'F#', 60, 5, 30, 26000.00, 5
GO
SELECT * FROM courses
WHERE courseid=5
GO
/* update batch using spUdatebatches */
EXEC spUdatebatches 7, '2024-04-02', 4
GO
SELECT * FROM [batches]
WHERE [batchid]=7
GO
/* update students using spUdatestudents */
EXEC spUdatestudents 3, 'Yousuf Jakir', '01710XXXXX'
GO
SELECT * FROM students
WHERE studentid=3
GO
--Delete procedure
----Delete Proc---
EXEC spDeletetechsubjects 1
GO

EXEC spDeleteinstructors 3
GO

EXEC spDeletecourses 2
GO
EXEC spDeleteinstructorsubjects 8
GO
EXEC spDeletebatches 1
GO
EXEC spDeletestudents 3
GO
--View
SELECT * FROM vcoursessummary
GO
--Functions
SELECT dbo.Functioncourses ('Atik Hasan')
GO
SELECT * FROM fnCourseSummary(1)
GO
SELECT * FROM fncourses()
GO
--Trigger test
EXEC spInsertcourses 6, 'MySql', 30, 4, 30, 15000.00, 4
--will fail
GO
DELETE FROM Courses --will fail
GO
--Query
SELECT c.courseid,i.istructorname,tj.technology, b.startdate, s.studentname
FROM courses c
INNER JOIN instructors i ON c.courseid=i.instructorid
INNER JOIN instructorsubjects isj ON i.instructorid=isj.instructorid
INNER JOIN techsubjects tj ON isj.subjectid=tj.subjectid
INNER JOIN [batches] b ON c.courseid=b.courseid
INNER JOIN students s ON b.batchid=s.batchid
GO
SELECT        batches.batchid, COUNT(students.studentid) 
FROM            batches INNER JOIN
                         students ON batches.batchid = students.batchid
GROUP BY   batches.batchid
GO
SELECT        courses.title, COUNT(batches.batchid) 
FROM            courses INNER JOIN
                         batches ON courses.courseid = batches.courseid
GROUP BY courses.title
GO
--1
SELECT  c.title, c.totalclass, c.weeklyclass, c.fee, b.startdate, b.courseid, i.istructorname, st.studentname, st.phone, ts.technology
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
GO
-----------------------------------
--- 2 Course filter
-----------------------------------
SELECT  c.title, c.totalclass, c.weeklyclass, c.fee, b.startdate, b.courseid, i.istructorname, st.studentname, st.phone, ts.technology
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
WHERE c.title = 'SQL'
GO
-----------------------------------
--- 3 Course technology filter
-----------------------------------
SELECT  c.title, c.totalclass, c.weeklyclass, c.fee, b.startdate, b.courseid, i.istructorname, st.studentname, st.phone, ts.technology
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
WHERE ts.technology ='Computer'
GO
-----------------------------------
--- 4 Outer join (right)
-----------------------------------
SELECT  c.title, c.totalclass, c.weeklyclass, c.fee, b.batchid, b.startdate, b.courseid, s.studentname, s.phone
FROM students s 
INNER JOIN  batches b ON s.batchid = b.batchid 
RIGHT OUTER JOIN  courses c ON b.courseid = c.courseid
GO
-----------------------------------
--- 5 Change 4 to cte
-----------------------------------
WITH batchstudent AS
(
SELECT  b.courseid, b.batchid, b.startdate, s.studentname, s.phone
FROM students s 
INNER JOIN  batches b ON s.batchid = b.batchid 
)
SELECT c.title, c.totalclass, c.weeklyclass, c.fee, bs.batchid, bs.startdate, bs.studentname, bs.phone
FROM batchstudent bs
RIGHT OUTER JOIN  courses c ON bs.courseid = c.courseid
GO
-----------------------------------
--- 6 Outer join only not batched
-----------------------------------
SELECT  c.title, c.totalclass, c.weeklyclass, c.fee, b.batchid, b.startdate, b.courseid, s.studentname, s.phone
FROM students s 
INNER JOIN  batches b ON s.batchid = b.batchid 
RIGHT OUTER JOIN  courses c ON b.courseid = c.courseid
WHERE b.batchid IS NULL
GO
-----------------------------------
--- 7 change 6 to subquery
-----------------------------------
SELECT  c.title, c.totalclass, c.weeklyclass, c.fee, b.batchid, b.startdate, b.courseid, s.studentname, s.phone
FROM students s 
INNER JOIN  batches b ON s.batchid = b.batchid 
RIGHT OUTER JOIN  courses c ON b.courseid = c.courseid
WHERE c.courseid NOT IN (select courseid FROM batches)
GO
-----------------------------------
--- 8 aggregate
-----------------------------------
SELECT  c.title, COUNT(b.batchid) 'totalbatches'
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
GROUP by c.title
GO
SELECT  i.istructorname, COUNT(b.batchid) 'totalbatches'
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
GROUP by i.istructorname
GO
-----------------------------------
--- 9 aggregate with having
-----------------------------------
SELECT  c.title, COUNT(b.batchid) 'totalbatches'
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
GROUP by c.title
HAVING c.title = 'SQL'
GO
-----------------------------------
--- 10 windowing functions
-----------------------------------
SELECT  c.title, 
COUNT(b.batchid) OVER (ORDER BY c.courseid) 'totalbatches',
ROW_NUMBER() OVER (ORDER BY c.courseid) 'row',
RANK() OVER (ORDER BY c.courseid) 'rank',
DENSE_RANK() OVER (ORDER BY c.courseid) 'rank dense',
NTILE(2) OVER (ORDER BY c.courseid) 'ntile'
FROM  batches b 
INNER JOIN  courses c ON b.courseid = c.courseid 
INNER JOIN instructors i ON c.instructorid = i.instructorid 
INNER JOIN instructorsubjects isb ON i.instructorid = isb.instructorid 
INNER JOIN students st ON b.batchid = st.batchid 
INNER JOIN techsubjects ts ON isb.subjectid = ts.subjectid
GO
-----------------------------------
--- 11 CASE
-----------------------------------
SELECT title, fee,
CASE 
	WHEN title = 'SQL' OR title='C#' OR title= 'F#' THEN 'Microsoft'
	ELSE 'OTHERS'
END AS 'Vendor'
FROM courses



