CREATE DATABASE CourseDB
GO

USE CourseDB
GO
CREATE TABLE techsubjects
(
	subjectid int  primary key,
	technology nvarchar(50) not null
)
GO
CREATE TABLE instructors
(
	instructorid int  primary key,
	istructorname nvarchar(50) not null,
	email nvarchar(50) not null,
	phone nvarchar(25) not null
)
GO
CREATE TABLE courses
(
	courseid int  primary key,
	title nvarchar(150) not null,
	totalclass int not null,
	weeklyclass int not null,
	classduration int not null,
	fee money not null,
	instructorid int not null references instructors (instructorid)
)
GO
CREATE TABLE instructorsubjects
(
	instructorid int not null references instructors (instructorid),
	subjectid int not null references techsubjects (subjectid),
	primary key (instructorid,subjectid)
)
GO
CREATE TABLE [batches]
(
	batchid int  primary key,
	startdate date not null,
	courseid int not null references courses (courseid)
)
GO
CREATE TABLE students
(
	studentid int  primary key,
	studentname nvarchar(30) not null,
	phone nvarchar(25) not null,
	batchid int not null references [batches] (batchid)
)
GO
---Stored Procedures
/* techsubjects*/
---Insert single subjects
CREATE PROC spInserttechsubjects @t NVARCHAR(50), @sid INT OUTPUT
AS 
BEGIN TRY
	SELECT @sid = ISNULL(MAX(subjectid), 0)+1 FROM techsubjects
	INSERT INTO techsubjects(subjectid, technology)
	VALUES(@sid, @t)
	RETURN @@ROWCOUNT
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000) =ERROR_MESSAGE()
	RAISERROR(@msg, 16, 1)
	RETURN 0
END CATCH
GO
---Insert multple subjects
CREATE TYPE subjectlist AS TABLE
(
	subjectid INT,
	subjectname NVARCHAR(50)
)
GO
CREATE PROCEDURE spInserttechsubjectslist
  @list AS subjectlist READONLY
AS
BEGIN TRY
  INSERT INTO techsubjects
  SELECT * FROM @list
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000) =ERROR_MESSAGE()
	RAISERROR(@msg, 16, 1)
END CATCH
GO
--Insert instructor
CREATE SEQUENCE seqinstructorid  
    START WITH 1  
    INCREMENT BY 1
GO  
CREATE PROC spInsertinstructors  @in NVARCHAR(50),
								 @e NVARCHAR(50),
								 @p NVARCHAR(25),
								  @id INT OUTPUT
AS 
BEGIN TRY
	SET @id = NEXT VALUE FOR seqinstructorid
	INSERT INTO instructors(instructorid, istructorname, email, phone)
	VALUES(@id, @in, @e, @p)
	RETURN @@ROWCOUNT
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000)
	SELECT @msg = ERROR_MESSAGE()
	;
	THROW 50001, @msg, 1
	RETURN 0
END CATCH
GO
--Insert Course
CREATE PROC spInsertcourses @id INT,
                            @t NVARCHAR(150),
							@toc INT,
						    @wc INT,
							@cd INT,
							@f MONEY,
							@iid INT
AS 
BEGIN TRY
	INSERT INTO courses(courseid, title, totalclass, weeklyclass, classduration, fee, instructorid)
	VALUES(@id, @t, @toc, @wc, @cd, @f, @iid)
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000)
	SELECT @msg = ERROR_MESSAGE()
	print @msg
	;
	THROW 50001, @msg, 1
END CATCH
GO
--insert instructorsubjects 
CREATE PROC spInsertinstructorsubjects  @id INT,
										@sid INT
							
AS 
BEGIN TRY
	INSERT INTO instructorsubjects(instructorid, subjectid)
	VALUES(@id, @sid)
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000)
	SELECT @msg = ERROR_MESSAGE()
	;
	THROW 50002, @msg, 1
END CATCH
GO
--Insert batches
CREATE PROC spInsertbatches  @id INT,
							 @st DATE,
							 @cid INT
							
AS 
BEGIN TRY
	INSERT INTO batches(batchid, startdate, courseid)
	VALUES(@id, @st, @cid)
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000)
	SELECT @msg = ERROR_MESSAGE()
	;
	THROW 50001, @msg, 1
END CATCH
GO
--Insert student
CREATE PROC spInsertstudents  @id INT,
							  @stn NVARCHAR(30),
							  @p NVARCHAR(25),
							  @bit INT			
AS 
BEGIN TRY
	INSERT INTO students(studentid, studentname, phone, batchid)
	VALUES(@id, @stn, @p, @bit)
END TRY
BEGIN CATCH
	DECLARE @msg NVARCHAR(1000)
	SELECT @msg = ERROR_MESSAGE()
	;
	THROW 50001, @msg, 1
END CATCH
GO
--update subject
CREATE PROC spUdatetechsubjects @sid INT,
                                 @t NVARCHAR(50)
AS 
BEGIN TRY
	 UPDATE techsubjects
		SET technology = @t
		WHERE subjectid = @sid
END TRY
BEGIN CATCH
	 RAISERROR( 'Update Faild',16, 1)
END CATCH
GO
--Update instructor
CREATE PROC spUdateinstructors @id INT,
                                 @in NVARCHAR(50),
								 @e NVARCHAR(50),
								 @p NVARCHAR(25)
AS 
BEGIN TRY
			UPDATE instructors
			SET istructorname = @in,
			email = @e, phone=@p
			WHERE instructorid = @id
END TRY
BEGIN CATCH
		;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO
--Update course
CREATE PROC spUdatecourses @id INT,
                            @t NVARCHAR(150),
							@toc INT,
						    @wc INT,
							@cd INT,
							@f MONEY,
							@iid INT
AS 
BEGIN TRY
		UPDATE courses
			SET title =@t, totalclass=@toc,
			weeklyclass=@wc, classduration=@cd,fee=@f, instructorid=@iid
			WHERE courseid = @id
END TRY
BEGIN CATCH
		;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO
--Update batch
CREATE PROC spUdatebatches  @id INT,
							 @st DATE,
							 @cid INT							
AS 
BEGIN TRY
		UPDATE batches
			SET startdate = @st, courseid=@cid
			WHERE batchid = @id
END TRY
BEGIN CATCH
		;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO
--Update students
CREATE PROC spUdatestudents  @id INT,
							  @stn NVARCHAR(30),
							  @p NVARCHAR(25)
											
AS 
BEGIN TRY
		UPDATE students
			SET studentname= @stn, phone=@p
			WHERE studentid= @id
END TRY
BEGIN CATCH
		;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO
----Delete Procedure
--delete subject
CREATE PROC spDeletetechsubjects @sid INT
AS 
BEGIN TRY
	 DELETE techsubjects
		WHERE subjectid =@sid
END TRY
BEGIN CATCH
		
	 RAISERROR('Can''t Deleted', 16, 1)
END CATCH
GO
--delete instructor

CREATE PROC spDeleteinstructors @id INT
AS 
BEGIN TRY
	 DELETE instructors
		WHERE instructorid= @id
END TRY
BEGIN CATCH
	RAISERROR('Can''t Deleted', 16, 1)
END CATCH
GO
--delete course
CREATE PROC spDeletecourses @id INT
AS 
BEGIN TRY
	 DELETE courses
		WHERE courseid= @id
END TRY
BEGIN CATCH
		RAISERROR('Can''t Deleted', 16, 1)
END CATCH
GO
--delete instructor subject
CREATE PROC spDeleteinstructorsubjects @id INT
AS 
BEGIN TRY
	 DELETE instructorsubjects
		WHERE instructorid= @id
END TRY
BEGIN CATCH
		RAISERROR('Can''t Deleted', 16, 1)
END CATCH
GO
--delete batches
CREATE PROC spDeletebatches @id INT
AS 
BEGIN TRY
	 DELETE batches
		WHERE batchid= @id
END TRY
BEGIN CATCH
	RAISERROR('Can''t Deleted', 16, 1)
END CATCH
GO
--delete students
CREATE PROC spDeletestudents @id INT
AS 
BEGIN TRY
	 DELETE students
		WHERE studentid= @id
END TRY
BEGIN CATCH
	RAISERROR('Can''t Deleted', 16, 1)
END CATCH
GO
--View
CREATE VIEW vcoursessummary
AS
SELECT c.courseid,i.istructorname,tj.technology, b.startdate, s.studentname
FROM courses c
INNER JOIN instructors i ON c.courseid=i.instructorid
INNER JOIN instructorsubjects isj ON i.instructorid=isj.instructorid
INNER JOIN techsubjects tj ON isj.subjectid=tj.subjectid
INNER JOIN [batches] b ON c.courseid=b.courseid
INNER JOIN students s ON b.batchid=s.batchid

GO
--Functions
CREATE FUNCTION Functioncourses (@in nvarchar(50)) RETURNS INT
AS 
BEGIN
DECLARE @A INT
	SELECT @A=COUNT(*) 
	FROM instructors i
	INNER JOIN courses c ON i.instructorid = c.instructorid

	WHERE i.istructorname=@in
RETURN @A
END
GO
--In-line table-valued
CREATE FUNCTION fnCourseSummary(@id INT) RETURNS TABLE
AS
RETURN
(SELECT c.courseid,i.istructorname,tj.technology, b.startdate, s.studentname
FROM courses c
INNER JOIN instructors i ON c.courseid=i.instructorid
INNER JOIN instructorsubjects isj ON i.instructorid=isj.instructorid
INNER JOIN techsubjects tj ON isj.subjectid=tj.subjectid
INNER JOIN [batches] b ON c.courseid=b.courseid
INNER JOIN students s ON b.batchid=s.batchid
WHERE c.courseid=@id
)
GO
--Multi-statement
CREATE FUNCTION fncourses() RETURNS @tbl TABLE
(
	totalcalss INT,
	[count] INT
)
AS
BEGIN
	INSERT INTO @tbl
	SELECT totalclass, COUNT(*) AS 'Count'
	FROM courses
	GROUP BY totalclass
	RETURN
END
GO
--Triggers
CREATE TRIGGER trInsert 
ON courses
FOR INSERT
AS
BEGIN
	DECLARE @W NVARCHAR(35)
	SELECT @W=title FROM inserted 
	IF @W NOT IN ('SQL', 'C#','Java', 'PHP', 'Python', 'F#' )
	BEGIN
		RAISERROR( 'Invalid Name', 11, 1)
		ROLLBACK TRAN
	END
END
GO
CREATE TRIGGER TiggerDelete
ON courses
AFTER DELETE
AS
BEGIN 
	IF @@ROWCOUNT > 1
	BEGIN
		PRINT 'Cannot delete more than 1 at a time'
		ROLLBACK TRAN
	END
END
GO


