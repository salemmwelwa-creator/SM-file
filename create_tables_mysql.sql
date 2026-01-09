
CREATE DATABASE IF NOT EXISTS PVF;
USE PVF;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Uses_T;
DROP TABLE IF EXISTS WorksIn_T;
DROP TABLE IF EXISTS WorkCenter_T;
DROP TABLE IF EXISTS DoesBusinessIn_T;
DROP TABLE IF EXISTS EmployeeSkills_T;
DROP TABLE IF EXISTS Supplies_T;
DROP TABLE IF EXISTS ProducedIn_T;
DROP TABLE IF EXISTS OrderLine_T;
DROP TABLE IF EXISTS Product_T;
DROP TABLE IF EXISTS ProductLine_T;
DROP TABLE IF EXISTS Order_T;
DROP TABLE IF EXISTS Salesperson_T;
DROP TABLE IF EXISTS Vendor_T;
DROP TABLE IF EXISTS Skill_T;
DROP TABLE IF EXISTS RawMaterial_T;
DROP TABLE IF EXISTS Territory_T;
DROP TABLE IF EXISTS Employee_T;
DROP TABLE IF EXISTS Customer_T;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Customer_T (
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(25) NOT NULL,
    CustomerAddress VARCHAR(30),
    CustomerCity VARCHAR(20),
    CustomerState CHAR(2),
    CustomerPostalCode VARCHAR(10),
    PRIMARY KEY (CustomerID)
);

CREATE TABLE Territory_T (
    TerritoryID INT NOT NULL,
    TerritoryName VARCHAR(50),
    PRIMARY KEY (TerritoryID)
);

CREATE TABLE DoesBusinessIn_T (
    CustomerID INT NOT NULL,
    TerritoryID INT NOT NULL,
    PRIMARY KEY (CustomerID, TerritoryID),
    FOREIGN KEY (CustomerID) REFERENCES Customer_T(CustomerID),
    FOREIGN KEY (TerritoryID) REFERENCES Territory_T(TerritoryID)
);

CREATE TABLE Employee_T (
    EmployeeID VARCHAR(10) NOT NULL,
    EmployeeName VARCHAR(25),
    EmployeeAddress VARCHAR(30),
    EmployeeCity VARCHAR(20),
    EmployeeState CHAR(2),
    EmployeeZipCode VARCHAR(10),
    EmployeeDateHired DATE,
    EmployeeBirthDate DATE,
    EmployeeSupervisor VARCHAR(10),
    PRIMARY KEY (EmployeeID)
);

CREATE TABLE Skill_T (
    SkillID VARCHAR(12) NOT NULL,
    SkillDescription VARCHAR(30),
    PRIMARY KEY (SkillID)
);

CREATE TABLE EmployeeSkills_T (
    EmployeeID VARCHAR(10) NOT NULL,
    SkillID VARCHAR(12) NOT NULL,
    PRIMARY KEY (EmployeeID, SkillID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skill_T(SkillID)
);

CREATE TABLE Order_T (
    OrderID INT NOT NULL,
    CustomerID INT,
    OrderDate DATE,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customer_T(CustomerID)
);

CREATE TABLE WorkCenter_T (
    WorkCenterID VARCHAR(12) NOT NULL,
    WorkCenterLocation VARCHAR(30),
    PRIMARY KEY (WorkCenterID)
);

CREATE TABLE ProductLine_T (
    ProductLineID INT NOT NULL,
    ProductLineName VARCHAR(50),
    PRIMARY KEY (ProductLineID)
);

CREATE TABLE Product_T (
    ProductID INT NOT NULL,
    ProductLineID INT,
    ProductDescription VARCHAR(50),
    ProductFinish VARCHAR(20),
    ProductStandardPrice DECIMAL(10,2),
    PRIMARY KEY (ProductID),
    FOREIGN KEY (ProductLineID) REFERENCES ProductLine_T(ProductLineID)
);

CREATE TABLE ProducedIn_T (
    ProductID INT NOT NULL,
    WorkCenterID VARCHAR(12) NOT NULL,
    PRIMARY KEY (ProductID, WorkCenterID),
    FOREIGN KEY (ProductID) REFERENCES Product_T(ProductID),
    FOREIGN KEY (WorkCenterID) REFERENCES WorkCenter_T(WorkCenterID)
);

CREATE TABLE OrderLine_T (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderedQuantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Order_T(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product_T(ProductID)
);

CREATE TABLE RawMaterial_T (
    MaterialID VARCHAR(12) NOT NULL,
    MaterialName VARCHAR(30),
    MaterialStandardCost DECIMAL(10,2),
    UnitOfMeasure VARCHAR(10),
    PRIMARY KEY (MaterialID)
);

CREATE TABLE Salesperson_T (
    SalespersonID INT NOT NULL,
    SalespersonName VARCHAR(25),
    SalespersonPhone VARCHAR(50),
    SalespersonFax VARCHAR(50),
    TerritoryID INT,
    PRIMARY KEY (SalespersonID),
    FOREIGN KEY (TerritoryID) REFERENCES Territory_T(TerritoryID)
);

CREATE TABLE Vendor_T (
    VendorID INT NOT NULL,
    VendorName VARCHAR(25),
    VendorAddress VARCHAR(30),
    VendorCity VARCHAR(20),
    VendorState CHAR(2),
    VendorZipcode VARCHAR(50),
    VendorFax VARCHAR(10),
    VendorPhone VARCHAR(10),
    VendorContact VARCHAR(50),
    VendorTaxID VARCHAR(50),
    PRIMARY KEY (VendorID)
);

CREATE TABLE Supplies_T (
    VendorID INT NOT NULL,
    MaterialID VARCHAR(12) NOT NULL,
    SuppliesUnitPrice DECIMAL(10,2),
    PRIMARY KEY (VendorID, MaterialID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterial_T(MaterialID),
    FOREIGN KEY (VendorID) REFERENCES Vendor_T(VendorID)
);

CREATE TABLE Uses_T (
    ProductID INT NOT NULL,
    MaterialID VARCHAR(12) NOT NULL,
    GoesIntoQuantity INT,
    PRIMARY KEY (ProductID, MaterialID),
    FOREIGN KEY (ProductID) REFERENCES Product_T(ProductID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterial_T(MaterialID)
);

CREATE TABLE WorksIn_T (
    EmployeeID VARCHAR(10) NOT NULL,
    WorkCenterID VARCHAR(12) NOT NULL,
    PRIMARY KEY (EmployeeID, WorkCenterID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID),
    FOREIGN KEY (WorkCenterID) REFERENCES WorkCenter_T(WorkCenterID)
);



USE PVF;

INSERT INTO Customer_T VALUES
(1,'Contemporary Casuals','1355 S Hines Blvd','Gainesville','FL','32601-2871'),
(2,'Value Furniture','15145 S.W. 17th St.','Plano','TX','75094-7743'),
(3,'Home Furnishings','1900 Allard Ave.','Albany','NY','12209-1125'),
(4,'Eastern Furniture','1925 Beltline Rd.','Carteret','NJ','07008-3188'),
(5,'Impressions','5585 Westcott Ct.','Sacramento','CA','94206-4056'),
(6,'Furniture Gallery','325 Flatiron Dr.','Boulder','CO','80514-4432'),
(7,'Period Furniture','394 Rainbow Dr.','Seattle','WA','97954-5589'),
(8,'California Classics','816 Peach Rd.','Santa Clara','CA','96915-7754'),
(9,'M and H Casual Furniture','3709 First Street','Clearwater','FL','34620-2314'),
(10,'Seminole Interiors','2400 Rocky Point Dr.','Seminole','FL','34646-4423'),
(11,'American Euro Lifestyles','2424 Missouri Ave N.','Prospect Park','NJ','07508-5621'),
(12,'Battle Creek Furniture','345 Capitol Ave. SW','Battle Creek','MI','49015-3401'),
(13,'Heritage Furnishings','66789 College Ave.','Carlisle','PA','17013-8834'),
(14,'Kaneohe Homes','112 Kiowai St.','Kaneohe','HI','96744-2537'),
(15,'Mountain Scenes','4132 Main Street','Ogden','UT','84403-4432');

INSERT INTO Territory_T VALUES
(1,'SouthEast'),
(2,'SouthWest'),
(3,'NorthEast'),
(4,'NorthWest'),
(5,'Central');

INSERT INTO DoesBusinessIn_T VALUES
(1,1),(1,2),(2,2),(3,3),(4,3),(5,2),(6,5);

INSERT INTO Employee_T VALUES
('123-44-345','Jim Jason','2134 Hilltop Rd',NULL,'TN',NULL,'1999-06-12',NULL,'454-56-768'),
('454-56-768','Robert Lewis','17834 Deerfield Ln','Nashville','TN',NULL,'1999-01-01',NULL,'');

INSERT INTO Skill_T VALUES
('BS12','12in Band Saw'),
('QC1','Quality Control'),
('RT1','Router'),
('SO1','Sander-Orbital'),
('SB1','Sander-Belt'),
('TS10','10in Table Saw'),
('TS12','12in Table Saw'),
('UC1','Upholstery Cutter'),
('US1','Upholstery Sewer'),
('UT1','Upholstery Tacker');

INSERT INTO EmployeeSkills_T VALUES
('123-44-345','BS12'),
('123-44-345','RT1'),
('454-56-768','BS12');

INSERT INTO Order_T
 (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2017-10-21'),
(1002, 8, '2017-11-22'),
(1003, 15, '2017-11-23'),
(1004, 5, '2017-11-20'),
(1005, 3, '2017-11-26'),
(1006, 2, '2017-11-24'),
(1007, 11, '2017-11-27'),
(1008, 12, '2017-10-30'),
(1009, 4, '2017-11-25'),
(1010, 1, '2017-11-25');


INSERT INTO ProductLine_T VALUES
(1,'Cherry Tree'),
(2,'Scandinavia'),
(3,'Country Look');

INSERT INTO Product_T 
(ProductID, ProductLineID, ProductDescription, ProductFinish, ProductStandardPrice) VALUES
(1, 1, 'End Table', 'Cherry', 175),
(2, 2, 'Coffee Table', 'Natural Ash', 200),
(3, 2, 'Computer Desk', 'Natural Ash', 375),
(4, 3, 'Entertainment Center', 'Natural Maple', 650),
(5, 1, 'Writers Desk', 'Cherry', 325),
(6, 2, '8-Drawer Desk', 'White Ash', 750),
(7, 2, 'Dining Table', 'Natural Ash', 800),
(8, 3, 'Computer Desk', 'Walnut', 250);


INSERT INTO OrderLine_T VALUES
(1001,1,2),(1001,2,2),(1001,4,1),
(1002,3,5),(1003,3,3),
(1004,6,2),(1004,8,2),
(1005,4,3),(1006,4,1),(1006,5,2),(1006,7,2),
(1007,1,3),(1007,2,2),
(1008,3,3),(1008,8,3),
(1009,4,2),(1009,7,3),
(1010,8,10);

INSERT INTO Salesperson_T VALUES
(1,'Doug Henny','8134445555',NULL,1),
(2,'Robert Lewis','8139264006',NULL,2),
(3,'William Strong','5053821212',NULL,3),
(4,'Julie Dawson','4355346677',NULL,4),
(5,'Jacob Winslow','2238973498',NULL,5);

INSERT INTO WorkCenter_T VALUES
('SM1','Main Saw Mill'),
('WR1','Warehouse and Receiving');

INSERT INTO WorksIn_T VALUES
('123-44-345','SM1');

describe Uses_T;
describe WorksIn_T;
describe WorkCenter_T;
describe DoesBusinessIn_T;
describe EmployeeSkills_T;
describe Supplies_T;
describe ProducedIn_T;
describe OrderLine_T;
describe Product_T;
describe ProductLine_T;
describe Order_T;
describe Salesperson_T;
describe Vendor_T;
describe Skill_T;
describe RawMaterial_T;
describe Territory_T;
describe Employee_T;
describe Customer_T;

select * from Uses_T;
select * from WorksIn_T;
select * from WorkCenter_T;
select * from DoesBusinessIn_T;
select * from EmployeeSkills_T;
select * from Supplies_T;
select * from ProducedIn_T;
select * from OrderLine_T;
select * from Product_T; 
select * from ProductLine_T;
select * from Order_T;
select * from Salesperson_T;
select * from Vendor_T;
select * from Skill_T;
select * from RawMaterial_T;
select * from Territory_T;
select * from Employee_T;
select * from Customer_T;


#Tasks


-- Part A: Basic Queries
-- 1. List all customers who placed orders during Black Friday week (Nov 20-Nov 27, 2017).

SELECT 
Customer_T.CustomerID, 
Customer_T.CustomerName, 
Order_T.OrderDate 
FROM Customer_T
JOIN Order_T
ON Order_T.CustomerID = Customer_T.CustomerID
WHERE Order_T.OrderDate BETWEEN '2017-11-20' AND '2017-11-27'
ORDER BY Customer_T.CustomerID ASC; 

-- 2. Retrieve the top 5 products by total revenue during Black Friday week.

SELECT
Product_T.ProductID,
Product_T.ProductDescription, 
Product_T.ProductFinish,
SUM(OrderLine_T.OrderedQuantity * Product_T.ProductStandardPrice) AS Revenue 
FROM Product_T 
JOIN OrderLine_T 
ON Product_T.ProductID = OrderLine_T.ProductID
JOIN Order_T 
ON Order_T.OrderID = OrderLine_T.OrderID
WHERE Order_T.OrderDate BETWEEN '2017-11-20' AND '2017-11-27'
GROUP BY Product_T.ProductID 
ORDER BY Revenue DESC
LIMIT 5;



-- Part B: Subqueries
-- 3. Find customers who spent more than the average order amount during Black Friday week.

-- order totals 

SELECT 
O.OrderID,
SUM(OL.OrderedQuantity * P.ProductStandardPrice) AS OrderTotal 
FROM Order_T O 
JOIN OrderLine_T OL 
ON O.OrderID = OL.OrderID
JOIN Product_T P
ON P.ProductID = OL.ProductID
WHERE O.OrderDate BETWEEN '2017-11-20' AND '2017-11-27' 
GROUP BY O.OrderID; 

-- above avg subquery 

SELECT AVG(OrderTotal) AS AverageOrders
FROM ( 
SELECT 
O.OrderID,
SUM(OL.OrderedQuantity * P.ProductStandardPrice) AS OrderTotal 
FROM Order_T O 
JOIN OrderLine_T OL 
ON O.OrderID = OL.OrderID
JOIN Product_T P
ON P.ProductID = OL.ProductID
WHERE O.OrderDate BETWEEN '2017-11-20' AND '2017-11-27' 
GROUP BY O.OrderID
) AS BlackFridayOrders; 

-- cusotmer info subquery 

SELECT 
C.CustomerID ,
C.CustomerName,
SUM(OL.OrderedQuantity * P.ProductStandardPrice) AS CustomerTotal 
FROM Customer_T C 
JOIN Order_T O
ON C.CustomerID = O.CustomerID 
JOIN OrderLine_T OL 
ON O.OrderID = OL.OrderID
JOIN Product_T P 
ON P.ProductID = OL.ProductID 
WHERE O.OrderDate BETWEEN '2017-11-20' AND '2017-11-27' 
GROUP BY C.CustomerID, C.CustomerName 
HAVING CustomerTotal > 
( 
SELECT AVG(OrderTotal) AS AverageOrders
FROM ( 
SELECT 
O.OrderID,
SUM(OL.OrderedQuantity * P.ProductStandardPrice) AS OrderTotal 
FROM Order_T O 
JOIN OrderLine_T OL 
ON O.OrderID = OL.OrderID
JOIN Product_T P
ON P.ProductID = OL.ProductID
WHERE O.OrderDate BETWEEN '2017-11-20' AND '2017-11-27' 
GROUP BY O.OrderID
) AS BlackFridayOrders 
) 
ORDER BY CustomerTotal DESC; 


-- 4. Identify suppliers who provide products in the top-selling category during Black Friday.


SELECT 

-- Part C: Indexing

-- 5. Create an index on the Order table for order_date and customer_id to optimize queries filtering by date andcustomer. Explain why this index improves performance.
-- 6. Use EXPLAIN (or similar) to compare query execution plans before and after indexing.

-- Part D: Views
-- 7. Create a view named BlackFridaySales that shows customer_name, product_name, quantity, and total_price for all Black Friday orders.
-- 8. Using the view, write a query to find customers who purchased more than 5 items in total during Black Friday week.
-- Part E: Analysis
-- 9. Discuss how indexes can help prevent downtime during high-traffic events like Black Friday.
-- 10. Explain the role of views in improving security and simplifying reporting for seasonal sales.