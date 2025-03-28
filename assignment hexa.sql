CREATE DATABASE Bank;
USE Bank;

------------------***************-------------
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id) ON DELETE CASCADE,
    account_type VARCHAR(20) CHECK (account_type IN ('savings', 'current', 'zero_balance')),
    balance DECIMAL(18,2) CHECK (balance >= 0) NOT NULL
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT FOREIGN KEY REFERENCES Accounts(account_id) ON DELETE CASCADE,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer')),
    amount DECIMAL(18,2) CHECK (amount > 0),
    transaction_date DATETIME DEFAULT GETDATE()
);

------------------------------ 1] insert values----------------

INSERT INTO Customers (first_name, last_name, DOB, email, phone_number, address)
VALUES 
('John', 'Doe', '1990-01-15', 'john.doe@example.com', '1234567890', '123 Main St, New York'),
('Jane', 'Smith', '1985-05-20', 'jane.smith@example.com', '9876543210', '456 Oak St, California'),
('Robert', 'Brown', '1992-07-10', 'robert.brown@example.com', '7418529630', '789 Pine St, Texas'),
('Emily', 'Johnson', '1988-03-25', 'emily.johnson@example.com', '8529637410', '369 Elm St, Florida'),
('Michael', 'Williams', '1995-06-30', 'michael.williams@example.com', '9637418520', '159 Maple St, Illinois'),
('Sarah', 'Miller', '1993-08-12', 'sarah.miller@example.com', '7419638520', '852 Cedar St, Washington'),
('David', 'Davis', '1980-09-17', 'david.davis@example.com', '7894561230', '963 Redwood St, Arizona'),
('Sophia', 'Wilson', '1991-12-05', 'sophia.wilson@example.com', '4561237890', '357 Birch St, Colorado'),
('James', 'Taylor', '1987-11-21', 'james.taylor@example.com', '3216549870', '741 Spruce St, Nevada'),
('Olivia', 'Anderson', '1998-04-07', 'olivia.anderson@example.com', '9517532580', '654 Palm St, Georgia');


INSERT INTO Accounts (customer_id, account_type, balance)
VALUES 
(1, 'savings', 5000.00),
(2, 'current', 12000.00),
(3, 'savings', 3000.00),
(4, 'current', 25000.00),
(5, 'zero_balance', 0.00),
(6, 'savings', 10000.00),
(7, 'current', 15000.00),
(8, 'savings', 7500.00),
(9, 'zero_balance', 0.00),
(10, 'current', 18000.00);

INSERT INTO Transactions (account_id, transaction_type, amount, transaction_date)
VALUES 
(1, 'deposit', 2000.00, '2025-03-10'),
(2, 'withdrawal', 500.00, '2025-03-11'),
(3, 'deposit', 1000.00, '2025-03-12'),
(4, 'deposit', 5000.00, '2025-03-13'),
(5, 'withdrawal', 100.00, '2025-03-14'),
(6, 'deposit', 3000.00, '2025-03-15'),
(7, 'withdrawal', 700.00, '2025-03-16'),
(8, 'deposit', 1200.00, '2025-03-17'),
(9, 'deposit', 2500.00, '2025-03-18'),
(10, 'withdrawal', 450.00, '2025-03-19');

------------------  2.1]--------------------

Select name,acount_type, email from customer

---------------- 2.2] -------------------------

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    c.email,
    a.account_id,
    a.account_type,
    t.transaction_id,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
ORDER BY c.customer_id, t.transaction_date;

---------------------- 2.3]------------------

UPDATE Accounts
SET balance = balance + 5000  -- Increase balance by 5000
WHERE account_id = 1;  -- Update for a specific account_id

-------------------  2.4] ----------------------

SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name
FROM Customers;

------------------  2.5] ----------------------

DELETE FROM Accounts
WHERE balance = 0 AND account_type = 'savings';

------------------  2.6] -----------------------

SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name,
    email,
    phone_number,
    address
FROM Customers
WHERE address LIKE '%New York%';  -- Replace 'New York' with target city

----------------  2.7] ----------------------------

SELECT 
    account_id, 
    balance 
FROM Accounts 
WHERE account_id = 1; 

----------------  2.8] ----------------------------

SELECT 
    account_id, 
    customer_id, 
    balance 
FROM Accounts 
WHERE account_type = 'current' 
AND balance > 1000;

-------------------- 2.9] ------------------------

SELECT 
    transaction_id, 
    account_id, 
    transaction_type, 
    amount, 
    transaction_date
FROM Transactions
WHERE account_id = 1;  

--------------------- 2.10] -----------------------

SELECT 
    account_id, 
    customer_id, 
    balance, 
    0.05 * balance AS interest_accrued  -- Assuming 5% interest rate (0.05)
FROM Accounts
WHERE account_type = 'savings';

-------------------- 2.11] --------------------

SELECT 
    account_id, 
    customer_id, 
    balance 
FROM Accounts
WHERE balance < 200; 

-------------------- 2.12] ----------------------

SELECT 
    customer_id, 
    first_name + ' ' + last_name AS full_name, 
    email, 
    phone_number, 
    address
FROM Customers
WHERE address NOT LIKE '%New York%';  -- Replace 'New York' with target city



-----***********Tasks 3: Aggregate functions, Having, Order By, GroupBy and Joins *************------------


-------------  3.1]  ------------------

SELECT AVG(balance) AS average_balance
FROM Accounts;

---------------- 3.2] -----------------

SELECT TOP 10 account_id, customer_id, account_type, balance
FROM Accounts
ORDER BY balance DESC;  ----------- it does no support limit in server

------------------ 3.3] ----------------

SELECT transaction_date, SUM(amount) AS total_deposits
FROM Transactions
WHERE transaction_type = 'deposit'  -------total deposits for each date
GROUP BY transaction_date;

SELECT SUM(amount) AS total_deposits
FROM Transactions
WHERE transaction_type = 'deposit' 
AND transaction_date = '2025-03-10';  -- with the specific date

----------------------3.4] ---------------------------

SELECT * 
FROM Customers 
WHERE DOB = (SELECT MIN(DOB) FROM Customers) 
   OR DOB = (SELECT MAX(DOB) FROM Customers);

-------------------- 3.5] -------------------------------

SELECT 
    t.transaction_id,
    t.account_id,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id;


--------------------3.6] -------------------------------

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    c.phone_number,
    c.address,
    a.account_id,
    a.account_type,
    a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

----------------------3.7] ----------------------------

SELECT 
    t.transaction_id,
    t.account_id,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    c.phone_number,
    c.address
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
WHERE t.account_id = 1; -- for specific account_id you want to filter

-------------------------3.8] ------------------------

SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name, 
    COUNT(a.account_id) AS account_count
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(a.account_id) > 1;

---------------------3.9] ---------------------------

SELECT 
    account_id,
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) 
    - SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) 
    AS transaction_difference
FROM Transactions
GROUP BY account_id;

-------------------3.10] ----------------------------

SELECT 
    t.account_id,
    SUM(t.amount) / COUNT(DISTINCT t.transaction_date) AS avg_daily_balance
FROM Transactions t
WHERE t.transaction_date BETWEEN '2025-03-01' AND '2025-03-20'
GROUP BY t.account_id;

------------------- 3.11] ----------------------------

SELECT 
    account_type, 
    SUM(balance) AS total_balance
FROM Accounts
GROUP BY account_type;

------------------ 3.12] -------------------------------
SELECT 
    account_id, 
    COUNT(transaction_id) AS transaction_count
FROM Transactions
GROUP BY account_id
ORDER BY transaction_count DESC;

-------------------- 3.13] -----------------------------

SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name, 
    a.account_type, 
    SUM(a.balance) AS total_balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.account_type
HAVING SUM(a.balance) > 10000
ORDER BY total_balance DESC;

---------------------3.14] -----------------------------

SELECT 
    account_id, 
    amount, 
    transaction_date, 
    COUNT(*) AS duplicate_count
FROM Transactions
GROUP BY account_id, amount, transaction_date
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

----***********Tasks 4: Subquery and its type**********---------------


-------------------4.1] ------------------------------------


SELECT c.customer_id, c.first_name, c.last_name, a.balance 
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance = (SELECT MAX(balance) FROM Accounts);

----------------------4.2] ---------------------------------

SELECT AVG(balance) AS avg_balance 
FROM Accounts 
WHERE customer_id IN (
    SELECT customer_id FROM Accounts GROUP BY customer_id HAVING COUNT(*) > 1
);

----------------------4.3] -----------------------------------

SELECT * FROM Transactions 
WHERE amount > (SELECT AVG(amount) FROM Transactions);

--------------------------4.4]--------------------------------

SELECT c.customer_id, c.first_name, c.last_name 
FROM Customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT a.customer_id FROM Accounts a 
    JOIN Transactions t ON a.account_id = t.account_id
);

--------------------------4.5] ---------------------------------

SELECT SUM(balance) AS total_balance 
FROM Accounts 
WHERE account_id NOT IN (SELECT DISTINCT account_id FROM Transactions);

-------------------------4.6] ----------------------------------

SELECT * FROM Transactions 
WHERE account_id IN (
    SELECT account_id FROM Accounts 
    WHERE balance = (SELECT MIN(balance) FROM Accounts)
);

-----------------------4.7] ------------------------------------

SELECT customer_id 
FROM Accounts 
GROUP BY customer_id 
HAVING COUNT(DISTINCT account_type) > 1;

-----------------------4.8] -----------------------------------

SELECT account_type, 
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Accounts) AS percentage 
FROM Accounts 
GROUP BY account_type;

----------------------4.9] -------------------------------------

SELECT t.* FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
WHERE a.customer_id = 1; 

----------------------4.10] --------------------------------------

SELECT account_type, 
       (SELECT SUM(balance) FROM Accounts a2 WHERE a2.account_type = a1.account_type) AS total_balance
FROM Accounts a1
GROUP BY account_type;





-----------------------*************************************************-------------------------------------
















