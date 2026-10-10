SELECT 'Customers' AS TableName, COUNT_BIG(*) AS Row_Count
FROM dbo.Customers

UNION ALL

SELECT 'Orders', COUNT_BIG(*)
FROM dbo.Orders -- correct

UNION ALL

SELECT 'OrderItems', COUNT_BIG(*)
FROM dbo.Order_items

UNION ALL

SELECT 'Products', COUNT_BIG(*)
FROM dbo.Products;