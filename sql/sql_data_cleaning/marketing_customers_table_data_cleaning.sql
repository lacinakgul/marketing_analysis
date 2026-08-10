

-- Data Cleaning

SELECT *
FROM customers_table_3000_fixed ;


-- Changing Data Types

ALTER TABLE customers_table_3000_fixed
MODIFY COLUMN signup_date DATE ; 

ALTER TABLE customers_table_3000_fixed
MODIFY COLUMN last_order_date DATE ; 



-- Removing Duplicates


SELECT *,
ROW_NUMBER () OVER (PARTITION BY customer_id, signup_date, gender, age, city, 
country, traffic_source, device_type, customer_segment, total_orders, lifetime_value, last_order_date) AS row_num
FROM customers_table_3000_fixed ;


WITH cte_duplicates AS (
SELECT *,
ROW_NUMBER () OVER (PARTITION BY customer_id, signup_date, gender, age, city, 
country, traffic_source, device_type, customer_segment, total_orders, lifetime_value, last_order_date) AS row_num
FROM customers_table_3000_fixed
)
SELECT *
FROM cte_duplicates
WHERE row_num > 1 ;

CREATE TABLE `customers_table` (
  `customer_id` int DEFAULT NULL,
  `signup_date` date DEFAULT NULL,
  `gender` text,
  `age` int DEFAULT NULL,
  `city` text,
  `country` text,
  `traffic_source` text,
  `device_type` text,
  `customer_segment` text,
  `total_orders` int DEFAULT NULL,
  `lifetime_value` double DEFAULT NULL,
  `last_order_date` date DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM customers_table ;


INSERT INTO customers_table 
SELECT *,
ROW_NUMBER () OVER (PARTITION BY customer_id, signup_date, gender, age, city, 
country, traffic_source, device_type, customer_segment, total_orders, lifetime_value, last_order_date) AS row_num
FROM customers_table_3000_fixed ;

SELECT *
FROM customers_table ;

SELECT *
FROM customers_table
WHERE row_num > 1; 

DELETE
FROM customers_table
WHERE row_num > 1; 

-- Standartizing Data


SELECT gender
FROM customers_table; 

SELECT gender, CONCAT(UPPER(LEFT(gender, 1)), LOWER(SUBSTRING(gender, 2)))
FROM customers_table ;

UPDATE customers_table
SET gender = CONCAT(UPPER(LEFT(gender, 1)), LOWER(SUBSTRING(gender, 2))) ;


SELECT city, country
FROM customers_table
WHERE country = '' ;


SELECT *,
CASE
   WHEN city = 'Rome' THEN 'Italy'
   WHEN city = 'New York' THEN 'USA'
   WHEN city = 'Istanbul' THEN 'Türkiye'
   WHEN city = 'Madrid' THEN 'Spain'
   WHEN city = 'Berlin' THEN 'Germany'
   WHEN city = 'Toronto' THEN 'Canada'
   WHEN city = 'Paris' THEN 'France'
   WHEN city = 'London' THEN 'UK'
ELSE country
END AS matching_cities_to_countries
FROM customers_table ;

UPDATE customers_table 
SET country = CASE
   WHEN city = 'Rome' THEN 'Italy'
   WHEN city = 'New York' THEN 'USA'
   WHEN city = 'Istanbul' THEN 'Türkiye'
   WHEN city = 'Madrid' THEN 'Spain'
   WHEN city = 'Berlin' THEN 'Germany'
   WHEN city = 'Toronto' THEN 'Canada'
   WHEN city = 'Paris' THEN 'France'
   WHEN city = 'London' THEN 'UK'
ELSE country
END ;

SELECT *
FROM customers_table ;

UPDATE customers_table
SET device_type = TRIM(device_type); 


UPDATE customers_table
SET device_type = CONCAT(UPPER(LEFT(device_type, 1)), LOWER(SUBSTRING(device_type, 2))) ;


SELECT *
FROM customers_table
WHERE total_orders = 0 ;


UPDATE customers_table
SET customer_segment = 'New'
WHERE total_orders = 0
      AND customer_segment IN ('VIP', 'Loyal') ;
      
      
SELECT *
FROM customers_table
WHERE total_orders = 0
     AND lifetime_value > 0 ;
     
     
UPDATE customers_table
SET lifetime_value = 0
WHERE total_orders = 0 ;

UPDATE customers_table
SET last_order_date = NULL
WHERE total_orders = 0
      AND lifetime_value = 0 ;

-- Identified and corrected business logic inconsistencies by reassing customer with zero orders
-- from inappropriate segments and macthed 0 total orders with lifetime value and last order date. 

-- Removing Columns 

ALTER TABLE customers_table
DROP COLUMN row_num ;


SELECT *
FROM customers_table ;

select *
FROM customers_table
where customer_segment IS NULL ;


