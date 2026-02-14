--Create Department Table
CREATE TABLE Department (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
-- Create Designation Table
CREATE TABLE Designation (
 DesignationID INT PRIMARY KEY,
 DesignationName VARCHAR(100) NOT NULL UNIQUE
);
-- Create Person Table
CREATE TABLE Person (
 PersonID INT PRIMARY KEY IDENTITY(101,1),
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8, 2) NOT NULL,
 JoiningDate DATETIME NOT NULL,
 DepartmentID INT NULL,
 DesignationID INT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
 FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

-----------------------------------------------Part-A-------------------------------------------------

--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.

--INSERT
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_INSERT
		@DEPARTMENTID INT,
		@DEPARTMENTNAME VARCHAR(100)

AS
BEGIN
	INSERT INTO DEPARTMENT(
		DEPARTMENTID,
		DEPARTMENTNAME
		)
		VALUES
		(
		@DEPARTMENTID,
		@DEPARTMENTNAME
		)
END

CREATE OR ALTER PROCEDURE PR_DESIGNATION_INSERT
		@DESIGNATIONID INT,
		@DESIGNATIONNAME VARCHAR(100)

AS
BEGIN
	INSERT INTO DESIGNATION(
		DESIGNATIONID,
		DESIGNATIONNAME
		)
		VALUES
		(
		@DESIGNATIONID,
		@DESIGNATIONNAME
		)
END

CREATE OR ALTER PROCEDURE PR_PERSON_INSERT
		@FIRSTNAME VARCHAR(100),
		@LASTNAME VARCHAR(100),
		@SALARY DECIMAL(8,2),
		@JOININGDATE DATETIME,
		@DEPARTMENTID INT,
		@DESIGNATIONID INT
AS
BEGIN
	INSERT INTO PERSON(
		FIRSTNAME ,
		LASTNAME ,
		SALARY ,
		JOININGDATE,
		DEPARTMENTID,
		DESIGNATIONID 
		)
		VALUES
		(
		@FIRSTNAME,
		@LASTNAME,
		@SALARY,
		@JOININGDATE,
		@DEPARTMENTID,
		@DESIGNATIONID
		)
END

--EXEC QUERY
EXEC PR_DEPARTMENT_INSERT 1,'ADMIN';
EXEC PR_DEPARTMENT_INSERT 2,'IT';
EXEC PR_DEPARTMENT_INSERT 3,'HR';
EXEC PR_DEPARTMENT_INSERT 4,'ACCOUNT';

EXEC PR_DESIGNATION_INSERT 11,'JOBBER';
EXEC PR_DESIGNATION_INSERT 12,'WELDER';
EXEC PR_DESIGNATION_INSERT 13,'CLERK';
EXEC PR_DESIGNATION_INSERT 14,'MANAGER';
EXEC PR_DESIGNATION_INSERT 15,'CEO';

EXEC PR_PERSON_INSERT 'RAHUL','ANSHU',56000,'1990-01-01',1,12;
EXEC PR_PERSON_INSERT 'HARDIK','HINSU',18000,'1990-09-25',2,11;
EXEC PR_PERSON_INSERT 'BHAVIN','KAMANI',25000,'1991-05-14',NULL,11;
EXEC PR_PERSON_INSERT 'BHOOMI','PATEL',39000,'2014-02-20',1,13;
EXEC PR_PERSON_INSERT 'ROHIT','RAJGOR',17000,'1990-07-23',2,15;
EXEC PR_PERSON_INSERT 'PRIYA','MEHTA',25000,'1990-10-18',2,NULL;
EXEC PR_PERSON_INSERT 'NEHA','TRIVEDI',18000,'2014-02-20',3,15;

--UPDATE
CREATE PROCEDURE PR_DEPARTMENT_UPDATE
		@DEPARTMENTID INT,
		@DEPARTMENTNAME VARCHAR(100)
AS
BEGIN
	UPDATE DEPARTMENT
	SET DEPARTMENTNAME=@DEPARTMENTNAME
	WHERE DEPARTMENTID=@DEPARTMENTID;
END


CREATE PROCEDURE PR_DESIGNATION_UPDATE
		@DESIGNATIONID INT,
		@DESIGNATIONNAME VARCHAR(100)
AS
BEGIN
	UPDATE DESIGNATION
	SET DESIGNATIONNAME=@DESIGNATIONNAME
	WHERE DESIGNATIONID=@DESIGNATIONID;
END

CREATE PROCEDURE PR_PERSON_UPDATE
		@PERSONID INT,
		@FIRSTNAME VARCHAR(100),
		@LASTNAME VARCHAR(100),
		@SALARY DECIMAL(8,2),
		@JOININGDATE DATETIME,
		@DEPARTMENTID INT,
		@DESIGNATIONID INT
AS
BEGIN
	UPDATE PERSON
	SET
		FIRSTNAME=@FIRSTNAME,
		LASTNAME=@LASTNAME,
		SALARY=@SALARY,
		JOININGDATE=@JOININGDATE,
		DEPARTMENTID=@DEPARTMENTID,
		DESIGNATIONID=@DESIGNATIONID
	WHERE PERSONID=@PERSONID;
END

--DELETE
CREATE PROCEDURE PR_DEPARTMENT_DELETE
		@DEPARTMENTID INT,
		@DEPARTMENTNAME VARCHAR(100)
AS
BEGIN
	DELETE FROM DEPARTMENT
	WHERE DEPARTMENTID=@DEPARTMENTID;
END

CREATE PROCEDURE PR_DESIGNATION_DELETE
		@DESIGNATIONID INT,
		@DESIGNATIONNAME VARCHAR(100)
AS
BEGIN
	DELETE FROM DESIGNATION
	WHERE DESIGNATIONID=@DESIGNATIONID;
END

CREATE PROCEDURE PR_PERSON_DELETE
		@PERSONID INT,
		@FIRSTNAME VARCHAR(100),
		@LASTNAME VARCHAR(100),
		@SALARY DECIMAL(8,2),
		@JOININGDATE DATETIME,
		@DEPARTMENTID INT,
		@DESIGNATIONID INT
AS
BEGIN
	DELETE FROM PERSON
	WHERE PERSONID=@PERSONID;
END

--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY
CREATE PROCEDURE PR_DEPARTMENT_SELECTBYPRIMARYKEY
		@DEPARTMENTID INT
AS
BEGIN
    SELECT * 
    FROM DEPARTMENT
    WHERE DEPARTMENTID=@DEPARTMENTID;
END

CREATE PROCEDURE PR_DESIGNATION_SELECTBYPRIMARYKEY
		@DESIGNATIONID INT
AS
BEGIN
    SELECT * 
    FROM DESIGNATION
    WHERE DESIGNATIONID=@DESIGNATIONID;
END

CREATE PROCEDURE PR_PERSON_SELECTBYPRIMARYKEY
		@PERSONID INT
AS
BEGIN
    SELECT * 
    FROM PERSON
    WHERE PERSONID=@PERSONID;
END

--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take columns on select list)
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_DISPLAY
AS
BEGIN
	SELECT * FROM DEPARTMENT;
END

CREATE OR ALTER PROCEDURE PR_DESIGNATION_DISPLAY
AS
BEGIN
	SELECT * FROM DESIGNATION;
END

CREATE OR ALTER PROCEDURE PR_PERSON_DISPLAY
AS
BEGIN
	SELECT * FROM PERSON JOIN DEPARTMENT
	ON PERSON.DEPARTMENTID=DEPARTMENT.DEPARTMENTID JOIN DESIGNATION 
	ON PERSON.DESIGNATIONID=DESIGNATION.DESIGNATIONID;
END

--4. Create a Procedure that shows details of the first 3 persons.
CREATE OR ALTER PROCEDURE PR_PERSON_DETAILOFTOP3PERSON
AS
BEGIN
	SELECT TOP 3 * FROM PERSON;
END

-----------------------------------------------Part-B-------------------------------------------------
--5. Create a Procedure that takes the department name as input and returns a table with all workers working in that department.
CREATE OR ALTER PROCEDURE PR_DEPARTMENTWISEWORKERS
		@DEPARTMENTNAME VARCHAR(100)
AS 
BEGIN
	SELECT DEPARTMENT.DEPARTMENTNAME,PERSON.FIRSTNAME 
	FROM DEPARTMENT JOIN PERSON ON DEPARTMENT.DEPARTMENTID=PERSON.DEPARTMENTID
	WHERE DEPARTMENTNAME=@DEPARTMENTNAME;
END

EXEC PR_DEPARTMENTWISEWORKERS 'ADMIN'
--6. Create Procedure that takes department name & designation name as input and returns a table with worker’s first name, salary, joining date & department name.
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_WORKERDETAIL
		@DEPARTMENTNAME VARCHAR(100),
		@DESIGNATIONNAME VARCHAR(100)
AS 
BEGIN
	SELECT DEPARTMENT.DEPARTMENTNAME,PERSON.FIRSTNAME,PERSON.SALARY,PERSON.JOININGDATE 
	FROM DEPARTMENT JOIN PERSON ON DEPARTMENT.DEPARTMENTID=PERSON.DEPARTMENTID
	JOIN DESIGNATION ON DESIGNATION.DESIGNATIONID=PERSON.DESIGNATIONID
	WHERE DEPARTMENTNAME=@DEPARTMENTNAME AND DESIGNATIONNAME=@DESIGNATIONNAME;
END

EXEC PR_DEPARTMENT_WORKERDETAIL 'ADMIN','CLERK'
--7. Create a Procedure that takes the first name as an input parameter and display all the details of the worker with their department & designation name.
CREATE OR ALTER PROCEDURE PR_PERSON_WORKERDETAIL
		@FIRSTNAME VARCHAR(100)
AS 
BEGIN
	SELECT PERSON.FIRSTNAME,PERSON.LASTNAME,PERSON.SALARY,PERSON.JOININGDATE,DEPARTMENT.DEPARTMENTNAME,DESIGNATION.DESIGNATIONNAME
	FROM DEPARTMENT JOIN PERSON ON DEPARTMENT.DEPARTMENTID=PERSON.DEPARTMENTID
	JOIN DESIGNATION ON DESIGNATION.DESIGNATIONID=PERSON.DESIGNATIONID
	WHERE FIRSTNAME=@FIRSTNAME;
END

EXEC PR_PERSON_WORKERDETAIL 'ROHIT';

--8. Create Procedure which displays department wise maximum, minimum & total salaries.
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_DEPARTMENTWISESALARY
		@DEPARTMENTNAME VARCHAR(100)
AS 
BEGIN
	SELECT DEPARTMENT.DEPARTMENTNAME,MAX(PERSON.SALARY) AS MAX_SALARY,MIN(PERSON.SALARY) AS MIN_SALARY,SUM(PERSON.SALARY) AS TOTAL_SALARY
	FROM DEPARTMENT JOIN PERSON 
	ON DEPARTMENT.DEPARTMENTID=PERSON.DEPARTMENTID
	WHERE DEPARTMENTNAME=@DEPARTMENTNAME
	GROUP BY DEPARTMENTNAME;
END

EXEC PR_DEPARTMENT_DEPARTMENTWISESALARY 'HR'

--9. Create Procedure which displays designation wise average & total salaries.
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_DESIGNATIONWISESALARY
		@DESIGNATIONNAME VARCHAR(100)
AS 
BEGIN
	SELECT DESIGNATION.DESIGNATIONNAME,AVG(PERSON.SALARY) AS AVERAGE_SALARY,SUM(PERSON.SALARY) AS TOTAL_SALARY
	FROM DESIGNATION JOIN PERSON 
	ON DESIGNATION.DESIGNATIONID=PERSON.DESIGNATIONID
	WHERE DESIGNATIONNAME=@DESIGNATIONNAME
	GROUP BY DESIGNATIONNAME;
END

EXEC PR_DEPARTMENT_DESIGNATIONWISESALARY 'JOBBER'

-----------------------------------------------Part-C-------------------------------------------------
--10. Create Procedure that Accepts Department Name and Returns Person Count.
create or alter proc PR_Department_PersonCount
	@DepartmentName varchar(100)
as
begin
	select Department.DepartmentName, count(Person.PersonID)
	from Department join Person
	on Department.DepartmentID = Person.DepartmentID
	Where Department.DepartmentName = @DepartmentName
	GROUP BY DepartmentName
end

--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than input salary value along with their department and designation details.
create or alter proc PR_Department_Salary
	@Salary int
as
begin
	select Person.FirstName, Department.DepartmentName, Designation.DesignationName
	from Person join Department
	on Person.DepartmentID = Department.DepartmentID join Designation
	on Person.DesignationID = Designation.DesignationID
	where Person.Salary > @Salary
end

--12. Create a procedure to find the department(s) with the highest total salary among all departments.
create or alter proc PR_Department_HighestSalary
as
begin
	select Department.DepartmentID, Department.DepartmentName,sum(Salary) as Total_Salary from Department
	join Person
	on Person.DepartmentID = Department.DepartmentID
	group by Department.DepartmentID,Department.DepartmentName
	having sum(salary) in (select max(Total_Salary) as Max_Salary from (select sum(Salary) as Total_Salary from Person group by DepartmentID) as Salary)
end

--13. Create a procedure that takes a designation name as input and returns a list of all workers under that designation who joined within the last 10 years, along with their department.
create or alter proc PR_Designation_WorkerDetails
	@DesinationName Varchar(100)
as
begin
	select Person.FirstName, Person.JoiningDate, Department.DepartmentName, Designation.DesignationName
	from Person join Department
	on Person.DepartmentID = Department.DepartmentID join Designation
	on Person.DesignationID = Designation.DesignationID
	where Designation.DesignationName = @DesinationName and
	Person.JoiningDate > (SELECT dateadd(year, -10, getdate()))
end

--14. Create a procedure to list the number of workers in each department who do not have a designation assigned.
create or alter proc PR_Department_NoDesignation
as
begin
	select Person.FirstName, Department.DepartmentName
	from Person join Department
	on Person.DepartmentID = Department.DepartmentID
	where Person.DesignationID is null
end

--15. Create a procedure to retrieve the details of workers in departments where the average salary is above 12000.
create or alter proc PR_Department_AvgSalary
as
begin
	select FirstName, Salary, DepartmentName
	from Person join Department
	on Person.DepartmentID = Department.DepartmentID
	group by Department.DepartmentName,FirstName,salary
	having avg(Person.Salary) > 12000;
end
