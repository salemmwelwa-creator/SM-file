-- Create Database 
CREATE DATABASE IF NOT EXISTS PROJECT;
USE PROJECT;

SET FOREIGN_KEY_CHECKS = 0;
-- Create Tables 
CREATE TABLE DIM_CUSTOMER (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Industry VARCHAR(100),
	Segment VARCHAR(50),
    Region VARCHAR(50),
    FirstPurchaseDate DATE,
    TenureMonths INT,
    AqcuisitionChannel VARCHAR(50),
    IsActive BOOLEAN NOT NULL, -- what is this ansd why not boolean 
    ChurnedDate DATE NULL
);

CREATE TABLE FACT_OPPORTUNITY (
	OpportunityID INT PRIMARY KEY,
	CustomerID INT NOT NULL REFERENCES DIM_CUSTOMER (CustomerID),
	SalesRepID INT NOT NULL,
	SourceCampaignID INT NULL,
    CreatedDate  DATE NOT NULL,
    CloseDate DATE NULL,
    Stage  VARCHAR (50) NOT NULL,
    Amount DECIMAL (18,2) CHECK (Amount >= 0),
    IsWon BIT NOT NULL
) ;


CREATE TABLE FACT_ORDER (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL, 
    OrderDate DATE NOT NULL,
    Quantity INT ,
    UnitPrice DECIMAL(10,2),
    DiscountPct DECIMAL(10,2),
    NetAmount  DECIMAL(10,2),
	ContractTerm VARCHAR(20), 
    IsSubscription BOOLEAN NOT NULL ,
    FOREIGN KEY (CustomerID) REFERENCES DIM_CUSTOMER(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DIM_PRODUCTS(ProductID)
);

CREATE TABLE FACT_INTERACTION ( 
	InteractionID INT NOT NULL,
    CustomerID INT NOT NULL,
    InteractionDate DATE ,
    InteractionChannel VARCHAR (50) ,
    ActivityType VARCHAR(100),
    CampaignID INT NOT NULL,
    Outcome VARCHAR(50), 
    DurationMin INT NOT NULL,
    SentimentScore DECIMAL 
);
    
    
CREATE TABLE FACT_TICKET ( 
	TicketID INT NOT NULL ,
    CustomerID INT NOT NULL ,
    OpenDate DATE ,
    CloseDate DATE ,
    Category VARCHAR(50),
    SLA_Breached BOOLEAN ,
    CSAT  INT NOT NULL 
);
	
 -- had to drop tables becasue i could just mass upload tables    
DROP TABLE DIM_CUSTOMER;
DROP TABLE FACT_OPPORTUNITY;
DROP TABLE FACT_ORDER;
DROP TABLE FACT_INTERACTION;
DROP TABLE FACT_TICKET;

DROP TABLE DIM_SALESREP;
DROP TABLE DIM_PRODUCT;
DROP TABLE DIM_CAMPAIGN;

select * from DIM_CAMPAIGN;

-- Create derived tables from existing tables 
CREATE TABLE DIM_SALESREP AS
SELECT DISTINCT
  SalesRepID
FROM FACT_OPPORTUNITY;

CREATE TABLE DIM_PRODUCT AS
SELECT DISTINCT
  ProductID
FROM FACT_ORDER;

CREATE TABLE DIM_CAMPAIGN AS
SELECT DISTINCT
  CampaignID,
  Channel
FROM FACT_INTERACTION;

-- Create Indexes for easy querying 
CREATE INDEX IX_FACT_OPP_StageCreated ON FACT_OPPORTUNITY(Stage,
CreatedDate);
CREATE INDEX IX_FACT_OPP_Rep ON FACT_OPPORTUNITY(SalesRepID);
CREATE INDEX IX_FACT_OPP_Customer ON FACT_OPPORTUNITY(CustomerID);  


select * from DIM_CUSTOMER;

-- transforming data 
-- have to change date data types using alter table modify column query 
select * from DIM_CAMPAIGN;
select * from DIM_CUSTOMER;
describe FACT_INTERACTION;
describe FACT_TICKET;
ALTER TABLE FACT_INTERACTION
MODIFY COLUMN InteractionDate DATE;
ALTER TABLE FACT_ORDER
MODIFY COLUMN FirstPurchaseDate DATE;
-- ran into a problem with this because trying to convert '' to date, had to update places wwhere = '' to Null and then i could convert 
ALTER TABLE DIM_CUSTOMER 
MODIFY COLUMN ChurnedDate DATE ;
UPDATE DIM_CUSTOMER
SET ChurnedDate = NULL
WHERE ChurnedDate = '' OR ChurnedDate = ' ';
ALTER TABLE fact_opportunity
RENAME TO FACT_OPPORTUNITY;

SELECT CampaignID, COUNT(*) 
FROM DIM_CAMPAIGN 
GROUP BY CampaignID 
HAVING COUNT(*) > 1;

SELECT * FROM DIM_CAMPAIGN 
WHERE CampaignID = 46;

ALTER TABLE DIM_CAMPAIGN 
ADD COLUMN InteractionDate DATE;

-- add oprimary and foreign keys using the visual interface on the side bar 

-- added interaction table to campaign id to find out why the ids where duplicated 
UPDATE DIM_CAMPAIGN c
JOIN (
    -- Get the latest interaction date for every CampaignID
    SELECT CampaignID, MAX(InteractionDate) as LatestDate 
    FROM FACT_INTERACTION 
    GROUP BY CampaignID
) i ON c.CampaignID = i.CampaignID
SET c.InteractionDate = i.LatestDate;

-- make primary key for campaign 
ALTER TABLE DIM_CAMPAIGN 
MODIFY COLUMN Channel VARCHAR(50);
ALTER TABLE DIM_CAMPAIGN
ADD PRIMARY KEY (CampaignID, Channel);

-- add foreain kys 
ALTER TABLE FACT_OPPORTUNITY
ADD CONSTRAINT fk_opp_customer
FOREIGN KEY (CustomerID) REFERENCES DIM_CUSTOMER(CustomerID);


-- Link to Customers
ALTER TABLE FACT_INTERACTION
ADD CONSTRAINT fk_int_customer
FOREIGN KEY (CustomerID) REFERENCES DIM_CUSTOMER(CustomerID);


 -- Sales Rep and Opportunity
ALTER TABLE FACT_OPPORTUNITY
ADD CONSTRAINT fk_opportunity_salesrep
FOREIGN KEY (SalesRepID) REFERENCES DIM_SALES_REP(SalesRepID);
-- Opportunity and Campaign 
-- make the campaign id names consistent 
ALTER TABLE FACT_OPPORTUNITY 
RENAME COLUMN SourceCampaignID TO CampaignID;
-- 
ALTER TABLE FACT_OPPORTUNITY
ADD CONSTRAINT fk_opportunity_campaign
FOREIGN KEY (CampaignID) REFERENCES DIM_CAMPAIGN(CampaignID);
-- Customer and Ticket
ALTER TABLE FACT_TICKET
ADD CONSTRAINT fk_ticket_customer
FOREIGN KEY (CustomerID) REFERENCES DIM_CUSTOMER(CustomerID);
-- Customer and Order
ALTER TABLE FACT_ORDER
ADD CONSTRAINT fk_order_customer
FOREIGN KEY (CustomerID) REFERENCES DIM_CUSTOMER(CustomerID);
--  Order  to the Product:
ALTER TABLE FACT_ORDER
ADD CONSTRAINT fk_items_product
FOREIGN KEY (ProductID) REFERENCES DIM_PRODUCT(ProductID);








