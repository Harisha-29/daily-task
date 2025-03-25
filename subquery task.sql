create database Subquery;

use Subquery

------------------------------1]--------------------------------
CREATE TABLE Salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(5,2)
);

CREATE TABLE Orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (salesman_id) REFERENCES Salesman(salesman_id)
);
INSERT INTO Salesman (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', 'San Jose', 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);

INSERT INTO Orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE salesman_id = (
    SELECT salesman_id 
    FROM Salesman 
    WHERE name = 'Paul Adam'
);

-------------------------2]------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE salesman_id IN (
    SELECT salesman_id 
    FROM Salesman 
    WHERE city = 'London'
);

------------------------3]-------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE salesman_id IN (
    SELECT DISTINCT salesman_id 
    FROM Orders 
    WHERE customer_id = 3007
);

--------------------------4]------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE ord_date = '2012-10-10'
AND purch_amt > (
    SELECT AVG(purch_amt) 
    FROM Orders 
    WHERE ord_date = '2012-10-10'
);

---------------------------5]-------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE salesman_id IN (
    SELECT salesman_id 
    FROM Salesman 
    WHERE city = 'New York'
);

---------------------------6]---------------------------
SELECT commission
FROM Salesman
WHERE city = 'Paris';

------------------------7]------------------------------

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(100),
    city VARCHAR(100),
    grade INT,
    salesman_id INT
);
INSERT INTO Customer (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', 100, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002),
(3003, 'Jozy Altidor', 'Moncow', 200, 5007);


SELECT customer_id, cust_name, city, grade, salesman_id
FROM Customer
WHERE salesman_id = (
    SELECT salesman_id 
    FROM Salesman 
    WHERE name = 'Mc Lyon'
) 
AND customer_id < 2001;

----------------8]----------------------
SELECT grade, COUNT(*) AS customer_count
FROM Customer
WHERE city = 'New York' 
AND grade > (SELECT AVG(grade) FROM Customer)
GROUP BY grade;

-------------------9]---------------------

SELECT ord_no, purch_amt, ord_date, salesman_id
FROM Orders
WHERE salesman_id IN (
    SELECT salesman_id 
    FROM Salesman 
    WHERE commission = (SELECT MAX(commission) FROM Salesman)
);

-----------------------10]---------------------
SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id,
       (SELECT cust_name FROM Customer c WHERE c.customer_id = o.customer_id) AS cust_name
FROM Orders o
WHERE ord_date = '2012-08-17';

---------------------11]-----------------------
SELECT salesman_id, name
FROM Salesman
WHERE salesman_id IN (
    SELECT salesman_id
    FROM Customer
    GROUP BY salesman_id
    HAVING COUNT(customer_id) > 1
);

----------------------12]------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt > (
    SELECT AVG(purch_amt) FROM Orders
);

---------------------13]--------------------------
SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt >= (
    SELECT AVG(purch_amt) FROM Orders
);

----------------------14]------------------------
SELECT ord_date, SUM(purch_amt) AS total_amount
FROM Orders
GROUP BY ord_date
HAVING SUM(purch_amt) >= (
    SELECT MAX(purch_amt) FROM Orders o WHERE o.ord_date = Orders.ord_date
) + 1000;

---------------------15]-----------------------

SELECT * 
FROM Customer
WHERE EXISTS (
    SELECT 1 
    FROM Customer 
    WHERE city = 'London'
);

----------------------16]------------------------
SELECT salesman_id, name, city, commission
FROM Salesman
WHERE salesman_id IN (
    SELECT salesman_id
    FROM Customer
    GROUP BY salesman_id
    HAVING COUNT(customer_id) > 1
);
-------------------------17]-------------------

SELECT salesman_id, name, city, commission
FROM Salesman
WHERE salesman_id IN (
    SELECT salesman_id
    FROM Customer
    GROUP BY salesman_id
    HAVING COUNT(customer_id) = 1
);

---------------------------18]-------------------
SELECT salesman_id, name, city, commission
FROM Salesman
WHERE salesman_id IN (
    SELECT DISTINCT c.salesman_id
    FROM Customer c
    WHERE c.customer_id IN (
        SELECT customer_id
        FROM Orders
        GROUP BY customer_id
        HAVING COUNT(ord_no) > 1
    )
);

-----------------------19]--------------------------
SELECT salesman_id, name, city, commission
FROM Salesman
WHERE city IN (
    SELECT DISTINCT city FROM Customer
);

-------------------------20]-----------------------------
SELECT salesman_id, name, city, commission
FROM Salesman
WHERE city IN (
    SELECT DISTINCT city FROM Customer
);

-----------------------21]---------------------------------
SELECT salesman_id, name, city, commission
FROM Salesman s
WHERE EXISTS (
    SELECT 1
    FROM Customer c
    WHERE s.name < c.cust_name
);

select * from Customer

-----------------------------22]-------------------------
SELECT customer_id, cust_name, city, grade, salesman_id
FROM Customer
WHERE grade > (
    SELECT MAX(grade)
    FROM Customer
    WHERE city > 'New York'
);
---------------------------23]--------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt > (
    SELECT MIN(purch_amt)
    FROM Orders
    WHERE ord_date = '2012-09-10'
);

------------------------24]---------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt < ANY (
    SELECT purch_amt
    FROM Orders
    WHERE customer_id IN (
        SELECT customer_id
        FROM Customer
        WHERE city = 'London'
    )
);

-----------------------25]---------------------------

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt < (
    SELECT MAX(purch_amt)
    FROM Orders
    WHERE customer_id IN (
        SELECT customer_id
        FROM Customer
        WHERE city = 'London'
    )
);

---------------------------26]----------------------------
SELECT customer_id, cust_name, city, grade, salesman_id
FROM Customer
WHERE grade > (
    SELECT MAX(grade)
    FROM Customer
    WHERE city = 'New York'
);

--------------------------27]-----------------------------

SELECT s.name AS salesperson_name, s.city, 
       COALESCE(SUM(o.purch_amt), 0) AS total_order_amount
FROM Salesman s
JOIN Orders o ON s.salesman_id = o.salesman_id
WHERE s.city IN (SELECT DISTINCT city FROM Customer)
GROUP BY s.name, s.city;
------------------------28]-------------------------------

SELECT customer_id, cust_name, city, grade, salesman_id
FROM Customer
WHERE grade NOT IN (SELECT DISTINCT grade FROM Customer WHERE city = 'London');

--------------------------29]----------------------------
SELECT customer_id, cust_name, city, grade, salesman_id
FROM Customer
WHERE grade NOT IN (SELECT DISTINCT grade FROM Customer WHERE city = 'Paris');

------------------------------30]-----------------------------
SELECT customer_id, cust_name, city, grade, salesman_id
FROM Customer
WHERE grade NOT IN (SELECT DISTINCT grade FROM Customer WHERE city = 'Dallas');

-------------------------------31]---------------------------
CREATE TABLE item_mast1 (
    PRO_ID INT PRIMARY KEY,
    PRO_NAME VARCHAR(50),
    PRO_PRICE DECIMAL(10,2),
    PRO_COM INT
);

CREATE TABLE company_mast1 (
    COM_ID INT PRIMARY KEY,
    COM_NAME VARCHAR(50)
);

INSERT INTO item_mast1 (PRO_ID, PRO_NAME, PRO_PRICE, PRO_COM) VALUES
(101, 'Mother Board', 3200.00, 15),
(102, 'Key Board', 450.00, 16),
(103, 'ZIP drive', 250.00, 14),
(104, 'Speaker', 550.00, 16),
(105, 'Monitor', 5000.00, 11),
(106, 'DVD drive', 900.00, 12),
(107, 'CD drive', 800.00, 12),
(108, 'Printer', 2600.00, 13),
(109, 'Refill cartridge', 350.00, 13),
(110, 'Mouse', 250.00, 12);

INSERT INTO company_mast1 (COM_ID, COM_NAME) VALUES
(11, 'Samsung'),
(12, 'iBall'),
(13, 'Epsion'),
(14, 'Zebronics'),
(15, 'Asus'),
(16, 'Frontech');

SELECT 
    AVG(PRO_PRICE) AS Average_Price,
    c.COM_NAME AS Company
FROM item_mast1 i
JOIN company_mast1 c ON i.PRO_COM = c.COM_ID
GROUP BY c.COM_NAME;

-----------------------32]--------------------------
SELECT 
    (SELECT COM_NAME FROM company_mast1 WHERE COM_ID = i.PRO_COM) AS Company,
    AVG(PRO_PRICE) AS Average_Price
FROM item_mast1 i
WHERE PRO_PRICE >= 350
GROUP BY i.PRO_COM;

--------------------------33]---------------------------

SELECT 
    i.PRO_NAME AS Product_Name, 
    i.PRO_PRICE AS Price, 
    (SELECT c.COM_NAME FROM company_mast1 c WHERE c.COM_ID = i.PRO_COM) AS Company
FROM item_mast1 i
WHERE i.PRO_PRICE = (
    SELECT MAX(PRO_PRICE) 
    FROM item_mast1
    WHERE PRO_COM = i.PRO_COM
);

-------------------------34]-------------------------------
-- Create the table
CREATE TABLE emp_details1 (
    emp_idno INT PRIMARY KEY,
    emp_fname VARCHAR(50),
    emp_lname VARCHAR(50),
    emp_dept INT
);

-- Insert values into the table
INSERT INTO emp_details1 (emp_idno, emp_fname, emp_lname, emp_dept) VALUES
(127323, 'Michale', 'Robbin', 57),
(526689, 'Carlos', 'Snares', 63),
(843795, 'Enric', 'Dosio', 57),
(328717, 'Jhon', 'Snares', 63),
(444527, 'Joseph', 'Dosni', 47),
(659831, 'Zanifer', 'Emily', 47),
(847674, 'Kuleswar', 'Sitaraman', 57),
(748681, 'Henrey', 'Gabriel', 47),
(555935, 'Alex', 'Manuel', 57),
(539569, 'George', 'Mardy', 27),
(733843, 'Mario', 'Saule', 63),
(631548, 'Alan', 'Snappy', 27),
(839139, 'Maria', 'Foster', 57);

SELECT emp_idno, emp_fname, emp_lname, emp_dept
FROM emp_details1
WHERE emp_lname IN (
    SELECT emp_lname 
    FROM emp_details1
    WHERE emp_lname IN ('Gabriel', 'Dosio')
);

------------------------------35]---------------------------
SELECT emp_idno, emp_fname, emp_lname, emp_dept
FROM emp_details1
WHERE emp_dept IN (SELECT DISTINCT emp_dept FROM emp_details1 WHERE emp_dept IN (89, 63));

----------------------------------36]----------------------------

CREATE TABLE emp_department1 (
    dpt_code INT PRIMARY KEY,
    dpt_name VARCHAR(50),
    dpt_allotment DECIMAL(10,2)
);

-- Insert values into emp_department
INSERT INTO emp_department1 (dpt_code, dpt_name, dpt_allotment) VALUES
(57, 'IT', 65000),
(63, 'Finance', 15000),
(47, 'HR', 240000),
(27, 'RD', 55000),
(89, 'QC', 75000);

SELECT emp_fname, emp_lname
FROM emp_details1
WHERE emp_dept IN (
    SELECT dpt_code
    FROM emp_department1
    WHERE dpt_allotment > 50000
);

------------------------37]---------------------------
SELECT dpt_code, dpt_name, dpt_allotment
FROM emp_department1
WHERE dpt_allotment > (
    SELECT AVG(dpt_allotment) 
    FROM emp_department1
);

-------------------------38]----------------------------

SELECT dpt_name
FROM emp_department1
WHERE dpt_code IN (
    SELECT emp_dept
    FROM emp_details1
    GROUP BY emp_dept
    HAVING COUNT(emp_idno) > 2
);

-----------------------39]---------------------------

SELECT emp_fname, emp_lname 
FROM emp_details1 
WHERE emp_dept = (
    SELECT TOP 1 dpt_code 
    FROM emp_department1 
    WHERE dpt_allotment > (SELECT MIN(dpt_allotment) FROM emp_department1) 
    ORDER BY dpt_allotment ASC
);
