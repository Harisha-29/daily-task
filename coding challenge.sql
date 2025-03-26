CREATE DATABASE PetPals;
GO

USE PetPals;
GO

-- Step 2: Create Tables
CREATE TABLE Pets (
    PetID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Breed VARCHAR(50) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    AvailableForAdoption BIT NOT NULL
);
CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL
);
CREATE TABLE Donations (
    DonationID INT PRIMARY KEY IDENTITY(1,1),
    DonorName VARCHAR(100) NOT NULL,
    DonationType VARCHAR(50) NOT NULL,
    DonationAmount DECIMAL(10,2),
    DonationItem VARCHAR(100),
    DonationDate DATETIME NOT NULL
);
CREATE TABLE AdoptionEvents (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    EventName VARCHAR(100) NOT NULL,
    EventDate DATETIME NOT NULL,
    Location VARCHAR(255) NOT NULL
);
CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY IDENTITY(1,1),
    ParticipantName VARCHAR(100) NOT NULL,
    ParticipantType VARCHAR(50) NOT NULL,
    EventID INT,
    FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID)
);
CREATE TABLE Adoptions (
    AdoptionID INT PRIMARY KEY IDENTITY(1,1),
    PetID INT UNIQUE,  -- Ensures each pet can only be adopted once
    AdopterName VARCHAR(100),
    AdoptionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PetID) REFERENCES Pets(PetID)
);

-- Step 3: Insert Sample Data
INSERT INTO Adoptions (PetID, AdopterName, AdoptionDate) VALUES 
(1, 'John Doe', '2024-03-20'),
(2, 'Jane Smith', '2024-03-21'),
(4, 'Emily Brown', '2024-03-22');


INSERT INTO Shelters (Name, Location) VALUES 
('Happy Paws Shelter', 'New York'),
('Safe Haven Shelter', 'Los Angeles'),
('Furry Friends Home', 'Chicago');

INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption) VALUES 
('Bella', 2, 'Labrador', 'Dog', 1),
('Max', 4, 'Beagle', 'Dog', 1),
('Luna', 1, 'Persian', 'Cat', 1),
('Rocky', 3, 'Bulldog', 'Dog', 0),
('Milo', 6, 'Siamese', 'Cat', 1);

INSERT INTO Donations (DonorName, DonationType, DonationAmount, DonationItem, DonationDate) VALUES 
('John Doe', 'Cash', 100.00, NULL, '2025-03-01'),
('Jane Smith', 'Item', NULL, 'Pet Food', '2025-03-05'),
('Mike Johnson', 'Cash', 50.00, NULL, '2025-03-10');

INSERT INTO AdoptionEvents (EventName, EventDate, Location) VALUES 
('Spring Adoption Fair', '2025-04-10', 'New York'),
('Summer Adoption Festival', '2025-06-15', 'Los Angeles');

INSERT INTO Participants (ParticipantName, ParticipantType, EventID) VALUES 
('Happy Paws Shelter', 'Shelter', 1),
('Safe Haven Shelter', 'Shelter', 2),
('Emily Brown', 'Adopter', 1);

----------------------------5-------------------------------
SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 1;

---------------------------6---------------------------------
SELECT ParticipantName, ParticipantType 
FROM Participants 
WHERE EventID = 1;

----------------------------7-------------------------------
DROP PROCEDURE IF EXISTS UpdateShelterInfo;

CREATE PROCEDURE UpdateShelterInfo  
    @ShelterID INT,  
    @NewName VARCHAR(100),  
    @NewLocation VARCHAR(255)  
AS  
BEGIN  
    UPDATE Shelters  
    SET Name = @NewName, Location = @NewLocation  
    WHERE ShelterID = @ShelterID;  
END; 

----------------------------8--------------------------------------
-- 4. Total donation amount per shelter
SELECT s.Name AS ShelterName, COALESCE(SUM(d.DonationAmount), 0) AS TotalDonations
FROM Shelters s
LEFT JOIN Donations d ON s.ShelterID = d.DonationID
GROUP BY s.Name;

--------------------------9-----------------------------------
SELECT Name, Age, Breed, Type  
FROM Pets  
WHERE PetID NOT IN (SELECT PetID FROM Adoptions);

--------------------------10----------------------------------

SELECT 
    FORMAT(DonationDate, 'MMMM yyyy') AS MonthYear,
    SUM(DonationAmount) AS TotalDonations
FROM Donations
GROUP BY FORMAT(DonationDate, 'MMMM yyyy')
ORDER BY MIN(DonationDate);
----------------------------11------------------------------

SELECT DISTINCT Breed 
FROM Pets 
WHERE (Age BETWEEN 1 AND 3) OR (Age > 5);

---------------------------12-------------------------------
ALTER TABLE Pets ADD ShelterID INT;
ALTER TABLE Pets ADD CONSTRAINT FK_Pets_Shelters FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID);

SELECT p.Name AS PetName, p.Age, p.Breed, p.Type, s.Name AS ShelterName
FROM Pets p
JOIN Shelters s ON p.ShelterID = s.ShelterID
WHERE p.AvailableForAdoption = 1;

--------------------------13---------------------------------
SELECT COUNT(pa.ParticipantID) AS TotalParticipants
FROM Participants pa
JOIN AdoptionEvents ae ON pa.EventID = ae.EventID
JOIN Shelters s ON ae.Location = s.Location
WHERE s.Location = 'Chennai';

---------------------------14------------------------------

SELECT DISTINCT Breed 
FROM Pets 
WHERE Age BETWEEN 1 AND 5;

----------------------------15----------------------------
SELECT p.PetID, p.Name, p.Age, p.Breed, p.Type
FROM Pets p
LEFT JOIN Adoptions a ON p.PetID = a.PetID
WHERE a.PetID IS NULL;

------------------------------16------------------------------

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1), 
    Name VARCHAR(100) NOT NULL, 
    Email VARCHAR(100) UNIQUE NOT NULL, 
    Phone VARCHAR(15), 
    Address VARCHAR(255)
);
INSERT INTO Users (Name, Email, Phone, Address) VALUES
('John Doe', 'john.doe@email.com', '9876543210', '123 Main St, New York'),
('Jane Smith', 'jane.smith@email.com', '8765432109', '456 Elm St, California'),
('Alice Johnson', 'alice.j@email.com', '7654321098', '789 Oak St, Texas'),
('Bob Brown', 'bob.b@email.com', '6543210987', '101 Pine St, Florida');


SELECT p.Name AS PetName, u.Name AS AdopterName
FROM Adoptions a
JOIN Pets p ON a.PetID = p.PetID
JOIN Users u ON a.AdoptionID = u.UserID;
---------------------------------17--------------------------------
SELECT s.Name AS ShelterName, 
       COUNT(p.PetID) AS AvailablePetsCount
FROM Shelters s
LEFT JOIN Pets p ON s.ShelterID = p.ShelterID AND p.AvailableForAdoption = 1
GROUP BY s.Name;

----------------------------18---------------------------------
SELECT p1.PetID AS Pet1_ID, p1.Name AS Pet1_Name, 
       p2.PetID AS Pet2_ID, p2.Name AS Pet2_Name, 
       p1.Breed, p1.ShelterID
FROM Pets p1
JOIN Pets p2 
    ON p1.ShelterID = p2.ShelterID  -- Same Shelter
    AND p1.Breed = p2.Breed          -- Same Breed
    AND p1.PetID < p2.PetID;         -- Avoid duplicate pairs (A, B) & (B, A)

-------------------------19---------------------------------------

SELECT s.Name AS ShelterName, e.EventName AS AdoptionEvent
FROM Shelters s
CROSS JOIN AdoptionEvents e;

-----------------------------------20-----------------------------
SELECT TOP 1 s.Name AS ShelterName, COUNT(a.PetID) AS AdoptedPetsCount
FROM Shelters s
JOIN Pets p ON s.ShelterID = p.ShelterID
JOIN Adoptions a ON p.PetID = a.PetID
GROUP BY s.Name
ORDER BY AdoptedPetsCount DESC;














