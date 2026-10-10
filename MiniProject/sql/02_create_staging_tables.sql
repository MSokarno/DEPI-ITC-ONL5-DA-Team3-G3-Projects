-- Creating Customers
CREATE TABLE Customers
(
    customer_id VARCHAR(32) NOT NULL,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(5) NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state VARCHAR(2) NOT NULL,

    geolocation_zip_code_prefix VARCHAR(5) NOT NULL,
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2),

    CONSTRAINT PK_Customers
        PRIMARY KEY (customer_id)
);
GO

select * from Customers


-- Filling Customers

INSERT INTO Customers
(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
)
SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    g.geolocation_zip_code_prefix,
    g.geolocation_city,
    g.geolocation_state
FROM olist_customers_dataset AS c
LEFT JOIN Geo_Zip AS g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;
    
/*
I had to create this dumb table which could have been only a view or any other kind of sql thing. so I'll delete what I created and should
create a suitable view for a cleaner data
SELECT TOP (1000) [geolocation_zip_code_prefix]
      ,[geolocation_city]
      ,[geolocation_state]
  FROM [Olist_Ecommerce].[dbo].[Geo_Zip]

*/
 
 -----------------------------------------------

-- Creating Orders
CREATE TABLE Orders
(
    order_id VARCHAR(32) NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(20) NOT NULL,

    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    payment_type VARCHAR(20),
    payment_installments DECIMAL(10, 2),
    payment_value DECIMAL(10, 2),

    CONSTRAINT PK_Orders
        PRIMARY KEY (order_id),

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);
GO

SELECT *
FROM Orders;

select * from Orders

-- Deduplication

WITH PaymentMethodTotals AS
(
    -- Total amount paid through each method for each order
    SELECT
        order_id,
        payment_type,
        SUM(payment_value) AS method_total
    FROM olist_order_payments_dataset
    GROUP BY
        order_id,
        payment_type
),

PaymentMethodFrequency AS
(
    -- How common each payment method is in the entire table
    SELECT
        payment_type,
        COUNT(*) AS payment_type_count
    FROM olist_order_payments_dataset
    GROUP BY
        payment_type
),

PaymentMethodInstallments AS
(
    -- Average installments for each payment method across the entire table
    SELECT
        payment_type,
        AVG(CAST(payment_installments AS DECIMAL(10,2))) AS avg_installments
    FROM olist_order_payments_dataset
    GROUP BY
        payment_type
),

RankedPaymentMethods AS
(
    SELECT
        p.order_id,
        p.payment_type,
        p.method_total,
        f.payment_type_count,
        i.avg_installments,

        ROW_NUMBER() OVER
        (
            PARTITION BY p.order_id
            ORDER BY
                p.method_total DESC,
                f.payment_type_count DESC,
                p.payment_type ASC
        ) AS rn

    FROM PaymentMethodTotals AS p

    JOIN PaymentMethodFrequency AS f
        ON p.payment_type = f.payment_type

    JOIN PaymentMethodInstallments AS i
        ON p.payment_type = i.payment_type
),

OrderPaymentTotals AS
(
    -- Total amount paid for each order
    SELECT
        order_id,
        SUM(payment_value) AS total_paid
    FROM olist_order_payments_dataset
    GROUP BY
        order_id
)

SELECT
    t.order_id,
    r.payment_type,
    r.avg_installments AS payment_installments,
    t.total_paid AS payment_value

FROM OrderPaymentTotals AS t

JOIN RankedPaymentMethods AS r
    ON t.order_id = r.order_id

WHERE r.rn = 1;


-- Filling Orders

WITH PaymentMethodTotals AS
(
    -- Total amount paid through each payment method for each order
    SELECT
        order_id,
        payment_type,
        SUM(payment_value) AS method_total
    FROM olist_order_payments_dataset
    GROUP BY
        order_id,
        payment_type
),

PaymentMethodFrequency AS
(
    -- Frequency of each payment method across the entire dataset
    SELECT
        payment_type,
        COUNT(*) AS payment_type_count
    FROM olist_order_payments_dataset
    GROUP BY
        payment_type
),

PaymentMethodInstallments AS
(
    -- Average installments for each payment method
    SELECT
        payment_type,
        AVG(CAST(payment_installments AS DECIMAL(10, 2)))
            AS avg_installments
    FROM olist_order_payments_dataset
    GROUP BY
        payment_type
),

RankedPaymentMethods AS
(
    -- Select the dominant payment method for each order
    SELECT
        p.order_id,
        p.payment_type,
        i.avg_installments,

        ROW_NUMBER() OVER
        (
            PARTITION BY p.order_id
            ORDER BY
                p.method_total DESC,
                f.payment_type_count DESC,
                p.payment_type ASC
        ) AS rn

    FROM PaymentMethodTotals AS p

    INNER JOIN PaymentMethodFrequency AS f
        ON p.payment_type = f.payment_type

    INNER JOIN PaymentMethodInstallments AS i
        ON p.payment_type = i.payment_type
),

OrderPaymentTotals AS
(
    -- Total amount paid for each order
    SELECT
        order_id,
        SUM(payment_value) AS total_paid
    FROM olist_order_payments_dataset
    GROUP BY order_id
)

INSERT INTO Orders
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    payment_type,
    payment_installments,
    payment_value
)

SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    r.payment_type,
    r.avg_installments,
    t.total_paid

FROM olist_orders_dataset AS o

LEFT JOIN RankedPaymentMethods AS r
    ON o.order_id = r.order_id
    AND r.rn = 1

LEFT JOIN OrderPaymentTotals AS t
    ON o.order_id = t.order_id;
GO

select * from Orders


--------------------------------------

-- note: Since we are using one table, I wanted to make sure same product doesn't have more than 1 price in same order
SELECT
    order_id,
    product_id,
    COUNT(*) AS occurrence_count,
    COUNT(DISTINCT price) AS distinct_prices,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    COUNT(DISTINCT freight_value) AS distinct_freight_values,
    max(price) - min(price) as gap
FROM olist_order_items_dataset
GROUP BY
    order_id,
    product_id
HAVING max(price) - min(price) <> 0
ORDER BY
    occurrence_count DESC,
    order_id;

 -- Creating Order_items

CREATE TABLE Order_items
(
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2) NOT NULL,
    freight_value DECIMAL(10, 2) NOT NULL,

    CONSTRAINT PK_Order_items
        PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT FK_Order_items_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);
GO

-- Filling Order_items
INSERT INTO Order_items
(
    order_id,
    order_item_id,
    product_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    order_id,
    order_item_id,
    product_id,
    shipping_limit_date,
    price,
    freight_value
FROM olist_order_items_dataset;
GO

-- Validting
SELECT *
FROM Order_items;
GO

-- Compare source and target row counts
SELECT
    (SELECT COUNT(*)
     FROM olist_order_items_dataset) AS source_rows,

    (SELECT COUNT(*)
     FROM Order_items) AS target_rows;
GO

-- Verify composite key uniqueness
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM Order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;
GO


-- Can They be Combained Safely
SELECT
    order_id,
    product_id,
    shipping_limit_date,
    price,
    freight_value,
    COUNT(*) AS quantity
FROM olist_order_items_dataset
GROUP BY
    order_id,
    product_id,
    shipping_limit_date,
    price,
    freight_value
HAVING COUNT(*) > 1
ORDER BY order_id;

-- Different Prices within same order
SELECT
    order_id,
    product_id,
    COUNT(*) AS original_rows,
    COUNT(DISTINCT price) AS distinct_prices,
    COUNT(DISTINCT shipping_limit_date) AS distinct_shipping_dates,
    COUNT(DISTINCT freight_value) AS distinct_freight_values
FROM olist_order_items_dataset
GROUP BY
    order_id,
    product_id
HAVING COUNT(*) > 1
ORDER BY order_id;

-- Remove the existing target table
DROP TABLE Order_items;
GO

-- Create the revised table
CREATE TABLE Order_items
(
    order_id VARCHAR(32) NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    quantity INT NOT NULL,
    shipping_limit_date DATETIME,
    unit_price DECIMAL(10, 2) NOT NULL,
    unit_freight_value DECIMAL(10, 2) NOT NULL,

    CONSTRAINT PK_Order_items
        PRIMARY KEY
        (
            order_id,
            product_id,
            shipping_limit_date,
            unit_price,
            unit_freight_value
        ),

    CONSTRAINT FK_Order_items_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT FK_Order_items_Products
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);
GO

INSERT INTO Order_items
(
    order_id,
    product_id,
    quantity,
    shipping_limit_date,
    unit_price,
    unit_freight_value
)
SELECT
    order_id,
    product_id,
    COUNT(*) AS quantity,
    shipping_limit_date,
    price,
    freight_value
FROM olist_order_items_dataset
GROUP BY
    order_id,
    product_id,
    shipping_limit_date,
    price,
    freight_value;
GO

SELECT
    (SELECT COUNT(*)
     FROM olist_order_items_dataset) AS source_item_rows,

    (SELECT SUM(quantity)
     FROM Order_items) AS represented_units;
GO

SELECT *
FROM Order_items
WHERE order_id = '0008288aa423d2a3f00fcb17cd7d8719';
GO

-------------------------------------

-- Creating Products

CREATE TABLE Products
(
    product_id VARCHAR(32) NOT NULL,
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100),

    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,

    product_weight_g DECIMAL(10, 2),
    product_length_cm DECIMAL(10, 2),
    product_height_cm DECIMAL(10, 2),
    product_width_cm DECIMAL(10, 2),

    CONSTRAINT PK_Products
        PRIMARY KEY (product_id)
);
GO


-- Fixing Unrecognized Columns' Headers

SELECT TOP 5 *
FROM product_category_name_translation;

DELETE FROM product_category_name_translation
WHERE Column1 = 'product_category_name'
  AND Column2 = 'product_category_name_english';

EXEC sp_rename
    'product_category_name_translation.Column1',
    'product_category_name',
    'COLUMN';

EXEC sp_rename
    'product_category_name_translation.Column2',
    'product_category_name_english',
    'COLUMN';

SELECT TOP 5 *
FROM product_category_name_translation;


-- Filling Products

INSERT INTO Products
(
    product_id,
    product_category_name,
    product_category_name_english,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM olist_products_dataset AS p
LEFT JOIN product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name;
GO

select * from Products

