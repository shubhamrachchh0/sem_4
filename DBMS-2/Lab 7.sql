-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY,
 Customer_Name VARCHAR(250) NOT NULL,
 Email VARCHAR(50) UNIQUE
);
-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE NOT NULL,
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);

------------------------------------------------Part – A----------------------------------------------------------

--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
BEGIN TRY
	DECLARE @A INT=10,@B INT=0,@RESULT DECIMAL(8,2)
	SET @RESULT=@A/@B
	PRINT @RESULT
END TRY
BEGIN CATCH
	PRINT 'Error occurs that is - Divide by zero error'
END CATCH

--2. Try to convert string to integer and handle the error using try…catch block.
BEGIN TRY
	DECLARE @C VARCHAR(50)='HELLO WORLD',@D INT
	SET @D=CAST(@C AS INT);
	PRINT @D
END TRY
BEGIN CATCH
	PRINT 'ERROR:UNABLE TO CONVERT VARCHAR TO INT'
END CATCH

--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle exception with 
--all error functions if any one enters string value in numbers otherwise print result.
CREATE OR ALTER PROCEDURE ER_SUMNUMBER
	@NUM1 VARCHAR(50),@NUM2 VARCHAR(50)
AS
BEGIN
	BEGIN TRY
		DECLARE @INTNUM1 INT,@INTNUM2 INT,@SUM INT
		SET @INTNUM1=CAST(@NUM1 AS INT)
		SET @INTNUM2=CAST(@NUM2 AS INT)
		SET @SUM=@INTNUM1+@INTNUM2
		PRINT @SUM
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(50));
		PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(50));
		PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(50));
	END CATCH
END

EXEC ER_SUMNUMBER 2,3
EXEC ER_SUMNUMBER 2,X

--4. Handle a Primary Key Violation while inserting data into customers table and print the error details 
--such as the error message, error number, severity, and state.
BEGIN TRY
    INSERT INTO Customers (Customer_id, Customer_Name, Email) 
    VALUES (1, 'MALAY', 'MALAY@GMAIL.COM');
END TRY
BEGIN CATCH
    PRINT 'PRIMARY KEY VIOLATION ERROR';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(50));
    PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(50));
    PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(50));
END CATCH;

--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws Error like 
--no Customer_id is available in database.
CREATE PROCEDURE ER_CUSTOMERROR
	@CUSTOMER_ID INT
AS
BEGIN
	IF NOT EXISTS(SELECT Customer_id FROM Customers WHERE Customer_id=@CUSTOMER_ID)
	BEGIN
		THROW 51000, 'No Customer_id is available in the database.', 1;
	END
	ELSE
	BEGIN
		PRINT 'Customer_id EXISTS';
	END
END

EXEC ER_CUSTOMERROR 1
EXEC ER_CUSTOMERROR 2

-------------------------------------------------Part – B---------------------------------------------------------

--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error message.
BEGIN TRY
    INSERT INTO Orders (Order_id, Customer_id, Order_date)
    VALUES (1, 100, GETDATE());
END TRY
BEGIN CATCH
    PRINT 'Foreign Key Violation: Customer_id does not exist in the Customers table.';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;

--7. Throw custom exception that throws error if the data is invalid.
CREATE PROCEDURE SP_ValidateData
@CustomerName VARCHAR(250)
AS
BEGIN
    IF LEN(@CustomerName) = 0
    BEGIN
        THROW 51001, 'Invalid data: Customer name cannot be empty.', 1;
    END
    ELSE
    BEGIN
        PRINT 'Data is valid.';
    END
END

EXEC SP_ValidateData ''
EXEC SP_ValidateData 'MALAY'

--8. Create a Procedure to Update Customer’s Email with Error Handling.
CREATE PROCEDURE SP_UpdateCustomerEmail
@Customer_id INT, @Email VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        UPDATE Customers
        SET Email = @Email
        WHERE Customer_id = @Customer_id;
        PRINT 'Email updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error updating email.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH;
END;

EXEC SP_UpdateCustomerEmail 1, 'MALAY@gmail.com'
EXEC SP_UpdateCustomerEmail 2, 'hardik@gmail.com'

-------------------------------------------------Part – C---------------------------------------------------------
	
--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another one”.
CREATE PROCEDURE SP_InsertCustomer
@Customer_id INT, @Customer_Name VARCHAR(250), @Email VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@Customer_id, @Customer_Name, @Email);
        PRINT 'Customer inserted successfully.';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 2627
        BEGIN
            PRINT 'The Customer_id is already taken. Try another one.';
        END
        ELSE
        BEGIN
            PRINT 'Error: ' + ERROR_MESSAGE();
        END
    END CATCH;
END;

EXEC SP_InsertCustomer 1, 'MALAY', 'MALAY@gmail.com'
EXEC SP_InsertCustomer 2, 'Hardik', 'hardik@gmail.com'

--10. Handle Duplicate Email Insertion in Customers Table.
	
BEGIN TRY
    INSERT INTO Customers (Customer_id, Customer_Name, Email)
    VALUES (3, 'Bhavin', 'hardik@example.com');
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 2627
    BEGIN
        PRINT 'Duplicate Email Insertion: The email address already exists.';
    END
    ELSE
    BEGIN
        PRINT 'Error: ' + ERROR_MESSAGE();
    END
END CATCH;
