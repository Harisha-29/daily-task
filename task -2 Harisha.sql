---1]

CREATE TABLE Employees1 (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice Johnson', 'HR', 60000),
(2, 'Bob Smith', 'IT', 55000),
(3, 'Charlie Brown', 'HR', 45000),
(4, 'Diana Prince', 'HR', 70000),
(5, 'Ethan Hunt', 'Finance', 65000);
select * from Employees1

SELECT Name 
FROM Employees1 
WHERE Department = 'HR' 
AND Salary > 50000;

---2]

CREATE TABLE Orders1 (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2)
);

INSERT INTO Orders1 (OrderID, CustomerID, OrderDate, OrderAmount) VALUES
(1, 101, '2024-03-01', 250.00),
(2, 102, '2024-03-02', 300.00),
(3, 101, '2024-03-05', 150.00), 
(4, 103, '2024-03-06', 400.00),
(5, 102, '2024-03-07', 100.00), 
(6, 104, '2024-03-08', 350.00),
(7, 101, '2024-03-09', 500.00); 

select * from Orders1


SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders1
GROUP BY CustomerID
HAVING COUNT(*) > 1;

----3]

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE
);


INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 201, 5, '2024-03-01'),
(2, 202, 10, '2024-03-02'),
(3, 201, 7, '2024-03-03'),
(4, 203, 3, '2024-03-04'),
(5, 202, 8, '2024-03-05'),
(6, 201, 4, '2024-03-06');
select * from Sales

SELECT ProductID, SUM(Quantity) AS TotalQuantitySold
FROM Sales
GROUP BY ProductID;


----4]

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    Amount DECIMAL(10,2)
);


INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount) VALUES
(1, 1001, '2024-02-20', 500.00),
(2, 1002, '2024-03-05', 250.00),
(3, 1003, '2024-03-10', 300.00),
(4, 1001, '2024-03-18', 150.00),
(5, 1002, '2024-03-20', 200.00);

select * from Transactions

SELECT * 
FROM Transactions 
WHERE TransactionDate >= DATEADD(DAY, -30, GETDATE()); -- For SQL Server

select * from Transactions

---5]

CREATE TABLE Products1 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    StockQuantity INT
);

INSERT INTO Products1 (ProductID, ProductName, Price, StockQuantity) VALUES
(1, 'Laptop', 1000.00, 50),    -- Will be updated (Stock < 100)
(2, 'Mouse', 20.00, 200),      -- Won't be updated (Stock >= 100)
(3, 'Keyboard', 50.00, 80),    -- Will be updated (Stock < 100)
(4, 'Monitor', 300.00, 150),   -- Won't be updated (Stock >= 100)
(5, 'Headphones', 80.00, 90);  -- Will be updated (Stock < 100)


UPDATE Products1
SET Price = Price * 1.10
WHERE StockQuantity < 100;

SELECT * FROM Products1;

----6]

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(100),
    Email VARCHAR(150),
    Status VARCHAR(50),
    LastLoginDate DATE
);


INSERT INTO Users (UserID, Username, Email, Status, LastLoginDate) VALUES
(1, 'Alice', 'alice@example.com', 'active', '2024-03-10'),
(2, 'Bob', 'bob@example.com', 'inactive', '2023-01-15'), 
(3, 'Charlie', 'charlie@example.com', 'inactive', '2022-12-20'), 
(4, 'David', 'david@example.com', 'active', '2023-12-01'),
(5, 'Eve', 'eve@example.com', 'inactive', '2024-02-05'); 

DELETE FROM Users
WHERE Status = 'inactive' 
AND LastLoginDate <= DATEADD(YEAR, -1, CAST(GETDATE() AS DATE));

SELECT * FROM Users;

----9]

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Discount VARCHAR(50)  
);


INSERT INTO Products (ProductID, ProductName, Category, Discount) VALUES
(1, 'Laptop', 'Electronics', '10%'),
(2, 'Mouse', 'Electronics', NULL),  
(3, 'Table', 'Furniture', '15%'),
(4, 'Chair', 'Furniture', NULL),    
(5, 'Headphones', 'Electronics', '5%');

SELECT ProductName, COALESCE(Discount, 'No Discount') AS Discount
FROM Products;

----10]

CREATE TABLE Sales1 (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    SaleAmount DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO Sales1(SaleID, ProductID, SaleAmount, SaleDate) VALUES
(1, 101, 500.00, '2024-03-01'),
(2, 101, 700.00, '2024-03-05'),
(3, 101, 600.00, '2024-03-10'),
(4, 102, 200.00, '2024-03-02'),
(5, 102, 400.00, '2024-03-07'),
(6, 102, 300.00, '2024-03-09');

SELECT 
    SaleID, 
    ProductID, 
    SaleAmount, 
    SaleDate, 
    RANK() OVER (PARTITION BY ProductID ORDER BY SaleAmount DESC) AS Rank
FROM Sales1;

---11]

CREATE TABLE test_a (
    id NUMERIC
);

CREATE TABLE test_b (
    id NUMERIC
);

INSERT INTO test_a (id) VALUES
(10), (20), (30), (40), (50);

INSERT INTO test_b (id) VALUES
(10), (30), (50);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary DECIMAL(10,2)
);

INSERT INTO Employee (EmployeeID, Name, Salary) VALUES
(1, 'Alice', 60000),
(2, 'Bob', 70000),
(3, 'Charlie', 50000),
(4, 'David', 90000),
(5, 'Eve', 55000),
(6, 'Frank', 75000),
(7, 'Grace', 72000),
(8, 'Hannah', 68000),
(9, 'Ian', 71000),
(10, 'Jack', 80000),
(11, 'Karen', 73000),
(12, 'Leo', 67000);

SELECT DISTINCT Salary 
FROM Employee 
ORDER BY Salary DESC 
OFFSET 9 ROWS FETCH NEXT 1 ROW ONLY; 

CREATE TABLE ExampleTable (
    Col1 INT,
    Col2 INT
);

INSERT INTO ExampleTable (Col1, Col2) VALUES
(1, 0), 
(0, 1), 
(0, 1), 
(0, 1), 
(1, 0), 
(0, 1);

UPDATE ExampleTable
SET Col2 = CASE WHEN Col1 = 1 THEN 0 ELSE 1
END;

