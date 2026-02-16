--------------------------------------------AFTER TRIGGER--------------------------------------------

CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)


CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);

--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"
--after insert
create trigger tr_EmployeeDetails_insert
on EmployeeDetails
after insert
as
begin
	print 'Employee record inserted'
end

--after update
create trigger tr_EmployeeDetails_update
on EmployeeDetails
after update
as
begin
	print 'Employee record updated'
end

--after delete
create trigger tr_EmployeeDetails_delete
on EmployeeDetails
after delete
as
begin
	print 'Employee record deleted'
end

--2)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.
--after insert
create trigger tr_log_after_insert
on EmployeeDetails
after insert
as
begin
	declare @Id int,@Name varchar(100)
	select @ID=EmployeeID from inserted
	select @Name=EmployeeName from inserted

	insert into EmployeeLogs values (@Id,@Name,'inserted',GETDATE())
end

--after update
create trigger tr_log_after_update
on EmployeeDetails
after update
as
begin
	declare @Id int,@Name varchar(100)
	select @ID=EmployeeID from inserted
	select @Name=EmployeeName from inserted

	insert into EmployeeLogs values (@Id,@Name,'updated',GETDATE())
end

--after delete
create trigger tr_log_after_delete
on EmployeeDetails
after delete
as
begin
	declare @Id int,@Name varchar(100)
	select @ID=EmployeeID from deleted
	select @Name=EmployeeName from deleted

	insert into EmployeeLogs values (@Id,@Name,'deleted',GETDATE())
end

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
create trigger tr_joiningbonus_after_insert
on EmployeeDetails
after insert
as
begin
	declare @Bonus decimal(8,2)=0,@Salary decimal(8,2),@EMPID int
	select @EMPID=EmployeeID,@Salary=Salary from inserted
	set @Bonus=@Salary+@Salary*0.1

	update EMPLOYEEDETAILS
	set Salary=@Bonus
	where EmployeeID=@EMPID

end

--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
create trigger tr_joiningdate_after_insert
on EmployeeDetails
after insert
as
begin
	declare @Jdate datetime,@EID int
	select @Jdate=JoiningDate,@EID=EmployeeID from inserted

	if(@Jdate is null)
	begin
		update EMPLOYEEDETAILS
		set @Jdate=GETDATE()
		where EmployeeID=@EID
	end
end

--5)	Create a trigger that ensure that ContactNo is valid during insert and update (Like ContactNo length is 10)
create trigger tr_validcontactno_after_insert
on EmployeeDetails
after insert
as
begin
	declare @Contactno varchar(100),@EID int
	select @Contactno=ContactNo,@EID=EmployeeID from inserted

	if(Len(@Contactno) != 10)
	begin
		print 'Invalid contact no'
		delete from EMPLOYEEDETAILS
		where EmployeeID=@EID
	end
end

--------------------------------------------INSTEAD OF TRIGGER--------------------------------------------
	
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);

--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.
--insteadof insert
create trigger tr_log_insteadof_insert
on Movies
instead of insert
as
begin
	declare @MovieId int,@MovieTitle varchar(100)
	select @MovieId=MovieID from inserted
	select @MovieTitle=MovieTitle from inserted

	insert into EmployeeLogs values (@MovieId,@MovieTitle,'inserted',GETDATE())
end

--insteadof update
create trigger tr_log_insteadof_update
on Movies
instead of update
as
begin
	declare @MovieId int,@MovieTitle varchar(100)
	select @MovieId=MovieID from inserted
	select @MovieTitle=MovieTitle from inserted

	insert into EmployeeLogs values (@MovieId,@MovieTitle,'updated',GETDATE())
end

--insteadof delete
create trigger tr_log_insteadof_delete
on Movies
instead of delete
as
begin
	declare @MovieId int,@MovieTitle varchar(100)
	select @MovieId=MovieID from deleted
	select @MovieTitle=MovieTitle from deleted

	insert into EmployeeLogs values (@MovieId,@MovieTitle,'deleted',GETDATE())
end

--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
create trigger tr_insteadOfRating 
on Movies
instead of insert
as
begin
	Declare @MovieID int, @MovieTitle varchar(200), @ReleaseYear int, @Genre varchar(200), @Rating decimal(3, 2), @Duration int
	select @MovieID = MovieID from inserted
	select @MovieTitle = MovieTitle from inserted
	select @ReleaseYear = ReleaseYear from inserted
	select @Genre = Genre from inserted
	select @Rating = Rating from inserted
	select @Duration = Duration from inserted
	
	if(@Rating > 5.5)
	begin
		insert into Movies values(@MovieID, @MovieTitle, @ReleaseYear, @Genre, @Rating, @Duration)
	end

end
	
--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.

--4.	Create trigger that prevents to insert pre-release movies.
create or alter trigger tr_insteadof_rating_insert
on Movies
instead of insert
as
begin
	declare @MovieId int,@rating varchar(100),@Release int
	select @MovieId=MovieID from inserted
	select @Release=ReleaseYear from inserted
	
	if(@Release>GETDATE())
	begin
		print 'Invalid'
		delete from Movies
		where MovieID=@MovieId
	end
end

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.
