-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);

-- Creating PersonLog Table
CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL,
 FOREIGN KEY (PersonID) REFERENCES PersonInfo(PersonID) ON DELETE CASCADE
);

--From the above given tables perform the following queries:
----------------------------------------Part – A-----------------------------------------------------

--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display a message “Record is Affected.”
CREATE OR ALTER TRIGGER tr_DisplayMessage
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'Record is Affected.'
END;

--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.
CREATE OR ALTER TRIGGER tr_LogOperations_INSERT
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
	SELECT PersonID, PersonName, 'INSERT', GETDATE()
	FROM inserted;
END

CREATE OR ALTER TRIGGER tr_LogOperations_DELETE
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
	SELECT PersonID, PersonName, 'DELETE', GETDATE()
	FROM deleted;
END

CREATE OR ALTER TRIGGER tr_LogOperations_UPDATE
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
	SELECT PersonID, PersonName, 'UPDATE', GETDATE()
    FROM inserted;
END

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.
CREATE OR ALTER TRIGGER tr_InsteadLogOperations_INSERT
ON PersonInfo
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    SELECT PersonID, PersonName, 'INSERT', GETDATE()
    FROM inserted;
END

CREATE OR ALTER TRIGGER tr_InsteadLogOperations_DELETE
ON PersonInfo
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
	SELECT PersonID, PersonName, 'DELETE', GETDATE()
	FROM deleted;
END

CREATE OR ALTER TRIGGER tr_InsteadLogOperations_UPDATE
ON PersonInfo
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
	SELECT PersonID, PersonName, 'UPDATE', GETDATE()
	FROM inserted;
END

--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into uppercase whenever the record is inserted.
CREATE TRIGGER tr_UppercaseName
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET PersonName = UPPER(PersonName)
    WHERE PersonID IN (SELECT PersonID FROM inserted);
END;

--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
create trigger tr_stop_duplicate
	on  PersonInfo
	instead of insert
	as
	begin
		insert into PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
		select 
			PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
			from inserted
			where PersonName not in	(
				select PersonName from PersonInfo
			)
	end

	drop trigger tr_stop_duplicate

--6. Create trigger that prevent Age below 18 years.
create or alter trigger tr_Insert_age_below18
	on PersonInfo
	instead of insert
	as
	begin

		insert into PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
		select 
			PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
			from inserted
			where  Age >= 18
	end
	insert into PersonInfo values(1, 'MALAY', 120000, '1999-12-2', 'JAMNAGAR', 99, '2005-12-24')
	select * from PersonInfo

	drop trigger tr_Insert_age_below18

----------------------------------------Part – B-----------------------------------------------------

--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update that age in Person table.
CREATE OR ALTER TRIGGER tr_CalculateAge
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET Age = DATEDIFF(YEAR, BirthDate, GETDATE())
    WHERE PersonID IN (SELECT PersonID FROM inserted);
END;

--8. Create a Trigger to Limit Salary Decrease by a 10%.
CREATE OR ALTER TRIGGER tr_LimitSalaryDecrease
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN PersonInfo p ON i.PersonID = p.PersonID
        WHERE i.Salary < p.Salary * 0.9
    )
    BEGIN
        RAISERROR ('Salary decrease is limited to 10%.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        UPDATE PersonInfo
        SET PersonName = i.PersonName, Salary = i.Salary, JoiningDate = i.JoiningDate,
            City = i.City, Age = i.Age, BirthDate = i.BirthDate
        FROM PersonInfo p
        JOIN inserted i ON p.PersonID = i.PersonID;
    END
END;

----------------------------------------Part – C-----------------------------------------------------

--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL during an INSERT.
CREATE OR ALTER TRIGGER tr_DefaultJoiningDate
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET JoiningDate = GETDATE()
    WHERE JoiningDate IS NULL AND PersonID IN (SELECT PersonID FROM inserted);
END;

--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints ‘Record deleted successfully from PersonLog’.
CREATE OR ALTER TRIGGER tr_DeleteMessage
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog.'
END;