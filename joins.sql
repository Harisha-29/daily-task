-----------1]

CREATE TABLE salesman1 (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(4,2)
);

CREATE TABLE customer1 (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT,
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id)
);

INSERT INTO salesman1 (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12);

INSERT INTO customer1 (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007),
(3001, 'Brad Guzan', 'London', NULL, 5005);

SELECT s.name AS Salesman1, c.cust_name AS Customer, s.city
FROM salesman1 s
INNER JOIN customer1 c ON s.city = c.city;

-------------2]

CREATE TABLE orders002 (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer1(customer_id)
);

INSERT INTO orders002(ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003);

SELECT o.ord_no, o.purch_amt, c.cust_name, c.city
FROM orders002 o
INNER JOIN customer1 c ON o.customer_id = c.customer_id
WHERE o.purch_amt BETWEEN 500 AND 2000;

-----------------3]

SELECT c.cust_name AS Customer, c.city, s.name AS Salesman, s.commission
FROM customer1 c
INNER JOIN salesman s ON c.salesman_id = s.salesman_id;

------------------4]

SELECT c.cust_name AS Customer, c.city AS Customer_City, 
       s.name AS Salesman, s.commission
FROM customer1 c
INNER JOIN salesman s ON c.salesman_id = s.salesman_id
WHERE s.commission > 0.12;

------------------5]

SELECT c.cust_name AS Customer, c.city AS Customer_City, 
       s.name AS Salesman, s.city AS Salesman_City, s.commission
FROM customer1 c
INNER JOIN salesman s ON c.salesman_id = s.salesman_id
WHERE c.city <> s.city
AND s.commission > 0.12;

-------------------6]

SELECT o.ord_no, o.ord_date, o.purch_amt, 
       c.cust_name AS Customer, c.grade, 
       s.name AS Salesman, s.commission
FROM orders002 o
INNER JOIN customer1 c ON o.customer_id = c.customer_id
INNER JOIN salesman1 s ON o.salesman_id = s.salesman_id;

--------------7]
SELECT o.ord_no, o.ord_date, o.purch_amt, 
       c.customer_id, c.cust_name, c.city AS customer_city, c.grade, 
       s.salesman_id, s.name AS salesman, s.city AS salesman_city, s.commission
FROM orders002 o
INNER JOIN customer1 c ON o.customer_id = c.customer_id
INNER JOIN salesman1 s ON o.salesman_id = s.salesman_id;

------------------8]

SELECT c.customer_id, c.cust_name, c.city AS customer_city, c.grade, 
       s.name AS salesman, s.city AS salesman_city
FROM customer1 c
INNER JOIN salesman s ON c.salesman_id = s.salesman_id
ORDER BY c.customer_id ASC;

-----------9]

SELECT 
    c.cust_name, 
    c.city AS customer_city, 
    c.grade, 
    s.name AS salesman, 
    s.city AS salesmancity
FROM customer1 c
JOIN salesman1 s ON c.salesman_id = s.salesman_id
WHERE c.grade < 300
ORDER BY c.customer_id;

-----------10]

SELECT 
    c.cust_name AS Customer_Name,
    c.city AS Customer_City,
    o.ord_no AS Order_Number,
    o.ord_date AS Order_Date,
    o.purch_amt AS Order_Amount
FROM customer1 c
LEFT JOIN orders002 o ON c.customer_id = o.customer_id
ORDER BY o.ord_date ASC;

-----------------11]

SELECT 
    c.cust_name AS Customer_Name,
    c.city AS Customer_City,
    o.ord_no AS Order_Number,
    o.ord_date AS Order_Date,
    o.purch_amt AS Order_Amount,
    s.name AS Salesperson_Name,
    s.commission AS Commission
FROM customer1 c
LEFT JOIN orders002 o ON c.customer_id = o.customer_id
LEFT JOIN salesman1 s ON c.salesman_id = s.salesman_id
ORDER BY o.ord_date ASC;

------12]

SELECT 
    s.salesman_id,
    s.name AS Salesperson_Name,
    s.city AS Salesperson_City,
    s.commission
FROM salesman1 s
LEFT JOIN customer1 c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name, s.city, s.commission
ORDER BY s.salesman_id ASC;

-------------13]

SELECT 
    s.salesman_id, 
    s.name AS salesman_name, 
    s.city AS salesman_city, 
    s.commission, 
    c.customer_id, 
    c.cust_name, 
    c.city AS customer_city, 
    c.grade, 
    o.ord_no, 
    o.ord_date, 
    o.purch_amt
FROM salesman1 s
LEFT JOIN customer1 c ON s.salesman_id = c.salesman_id
LEFT JOIN orders002 o ON c.customer_id = o.customer_id
ORDER BY s.salesman_id, c.customer_id, o.ord_date;

-------------14]

SELECT 
    s.salesman_id, 
    s.name AS salesman_name, 
    s.city AS salesman_city, 
    s.commission, 
    c.customer_id, 
    c.cust_name, 
    c.city AS customer_city, 
    c.grade, 
    o.ord_no, 
    o.ord_date, 
    o.purch_amt
FROM salesman1 s
LEFT JOIN customer1 c ON s.salesman_id = c.salesman_id
LEFT JOIN orders002 o ON c.customer_id = o.customer_id
WHERE (c.grade IS NOT NULL AND (o.purch_amt >= 2000 OR o.purch_amt IS NULL))
ORDER BY s.salesman_id, c.customer_id;

------------15]

CREATE TABLE salesmann (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(5,2)
);

CREATE TABLE customer001 (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT,
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id)
);

CREATE TABLE order1 (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer001(customer_id),
    FOREIGN KEY (salesman_id) REFERENCES salesmann(salesman_id)
);

INSERT INTO salesmann (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12);
INSERT INTO customer001 (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007),
(3001, 'Brad Guzan', 'London', NULL, 5005);
INSERT INTO order1 (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.50, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.50, '2012-08-17', 3009, 5003),
(70007, 948.50, '2012-09-10', 3005, 5002),
(70005, 2400.60, '2012-07-27', 3007, 5001),
(70008, 5760.00, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006);

SELECT * FROM salesman;
SELECT * FROM customer;
SELECT * FROM orders;

SELECT 
    COALESCE(c.cust_name, 'Unknown Customer') AS customer_name, 
    COALESCE(c.city, 'Unknown City') AS city, 
    o.ord_no, 
    o.ord_date, 
    o.purch_amt
FROM order1 o
LEFT JOIN customer001 c ON o.customer_id = c.customer_id
ORDER BY o.ord_date, o.ord_no;

----------16]

SELECT 
    c.cust_name, 
    c.city, 
    o.ord_no, 
    o.ord_date, 
    o.purch_amt
FROM 
    order1 o
LEFT JOIN 
    customer001 c ON o.customer_id = c.customer_id
WHERE 
    (c.grade IS NOT NULL AND o.customer_id IS NOT NULL) 
    OR (c.customer_id IS NULL OR c.grade IS NULL);


------------17]

SELECT 
    s.salesman_id, 
    s.name AS salesman_name, 
    s.city AS salesman_city, 
    s.commission, 
    c.customer_id, 
    c.cust_name AS customer_name, 
    c.city AS customer_city, 
    c.grade 
FROM 
    salesman1 s
CROSS JOIN 
    customer001 c;

------------18]

SELECT 
    s.salesman_id, 
    s.name AS salesman_name, 
    s.city AS salesman_city, 
    s.commission, 
    c.customer_id, 
    c.cust_name AS customer_name, 
    c.city AS customer_city, 
    c.grade 
FROM 
    salesman1 s
JOIN 
    customer001 c
ON 
    s.city = c.city;

------------------19]

SELECT 
    s.salesman_id, 
    s.name AS salesman_name, 
    s.city AS salesman_city, 
    s.commission, 
    c.customer_id, 
    c.cust_name AS customer_name, 
    c.city AS customer_city, 
    c.grade 
FROM 
    salesmann s
CROSS JOIN 
    customer001 c
WHERE 
    s.city IS NOT NULL 
    AND c.grade IS NOT NULL;


----------------20]

SELECT 
    s.salesman_id, 
    s.name AS salesman_name, 
    s.city AS salesman_city, 
    s.commission, 
    c.customer_id, 
    c.cust_name AS customer_name, 
    c.city AS customer_city, 
    c.grade 
FROM 
    salesmann s
CROSS JOIN 
    customer001 c
WHERE 
    s.city <> c.city
    AND c.grade IS NOT NULL;

------------------21]

CREATE TABLE company_mast (
    COM_ID INT PRIMARY KEY,
    COM_NAME VARCHAR(50) NOT NULL
);

CREATE TABLE item_mast (
    PRO_ID INT PRIMARY KEY,
    PRO_NAME VARCHAR(100) NOT NULL,
    PRO_PRICE DECIMAL(10,2) NOT NULL,
    PRO_COM INT,
    FOREIGN KEY (PRO_COM) REFERENCES company_mast(COM_ID)
);

INSERT INTO company_mast (COM_ID, COM_NAME) VALUES
(11, 'Samsung'),
(12, 'iBall'),
(13, 'Epsion'),
(14, 'Zebronics'),
(15, 'Asus'),
(16, 'Frontech');

INSERT INTO item_mast (PRO_ID, PRO_NAME, PRO_PRICE, PRO_COM) VALUES
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

SELECT * FROM company_mast;
SELECT * FROM item_mast;

SELECT 
    i.*, 
    c.COM_NAME 
FROM 
    item_mast i
INNER JOIN 
    company_mast c
ON 
    i.PRO_COM = c.COM_ID;

-------------22]

SELECT i.PRO_NAME, i.PRO_PRICE, c.COM_NAME
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID;

-----------------23]

SELECT c.COM_NAME, AVG(i.PRO_PRICE) AS AVG_PRICE
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID
GROUP BY c.COM_NAME;

-----------24]

SELECT c.COM_NAME, AVG(i.PRO_PRICE) AS AVG_PRICE
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID
GROUP BY c.COM_NAME
HAVING AVG(i.PRO_PRICE) >= 350;

------------------25]
SELECT i.PRO_NAME, i.PRO_PRICE, c.COM_NAME
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID
WHERE i.PRO_PRICE = (
    SELECT MAX(PRO_PRICE)
    FROM item_mast
    WHERE PRO_COM = i.PRO_COM
);

---------------------26]

CREATE TABLE emp_department (
    DPT_CODE INT PRIMARY KEY,
    DPT_NAME VARCHAR(50),
    DPT_ALLOTMENT DECIMAL(10,2)
);

CREATE TABLE emp_details (
    EMP_IDNO INT PRIMARY KEY,
    EMP_FNAME VARCHAR(50),
    EMP_LNAME VARCHAR(50),
    EMP_DEPT INT,
    FOREIGN KEY (EMP_DEPT) REFERENCES emp_department(DPT_CODE)
);

INSERT INTO emp_department (DPT_CODE, DPT_NAME, DPT_ALLOTMENT) VALUES
(57, 'IT', 65000),
(63, 'Finance', 15000),
(47, 'HR', 240000),
(27, 'RD', 55000),
(89, 'QC', 75000);

INSERT INTO emp_details (EMP_IDNO, EMP_FNAME, EMP_LNAME, EMP_DEPT) VALUES
(127323, 'Michale', 'Robbin', 57),
(526689, 'Carlos', 'Snares', 63),
(843795, 'Enric', 'Dosio', 57),
(328717, 'Jhon', 'Snares', 63),
(444527, 'Joseph', 'Dosni', 47),
(659831, 'Zanifer', 'Emily', 47),
(847674, 'Kuleswar', 'Sitaraman', 57),
(748681, 'Henrey', 'Gabriel', 47),
(555935, 'Alex', 'Manuel', 57);

SELECT * FROM emp_department;
SELECT * FROM emp_details;

SELECT e.EMP_IDNO, e.EMP_FNAME, e.EMP_LNAME, 
       d.DPT_NAME, d.DPT_ALLOTMENT
FROM emp_details e
JOIN emp_department d ON e.EMP_DEPT = d.DPT_CODE;

-------27]
SELECT 
    e.EMP_FNAME AS First_Name, 
    e.EMP_LNAME AS Last_Name, 
    d.DPT_NAME AS Department_Name, 
    d.DPT_ALLOTMENT AS Sanction_Amount
FROM emp_details e
JOIN emp_department d 
ON e.EMP_DEPT = d.DPT_CODE;

-----------------28]

SELECT 
    e.EMP_FNAME AS First_Name, 
    e.EMP_LNAME AS Last_Name, 
    d.DPT_NAME AS Department_Name, 
    d.DPT_ALLOTMENT AS Budget
FROM emp_details e
JOIN emp_department d 
ON e.EMP_DEPT = d.DPT_CODE
WHERE d.DPT_ALLOTMENT > 50000;

----------------29]

SELECT d.DPT_NAME
FROM emp_details e
JOIN emp_department d ON e.EMP_DEPT = d.DPT_CODE
GROUP BY d.DPT_NAME
HAVING COUNT(e.EMP_IDNO) > 2;
