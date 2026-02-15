--Note: for Table valued function use tables of Lab-2
 -----------------------------------------------Part-A-------------------------------------------------
--1. Write a function to print "hello world".
CREATE OR ALTER FUNCTION FR_HELLOWORLD()
	RETURNS VARCHAR(100)
AS
BEGIN
	RETURN 'HELLO WORLD';
END

SELECT DBO.FR_HELLOWORLD();

--2. Write a function which returns addition of two numbers.
CREATE OR ALTER FUNCTION FR_ADDTWONUMBERS(@NUM1 INT,@NUM2 INT)
	RETURNS INT
AS
BEGIN
	RETURN @NUM1+@NUM2;
END

SELECT DBO.FR_ADDTWONUMBERS(4,5);

--3. Write a function to check whether the given number is ODD or EVEN.
CREATE OR ALTER FUNCTION FR_EVENORODD(@NUM INT)
	RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @RESULT VARCHAR(10)
	IF @NUM%2=0
		SET @RESULT='EVEN'
	ELSE
		SET @RESULT='ODD'
	RETURN @RESULT
END

SELECT DBO.FR_EVENORODD(7);

--4. Write a function which returns a table with details of a person whose first name starts with B.
CREATE OR ALTER FUNCTION FR_PERSON_FIRSTNAMEWITHB()
	RETURNS TABLE
AS
	RETURN(SELECT * FROM PERSON WHERE FIRSTNAME LIKE 'B%');

SELECT * FROM FR_PERSON_FIRSTNAMEWITHB();

--5. Write a function which returns a table with unique first names from the person table.
CREATE OR ALTER FUNCTION FR_PERSON_UNIQUENAME()
	RETURNS TABLE
AS
	RETURN(SELECT DISTINCT FIRSTNAME FROM PERSON);

SELECT * FROM FR_PERSON_UNIQUENAME();

--6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FR_PRINT1TONNUMBERS(@NUM INT)
	RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @I INT=1
	DECLARE @N VARCHAR(100)='';
	WHILE @I<=@NUM
		BEGIN
			SET @N=@N+CAST(@I AS VARCHAR)+' '
			SET @I=@I+1
		END
	RETURN @N
END 

SELECT DBO.FR_PRINT1TONNUMBERS(5);

--7. Write a function to find the factorial of a given integer.
CREATE OR ALTER FUNCTION FR_FACTORIAL(@NUM INT)
	RETURNS INT
AS
BEGIN
	DECLARE @FAC INT=1;
	DECLARE @I INT=1;
	WHILE @I<=@NUM
		BEGIN
			SET @FAC=@FAC*@I
			SET @I=@I+1;
		END
	RETURN @FAC
END

SELECT DBO.FR_FACTORIAL(5);

 -----------------------------------------------Part-B-------------------------------------------------
--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
CREATE OR ALTER FUNCTION FR_COMPARETWOINTEGER(@INTEGER1 INT,@INTEGER2 INT)
	RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @RESULT  VARCHAR(50)
	SET @RESULT=CASE
		WHEN @INTEGER1>@INTEGER2 THEN 'INTEGER1 IS GREATER THAN INTEGER2'
		WHEN @INTEGER1<@INTEGER2 THEN 'INTEGER2 IS GREATER THAN INTEGER1'
		ELSE 'INTEGER1 AND INTEGER2 ARE EQUAL'
		END
	RETURN @RESULT
END

SELECT DBO.FR_COMPARETWOINTEGER(4,5);

--9. Write a function to print the sum of even numbers between 1 to 20.
CREATE OR ALTER FUNCTION FR_SUMOFEVENNUMBERS()
	RETURNS INT
AS
BEGIN
	DECLARE @RESULT INT=0;
	DECLARE @I INT=1;
	WHILE @I<=20
		BEGIN
			IF @I%2=0
				SET @RESULT+=@I;
			SET @I=@I+1;
		END
	RETURN @RESULT
END

SELECT DBO.FR_SUMOFEVENNUMBERS();
--10. Write a function that checks if a given string is a palindrome
create or alter function FR_Palindrome(@string varchar(100))
	returns varchar(100)
as
begin
	declare @reverse varchar(100) = reverse(@string);
	declare @result varchar(100);
	if @string = @reverse
		set @result = 'Palindrome'
	else
		set @result = 'Not Palindrome'
	return @result
end

select dbo.FR_Palindrome('16461');
 -----------------------------------------------Part-C-------------------------------------------------
--11. Write a function to check whether a given number is prime or not.
CREATE OR ALTER FUNCTION FN_PrimeNumber(@num int)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @i INT = 2;
	IF @num <= 1
		RETURN 'Not Prime';
	WHILE @i <= @num/2
	BEGIN
		IF @num % @i = 0
			RETURN 'Not Prime';
		SET @i = @i + 1;
	END
	RETURN 'Prime'
END

select dbo.FN_PrimeNumber(9)

--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
create or alter function FN_DateDifference(@Start datetime, @End datetime)
	returns int
as
begin
	return datediff(day, @Start, @End)
end

select dbo.FN_DateDifference('2024-12-01', '2024-12-10')

--13. Write a function which accepts two parameters year & month in integer and returns total days each year.
create or alter function FN_GetDaysInMonthYear(@Year INT, @Month INT)
	returns int
as
begin
    return case 
                when @Month in (1, 3, 5, 7, 8, 10, 12) then 31
                when @Month in (4, 6, 9, 11) then 30
                when @Month = 2 and ((@Year % 4 = 0 and @Year % 100 != 0) or @Year % 400 = 0) then 29
                when @Month = 2 then 28
                else 0
            end
end

select dbo.FN_GetDaysInMonthYear(2024, 2)

--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
create or alter function FN_PersonDetails(@DepartmentID int)
	returns table
as
	return (select * from Person where DepartmentID = @DepartmentID)

select * from dbo.FN_PersonDetails(1)

--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
create or alter function FN_Persondetails_JoiningDate()
	returns table
as
	return (select * from Person where JoiningDate > '1991-01-01')

select * from dbo.FN_Persondetails_JoiningDate()
