
USE ecomm;
select count(*) from customer_churn;

-- Data Cleaning: 

SELECT 
 avg(WarehouseToHome) 						AS  WarehouseToHome
,round(avg(WarehouseToHome))				AS  rounded_WarehouseToHome
,avg(HourSpendOnApp) 						AS  HourSpendOnApp
,round(avg(HourSpendOnApp))					AS  rounded_HourSpendOnApp
,avg(OrderAmountHikeFromlastYear) 			AS  OrderAmountHikeFromlastYear
,round(avg(OrderAmountHikeFromlastYear))	AS  rounded_OrderAmountHikeFromlastYear
,avg(DaySinceLastOrder) 					AS  DaySinceLastOrder
,round(avg(DaySinceLastOrder))				AS  rounded_DaySinceLastOrder
 FROM customer_churn;
 
 
 -- Mode of Tenure
SELECT Tenure, COUNT(*) AS frequency
FROM customer_churn
WHERE Tenure IS NOT NULL
GROUP BY Tenure
ORDER BY frequency DESC
LIMIT 1;

-- Mode of CouponUsed
SELECT CouponUsed, COUNT(*) AS frequency
FROM customer_churn
WHERE CouponUsed IS NOT NULL
GROUP BY CouponUsed
ORDER BY frequency DESC
LIMIT 1;
  
-- Mode of OrderCount
SELECT OrderCount, COUNT(*) AS frequency
FROM customer_churn
WHERE OrderCount IS NOT NULL
GROUP BY OrderCount
ORDER BY frequency DESC
LIMIT 1;

DELETE FROM customer_churn WHERE WarehouseToHome>100;

UPDATE customer_churn SET PreferredLoginDevice='Mobile Phone' WHERE PreferredLoginDevice='Phone';
UPDATE customer_churn SET PreferedOrderCat='Mobile Phone' WHERE PreferedOrderCat='Mobile';

UPDATE customer_churn SET PreferredPaymentMode='Cash on Delivery'   WHERE PreferredPaymentMode='COD' ;
UPDATE customer_churn SET PreferredPaymentMode='Credit Card'   		WHERE PreferredPaymentMode='CC'  ;

-- Data Transformation: 

-- Column Renaming:
ALTER TABLE customer_churn RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;
ALTER TABLE customer_churn RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

-- Creating New Columns:
ALTER TABLE customer_churn ADD COLUMN ComplaintReceived varchar(3);

UPDATE customer_churn SET customer_churn=if(Complain=1,'YES','NO');

ALTER TABLE customer_churn ADD COLUMN ChurnStatus varchar(10);

UPDATE customer_churn SET ChurnStatus=if(Churn=1,'Churned','Active');

-- Column Dropping:
ALTER TABLE  customer_churn DROP COLUMN Churn;
ALTER TABLE  customer_churn DROP COLUMN Complain;

-- Data Exploration and Analysis: 

SELECT * FROM customer_churn;
-- retrieve the count of churned and active customers from the dataset.
SELECT COUNT(*) AS churned_customers FROM customer_churn WHERE Churn=1  ;
SELECT COUNT(*) AS Active_customers FROM customer_churn WHERE Churn=0 ;

--  Display the average tenure and total cashback amount of customers who churned. 
SELECT AVG(Tenure) AS Average_Tenure,SUM(CashbackAmount) AS Total_Cashback  FROM customer_churn WHERE Churn=1 ;

-- Determine the percentage of churned customers who complained.
SELECT 
    SUM(Complain) * 100.0 / COUNT(*) AS Percentage_Churned_Complained
FROM customer_churn
WHERE Churn = 1;

-- Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory. 

SELECT 
    CityTier,
    COUNT(*) AS count
FROM customer_churn
WHERE PreferredOrderCat = 'Laptop & Accessory'
  AND Churn = 1
GROUP BY CityTier
ORDER BY count DESC
LIMIT 1;

-- Identify the most preferred payment mode among active customers.
SELECT PreferredPaymentMode,COUNT(*) AS frequency FROM customer_churn WHERE Churn=0
GROUP BY PreferredPaymentMode
ORDER BY frequency DESC
LIMIT 1;
-- Calculate the total order amount hike from last year for customers who are single and prefer mobile phones for ordering.


SELECT SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountHike
FROM customer_churn WHERE MaritalStatus='Single' AND PreferredOrderCat='Mobile';
-- Find the average number of devices registered among customers who used UPI as their preferred payment mode.
SELECT AVG(NumberOfDeviceRegistered) AS AvgDevicesRegistered FROM customer_churn where PreferredPaymentMode='UPI';
-- Determine the city tier with the highest number of customers.


SELECT CityTier, COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;
--  Identify the gender that utilized the highest number of coupons.
SELECT Gender, COUNT(*) AS Frequency
FROM customer_churn
GROUP BY Gender
ORDER BY Frequency DESC
LIMIT 1;
-- List the number of customers and the maximum hours spent on the app in each preferred order category.
SELECT PreferredOrderCat,
       COUNT(*) AS CustomerCount,
       MAX(HoursSpentOnApp) AS MaxHoursSpent
FROM customer_churn
GROUP BY PreferredOrderCat;

--  Calculate the total order count for customers who prefer using credit cards and have the maximum satisfaction score.

SELECT SUM(OrderCount) AS TotalOrderCount
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (
      SELECT MAX(SatisfactionScore)
      FROM customer_churn
      WHERE PreferredPaymentMode = 'Credit Card'
  );
  -- What is the average satisfaction score of customers who have complained? 
SELECT AVG(SatisfactionScore) AS AvgSatisfactionScore
FROM customer_churn
WHERE Complain = 1;
--  List the preferred order category among customers who used more than 5 coupons. 
SELECT PreferredOrderCat, COUNT(*) AS CustomerCount
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat;

-- List the top 3 preferred order categories with the highest average cashback amount.

SELECT PreferredOrderCat,
       AVG(CashbackAmount) AS AvgCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AvgCashback DESC
LIMIT 3;
-- Find the preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders. 

SELECT PreferredPaymentMode,
       AVG(Tenure) AS AvgTenure,
       SUM(OrderCount) AS TotalOrders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10
   AND SUM(OrderCount) > 500;
   
-- Categorize customers based on their distance from the warehouse to home such 
-- as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km, 
-- 'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the 
-- churn status breakdown for each distance category. 

SELECT
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    Churn,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END,
    Churn
ORDER BY
    CASE
        WHEN WarehouseToHome <= 5 THEN 1
        WHEN WarehouseToHome <= 10 THEN 2
        WHEN WarehouseToHome <= 15 THEN 3
        ELSE 4
    END,
    Churn;
-- List the customer’s order details who are married, live in City Tier-1, and their 
-- order counts are more than the average number of orders placed by all 
-- customers.
SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (
      SELECT AVG(OrderCount)
      FROM customer_churn
  );
  -- Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the 
-- following data: 

USE ecomm;

CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount DECIMAL(10,2)
);

INSERT INTO customer_returns
    (ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES
    (1001, 50022, '2023-01-01', 2130),
    (1002, 50316, '2023-01-23', 2000),
    (1003, 51099, '2023-02-14', 2290),
    (1004, 52321, '2023-03-08', 2510),
    (1005, 52928, '2023-03-20', 1740),
    (1006, 53749, '2023-04-17', 3000),
    (1007, 54206, '2023-04-21', 3250),
    (1008, 54838, '2023-04-30', 1990);
    
--  Display the return details along with the customer details of those who have 
-- churned and have made complaints.

SELECT
    cr.ReturnID,
    cr.CustomerID,
    cr.ReturnDate,
    cr.RefundAmount,
    cc.Churn,
    cc.Complain
FROM customer_returns AS cr
JOIN customer_churn AS cc
    ON cr.CustomerID = cc.CustomerID
WHERE cc.Churn = 1
  AND cc.Complain = 1;

