create database subquery;

use subquery

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

































