CREATE DATABASE SISDB;
GO

USE SISDB;
go
-- Creating Schema
CREATE SCHEMA info;
go
-- Creating Students Table
CREATE TABLE info.students (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(20) NOT NULL,
    last_name NVARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    phone_number NVARCHAR(15) UNIQUE NOT NULL  
);

-- Creating Teachers Table
CREATE TABLE info.teachers (
    teacher_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE
);

-- Creating Courses Table
CREATE TABLE info.courses (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits INT NOT NULL,
    teacher_id INT NULL,  
    FOREIGN KEY (teacher_id) REFERENCES info.teachers(teacher_id) ON DELETE SET NULL
);

-- Creating Enrollments Table
CREATE TABLE info.enrollments (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES info.students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES info.courses(course_id) ON DELETE CASCADE
);

-- Creating Payments Table
CREATE TABLE info.payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES info.students(student_id) ON DELETE CASCADE
);

---------------------------------------INSERTING VALUES---------------------------------------

-- Inserting into Students Table 
INSERT INTO info.students (first_name, last_name, date_of_birth, email, phone_number)
VALUES 
('harisha', 'hgf', '1998-05-10', 'harisha.hgf@gmail.com', '9876543211'),
('rekha', 'iyer', '1997-07-22', 'rekha.iyer@gmail.com', '8765432109'),
('hari', 'krishna', '1996-03-15', 'hari.krishna@gmail.com', '7654321098'),
('prthu', 'reddy', '1999-11-05', 'prthu.reddy@gmail.com', '6543210987'),
('dharani', 'pillai', '2000-09-25', 'dharani.pillai@gmail.com', '5432109876'),
('pravallika', 'gowda', '1998-02-18', 'pravallika.gowda@gmail.com', '4321098765'),
('asha', 'nair', '1997-06-30', 'asha.nair@gmail.com', '3210987654'),
('akhil', 'sharma', '1999-01-08', 'akhil.sharma@gmail.com', '2109876543'),
('jay', 'patel', '1996-12-12', 'jay.patel@gmail.com', '1098765432'),
('visali', 'joshi', '1998-04-04', 'visali.joshi@gmail.com', '9988776655');

-- Inserting into Teachers Table 
INSERT INTO info.teachers (first_name, last_name, email) 
VALUES 
('amit', 'sharma', 'amit.sharma@gmail.com'),
('neha', 'verma', 'neha.verma@gmail.com'),
('rajesh', 'gupta', 'rajesh.gupta@gmail.com'),
('priya', 'reddy', 'priya.reddy@gmail.com'),
('suresh', 'nair', 'suresh.nair@gmail.com'),
('pooja', 'iyer', 'pooja.iyer@gmail.com'),
('vikram', 'menon', 'vikram.menon@gmail.com'),
('meera', 'patil', 'meera.patil@gmail.com'),
('arjun', 'chopra', 'arjun.chopra@gmail.com'),
('kavita', 'das', 'kavita.das@gmail.com');

-- Inserting into Courses Table 
INSERT INTO info.courses (course_name, credits, teacher_id)
VALUES 
('computer science basics', 4, 1),
('mathematics for engineers', 3, 2),
('advanced java programming', 4, 3),
('physics fundamentals', 3, 4),
('artificial intelligence', 4, 5),
('data structures & algorithms', 3, 6),
('cyber security', 4, 7),
('big data analytics', 3, 8),
('cloud computing', 4, 9),
('machine learning', 4, 10);

-- Inserting into Enrollments Table
INSERT INTO info.enrollments (student_id, course_id, enrollment_date)
VALUES 
(1, 1, '2021-06-05'),
(2, 2, '2021-06-10'),
(3, 3, '2021-06-15'),
(4, 4, '2021-06-20'),
(5, 5, '2021-06-25'),
(6, 6, '2021-07-01'),
(7, 7, '2021-07-05'),
(8, 8, '2021-07-10'),
(9, 9, '2021-07-15'),
(10, 10, '2021-07-20');

-- Inserting into Payments Table
INSERT INTO info.payments (student_id, amount, payment_date)
VALUES 
(1, 125000.00, '2021-06-06'),
(2, 130500.00, '2021-06-11'),
(3, 145750.00, '2021-06-16'),
(4, 160000.00, '2021-06-21'),
(5, 175000.00, '2021-06-26'),
(6, 110250.00, '2021-07-02'),
(7, 140000.00, '2021-07-06'),
(8, 155000.00, '2021-07-11'),
(9, 167500.00, '2021-07-16'),
(10, 180000.00, '2021-07-21');

----------------------------Viewing All Tables----------------------------------
SELECT * FROM info.students;
SELECT * FROM info.teachers;
SELECT * FROM info.courses;
SELECT * FROM info.enrollments;
SELECT * FROM info.payments;