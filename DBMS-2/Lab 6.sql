--From the above given tables perform the following queries:  
--  Create the Products table 

CREATE TABLE Products ( 
Product_id INT PRIMARY KEY, 
Product_Name VARCHAR(250) NOT NULL, 
Price DECIMAL(10, 2) NOT NULL 
); 

--  Insert data into the Products table 
INSERT INTO Products (Product_id, Product_Name, Price) VALUES 
(1, 'Smartphone', 35000), 
(2, 'Laptop', 65000), 
(3, 'Headphones', 5500), 
(4, 'Television', 85000), 
(5, 'Gaming Console', 32000); 

----------------------------------Part - A--------------------------------------- 
--1. Create a cursor Product_Cursor to fetch all the rows from a products table. 
	declare @ID int, @Name varchar(100), @Price decimal(10,2) 

	declare cursor_FetchData cursor
	for
		select * 
		from Products

	open cursor_FetchData

	fetch next from cursor_FetchData
	into @ID, @Name, @Price

	while @@FETCH_STATUS = 0
	begin
		print(cast(@ID as varchar(100)) + ' ' + @Name + ' ' +  cast(@Price as varchar(100)))
		fetch next from cursor_FetchData
		into @ID, @Name, @Price
	end

	close cursor_FetchData

	deallocate cursor_FetchData
		
--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. 
	declare @ID1 int, @Name1 varchar(100) 

	declare Product_Cursor_Fetch cursor
	for
		select Product_id, Product_Name
		from Products

	open Product_Cursor_Fetch

	fetch next from Product_Cursor_Fetch
	into @ID1, @Name1

	while @@FETCH_STATUS = 0
	begin
		print(cast(@ID1 as varchar(100)) + '_' + @Name1)

		fetch next from Product_Cursor_Fetch
		into @ID1, @Name1
	end

	close Product_Cursor_Fetch

	deallocate Product_Cursor_Fetch
		
--(Example: 1_Smartphone) 
--3. Create a Cursor to Find and Display Products Above Price 30,000. 
	
	declare @ID2 int, @Name2 varchar(100), @Price2 decimal(10, 2)

	declare Product_Cursor_Fetch_Price cursor
	for 
		select *
		from Products
		where Price > 30000

	open Product_Cursor_Fetch_Price

	fetch next from Product_Cursor_Fetch_Price
	into @ID2, @Name2, @Price2

	while @@FETCH_STATUS = 0
	begin
		print(cast(@ID2 as varchar(100)) + '_' + @Name2 + ' ' + cast(@Price2 as varchar(100)))

		fetch next from Product_Cursor_Fetch_Price
		into @ID2, @Name2, @Price2
	end

	close Product_Cursor_Fetch_Price

	deallocate Product_Cursor_Fetch_Price
		
--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
	
	declare @ProductID int;

	declare Product_CursorDelete cursor
	for
		select Product_id
		from Products

	open Product_CursorDelete

	fetch next from Product_CursorDelete
	into @ProductID

	while @@FETCH_STATUS = 0
	begin
		delete from
		Products 
		where Product_id = @ProductID

		fetch next from Product_CursorDelete 
		into @ProductID

	end

	close Product_CursorDelete

	deallocate Product_CursorDelete	
		
----------------------------------Part - B--------------------------------------- 
--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases 
--the price by 10%.
		
	declare @Product_id int,@Product_name varchar(100),@Price int

	declare Product_CursorUpdate cursor
	for 
		select Product_id,Product_name,Price from Products

	open Product_CursorUpdate

	fetch next from Product_CursorUpdate
	into @Product_id,@Product_name,@Price

	while @@FETCH_STATUS=0
	begin
		update Products
		set Price=Price+Price*0.1

		fetch next from Product_CursorUpdate 
		into @Product_id,@Product_name,@Price

	end

	close Product_CursorUpdate

	deallocate Product_CursorUpdate

	select * from Products

--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
		
	declare @Price int

	declare Product_CursorRound cursor
	for 
		select Price from Products

	open Product_CursorRound

	fetch next from Product_CursorRound
	into @Price

	while @@FETCH_STATUS=0
	begin
		update Products
		set Price=Round(Price,0)
		
		fetch next from Product_CursorRound 
		into @Price

	end

	close Product_CursorRound

	deallocate Product_CursorRound
		
	select * from Products

----------------------------------Part - C--------------------------------------- 
--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” 
--(Note: Create NewProducts table first with same fields as Products table)
		
CREATE TABLE NewProducts (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

DECLARE @Product_id INT;
DECLARE @Product_Name VARCHAR(250);
DECLARE @Price DECIMAL(10, 2);

DECLARE NewProducts_Cursor_Insert CURSOR FOR
SELECT Product_id, Product_Name, Price
FROM Products
WHERE Product_Name = 'Laptop';

OPEN NewProducts_Cursor_Insert;

FETCH NEXT FROM NewProducts_Cursor_Insert INTO @Product_id, @Product_Name, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NewProducts (Product_id, Product_Name, Price)
    VALUES (@Product_id, @Product_Name, @Price);

    FETCH NEXT FROM NewProducts_Cursor_Insert INTO @Product_id, @Product_Name, @Price;
END;

CLOSE NewProducts_Cursor_Insert;
DEALLOCATE NewProducts_Cursor_Insert;

--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products with a price above 50000 to an archive table, removing them from the original Products table.

CREATE TABLE ArchivedProducts (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

DECLARE @Product_id INT;
DECLARE @Product_Name VARCHAR(250);
DECLARE @Price DECIMAL(10, 2);

DECLARE ArchivedProducts_Cursor_Insert CURSOR FOR
SELECT Product_id, Product_Name, Price
FROM Products
WHERE Price > 50000;

OPEN ArchivedProducts_Cursor_Insert;

FETCH NEXT FROM ArchivedProducts_Cursor_Insert INTO @Product_id, @Product_Name, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO ArchivedProducts (Product_id, Product_Name, Price)
    VALUES (@Product_id, @Product_Name, @Price);

	DELETE FROM Products
    WHERE Product_id = @Product_id;

    FETCH NEXT FROM ArchivedProducts_Cursor_Insert INTO @Product_id, @Product_Name, @Price;
END;

CLOSE ArchivedProducts_Cursor_Insert;
DEALLOCATE ArchivedProducts_Cursor_Insert;
