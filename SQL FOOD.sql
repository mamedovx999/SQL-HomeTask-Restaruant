CREATE DATABASE Restaruant
USE Restaruant
CREATE TABLE Food
(
ID INT PRIMARY KEY IDENTITY,
FoodName NVARCHAR(155) UNIQUE NOT NULL,
FoodPrice DECIMAL(5,2) NOT NULL
)
CREATE TABLE Tables
(
ID INT PRIMARY KEY IDENTITY
)
CREATE TABLE Orders
(
ID INT PRIMARY KEY IDENTITY,
TableID INT FOREIGN KEY REFERENCES Tables(ID),
FoodID INT FOREIGN KEY REFERENCES Food(ID),
OrderTime DATETIME,
OrderQuantity INT
)
INSERT INTO Food (FoodName,FoodPrice) VALUES
('Kabab',35.00),
('Pizza',12.00),
('	Sezar',9.00),
('Burger',15.00)

INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES

INSERT INTO Orders (TableID,FoodID,OrderTime,OrderQuantity) VALUES
(1,4,'2024-04-18 14:30:00',1),
(1,1,'2024-04-18 15:00:00',1),
(1,2,'2024-04-18 15:10:00',1),
(2,3,'2024-04-18 15:20:00',2),
(2,4,'2024-04-18 15:35:00',1)
-- Butun sifarislerin sayi
SELECT t.ID AS [Table Number], o.OrderQuantity
FROM Tables t
JOIN Orders o ON t.ID
--Butun yemekleri sifarish sayi gostermek
SELECT f.FoodName, o.OrderQuantity
FROM Food f
JOIN Orders o ON f.ID = o.FoodID
--Sifarish datalarinin yaninda yemeyin adini gosterir
SELECT o.*, f.FoodName
FROM Orders o
JOIN Food f ON o.FoodID = f.ID

SELECT t.*, SUM(f.FoodPrice * o.OrderQuantity) AS TotalOrderPrice
FROM Tables t
LEFT JOIN Orders o ON t.ID = o.TableID
LEFT JOIN Food f ON o.FoodID = f.ID
GROUP BY t.ID
--Ilk ve son sifarish arasindaki ferg 
SELECT DATEDIFF(MINUTE, MIN(OrderTime), MAX(OrderTime)) AS TimeDifferenceInMinutes
FROM Orders
WHERE TableID = 1

--30 deqiqe evvel verilmis sifarisin datalari
SELECT * FROM Orders
WHERE OrderTime>=DATEADD(MINUTE,-30,GETDATE())
--Sifaris olunmayan masalar
SELECT t.*,o.* FROM Tables t
LEFT JOIN Orders o on o.TableID=t.ID
WHERE o.TableID IS NULL
--Son 1 saat erzinde sifarish vermeyen masalar
SELECT t.*
FROM Tables t
LEFT JOIN (
    SELECT DISTINCT TableID
    FROM Orders
    WHERE OrderTime >= DATEADD(MINUTE, -60, GETDATE())
) o ON t.ID = o.TableID
WHERE o.TableID IS NULL;