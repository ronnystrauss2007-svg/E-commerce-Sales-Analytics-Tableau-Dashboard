CREATE DATABASE EcommerceDB;
GO

USE EcommerceDB;
GO

USE EcommerceDB;
GO

BULK INSERT Orders
FROM 'C:\Users\Lenovo\OneDrive\מסמכים\Ecommerce_Project\ecommerce_raw.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

SELECT TOP 10 * FROM Orders;

USE EcommerceDB;
GO

-- 1. סיכום ביצועים כללי (Executive Summary)
SELECT 
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent,
    ROUND(AVG(Sales), 2) AS Avg_Order_Value
FROM Orders;

-- 2. ניתוח רווחיות לפי קטגוריה וקבוצת מוצרים
SELECT 
    Category,
    Sub_Category,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percent
FROM Orders
GROUP BY Category, Sub_Category
ORDER BY Total_Profit DESC;

-- 3. זיהוי מוצרים שנמכרים בהפסד
SELECT 
    Product_Name,
    Category,
    COUNT(DISTINCT Order_ID) AS Times_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Loss,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percent
FROM Orders
GROUP BY Product_Name, Category
HAVING SUM(Profit) < 0
ORDER BY Total_Loss ASC;