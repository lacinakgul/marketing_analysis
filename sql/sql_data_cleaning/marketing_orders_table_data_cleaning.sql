
-- DATA CLEANING


SELECT *
FROM orders_table_3000_fixed ;

-- Changing Data Types

DESCRIBE orders_table_3000_fixed;


SELECT review_score
FROM orders_table_3000_fixed
WHERE review_score = ''
      OR review_score = ' '
      OR review_score = 'N/A' ;
      
UPDATE orders_table_3000_fixed
SET review_score = NULL      
WHERE review_score = ''
      OR review_score = ' ' ;
      

ALTER TABLE orders_table_3000_fixed
MODIFY COLUMN review_score DECIMAL(2,1) ;

SELECT total_amount
FROM orders_table_3000_fixed
WHERE total_amount = ''
      OR total_amount = ' '
      OR total_amount = 'N/A' ;

UPDATE orders_table_3000_fixed
SET total_amount = NULL      
WHERE total_amount = ''
      OR total_amount = ' ' ;

ALTER TABLE orders_table_3000_fixed
MODIFY COLUMN total_amount DOUBLE ;

ALTER TABLE orders_table_3000_fixed
MODIFY COLUMN order_date DATE ;


-- Removing Duplicates

SELECT *,
ROW_NUMBER() OVER (PARTITION BY order_id, customer_id, order_date, category, 
brand, quantity, unit_price, discount, shipping_fee, total_amount, payment_method, order_status, review_score, returned) AS row_num
FROM orders_table_3000_fixed ;

WITH cte_duplicates AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY order_id, customer_id, order_date, category, 
brand, quantity, unit_price, discount, shipping_fee, total_amount, payment_method, order_status, review_score, returned) AS row_num
FROM orders_table_3000_fixed 
)
SELECT *
FROM cte_duplicates
WHERE row_num > 1 ;

CREATE TABLE `orders_table` (
  `order_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `category` text,
  `brand` text,
  `quantity` int DEFAULT NULL,
  `unit_price` double DEFAULT NULL,
  `discount` text,
  `shipping_fee` double DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `payment_method` text,
  `order_status` text,
  `review_score` decimal(2,1) DEFAULT NULL,
  `returned` text,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM orders_table ;

INSERT INTO orders_table 
SELECT *,
ROW_NUMBER() OVER (PARTITION BY order_id, customer_id, order_date, category, 
brand, quantity, unit_price, discount, shipping_fee, total_amount, payment_method, order_status, review_score, returned) AS row_num
FROM orders_table_3000_fixed ; 

SELECT *
FROM orders_table
WHERE row_num > 1 ;

DELETE 
FROM orders_table
WHERE row_num > 1 ;

-- Populating Data

SELECT category, brand
FROM orders_table 
WHERE category = '' ; 

SELECT *,
CASE
   WHEN brand = 'Samsung' THEN 'Electronics' 
   WHEN brand = 'Penguin' THEN 'Books' 
   WHEN brand = 'Philips' THEN 'Home'
   WHEN brand = 'Sony' THEN 'Electronics'
   WHEN brand = 'Zara' THEN 'Clothing'
   WHEN brand = 'Nivea' THEN 'Beauty'
   WHEN brand = 'Nestle' THEN 'Grocery'
   WHEN brand = 'Wilson' THEN 'Sports'
   WHEN brand = 'Apple' THEN 'Electronics'
   WHEN brand = 'L\'Oreal' THEN 'Beauty'
   WHEN brand = 'IKEA' THEN 'Home'
   WHEN brand = 'Adidas' THEN 'Clothing'
   WHEN brand = 'Lego' THEN 'Toys'
   WHEN brand = 'Nike' THEN 'Clothing'
   WHEN brand = 'HP' THEN 'Office'
ELSE brand
END AS brand_segment
FROM orders_table ;
   
UPDATE orders_table
SET category = CASE 
WHEN brand = 'Samsung' THEN 'Electronics' 
   WHEN brand = 'Penguin' THEN 'Books' 
   WHEN brand = 'Philips' THEN 'Home'
   WHEN brand = 'Sony' THEN 'Electronics'
   WHEN brand = 'Zara' THEN 'Clothing'
   WHEN brand = 'Nivea' THEN 'Beauty'
   WHEN brand = 'Nestle' THEN 'Grocery'
   WHEN brand = 'Wilson' THEN 'Sports'
   WHEN brand = 'Apple' THEN 'Electronics'
   WHEN brand = 'L\'Oreal' THEN 'Beauty'
   WHEN brand = 'IKEA' THEN 'Home'
   WHEN brand = 'Adidas' THEN 'Clothing'
   WHEN brand = 'Lego' THEN 'Toys'
   WHEN brand = 'Nike' THEN 'Clothing'
   WHEN brand = 'HP' THEN 'Office'
ELSE category 
END ;

SELECT *
FROM orders_table ;

UPDATE orders_table
SET discount = NULL 
WHERE discount = '' ;


SELECT *
FROM orders_table 
WHERE discount IS NULL ;

UPDATE orders_table
SET discount = ROUND ((1 - ((total_amount - shipping_fee) / (quantity * unit_price))) * 100, 2)
WHERE discount IS NULL ; 

-- Standardized Categorical Values

SELECT DISTINCT (returned)
FROM orders_table ;

UPDATE orders_table
SET returned = NULL
   WHERE returned = '' ; 

UPDATE orders_table 
SET returned = 'Yes'
   WHERE returned = 'Y' ;

UPDATE orders_table 
SET returned = 'No'
   WHERE returned = 'N' ;


-- Deleting Columns

ALTER TABLE orders_table
DROP COLUMN row_num ;

SELECT *
FROM orders_table ;








