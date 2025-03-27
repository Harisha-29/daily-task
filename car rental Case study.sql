-- Create Database
CREATE DATABASE CarRentalDB;
GO

-- Use the Database
USE CarRentalDB;
GO

-- Create Vehicle Table
CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY IDENTITY(1,1),
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    dailyRate DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('available', 'notAvailable')) NOT NULL,
    passengerCapacity INT NOT NULL,
    engineCapacity DECIMAL(5,2) NOT NULL
);

-- Create Customer Table
CREATE TABLE Customer (
    customerID INT PRIMARY KEY IDENTITY(1,1),
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phoneNumber VARCHAR(15) UNIQUE NOT NULL
);

-- Create Lease Table
CREATE TABLE Lease (
    leaseID INT PRIMARY KEY IDENTITY(1,1),
    vehicleID INT FOREIGN KEY REFERENCES Vehicle(vehicleID) ON DELETE CASCADE,
    customerID INT FOREIGN KEY REFERENCES Customer(customerID) ON DELETE CASCADE,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    type VARCHAR(20) CHECK (type IN ('DailyLease', 'MonthlyLease')) NOT NULL
);

-- Create Payment Table
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY IDENTITY(1,1),
    leaseID INT FOREIGN KEY REFERENCES Lease(leaseID) ON DELETE CASCADE,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

-- Insert Sample Data into Vehicle Table
INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity) 
VALUES
('Toyota', 'Corolla', 2020, 50.00, 'available', 5, 1.8),
('Honda', 'Civic', 2019, 55.00, 'available', 5, 2.0),
('Ford', 'Mustang', 2021, 100.00, 'notAvailable', 4, 5.0),
('Chevrolet', 'Malibu', 2018, 45.00, 'available', 5, 1.5),
('Nissan', 'Altima', 2022, 60.00, 'available', 5, 2.5),
('BMW', 'X5', 2021, 150.00, 'notAvailable', 5, 3.0),
('Mercedes', 'C-Class', 2020, 120.00, 'available', 5, 2.0),
('Audi', 'A4', 2019, 110.00, 'available', 5, 2.0),
('Tesla', 'Model 3', 2023, 130.00, 'available', 5, 0.0),
('Jeep', 'Wrangler', 2021, 80.00, 'notAvailable', 4, 3.6);

-- Insert Sample Data into Customer Table
INSERT INTO Customer (firstName, lastName, email, phoneNumber) 
VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321'),
('Mike', 'Johnson', 'mike.johnson@example.com', '1122334455'),
('Sarah', 'Williams', 'sarah.williams@example.com', '2233445566'),
('David', 'Brown', 'david.brown@example.com', '3344556677'),
('Emily', 'Davis', 'emily.davis@example.com', '4455667788'),
('Robert', 'Miller', 'robert.miller@example.com', '5566778899'),
('Linda', 'Wilson', 'linda.wilson@example.com', '6677889900'),
('James', 'Anderson', 'james.anderson@example.com', '7788990011'),
('Patricia', 'Taylor', 'patricia.taylor@example.com', '8899001122');

-- Insert Sample Data into Lease Table
INSERT INTO Lease (vehicleID, customerID, startDate, endDate, type) 
VALUES
(1, 1, '2025-03-01', '2025-03-10', 'DailyLease'),
(2, 2, '2025-03-05', '2025-04-05', 'MonthlyLease'),
(3, 3, '2025-03-07', '2025-03-17', 'DailyLease'),
(4, 4, '2025-03-10', '2025-04-10', 'MonthlyLease'),
(5, 5, '2025-03-15', '2025-03-25', 'DailyLease'),
(6, 6, '2025-03-18', '2025-04-18', 'MonthlyLease'),
(7, 7, '2025-03-20', '2025-03-30', 'DailyLease'),
(8, 8, '2025-03-22', '2025-04-22', 'MonthlyLease'),
(9, 9, '2025-03-25', '2025-04-25', 'MonthlyLease'),
(10, 10, '2025-03-28', '2025-04-28', 'MonthlyLease');

-- Insert Sample Data into Payment Table
INSERT INTO Payment (leaseID, paymentDate, amount) 
VALUES
(1, '2025-03-02', 500.00),
(2, '2025-03-06', 1500.00),
(3, '2025-03-08', 600.00),
(4, '2025-03-12', 1600.00),
(5, '2025-03-16', 700.00),
(6, '2025-03-20', 1700.00),
(7, '2025-03-22', 800.00),
(8, '2025-03-26', 1800.00),
(9, '2025-03-30', 1900.00),
(10, '2025-04-02', 2000.00);