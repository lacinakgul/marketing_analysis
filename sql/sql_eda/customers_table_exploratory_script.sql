

-- Exploratory Data Analysis of Customer Table

SELECT *
FROM customers_table ;

-- Segmentation of Customers

SELECT customer_segment, COUNT(customer_id) AS customer_count
FROM customers_table
GROUP BY customer_segment
ORDER BY customer_count DESC ;

-- First: New (632) , Last: Loyal (550)


-- Top 3 Countries That Have The Most Customers

SELECT country, COUNT(customer_id) AS customer_count
FROM customers_table
GROUP BY country
ORDER BY customer_count DESC ;

-- 1. Germany , 2. UK, France 3. USA

-- Top 3 Traffic Sources

SELECT traffic_source, COUNT(customer_id) AS customer_count
FROM customers_table
GROUP BY traffic_source
ORDER BY customer_count DESC 
LIMIT 3 ;

-- 1. Direct, 2. Social Media, 3. Paid Search 
-- With this insight marketing team can lean on these traffic sources to gain more customers. 

-- Does VIP Customers The Most Valuable Segment?

SELECT customer_segment, ROUND(AVG(lifetime_value), 2) AS avg_value
FROM customers_table
GROUP BY customer_segment
ORDER BY avg_value DESC ;

-- Yes, they are. VIP customers hold lifetime value with 5067.16 follow by loyal customers with 5021.37.


-- Top 3 Average Orders by Customer Segment

SELECT customer_segment, ROUND(AVG(total_orders), 2) AS avg_orders
FROM customers_table
GROUP BY customer_segment
ORDER BY avg_orders DESC
LIMIT 3 ;

-- 1. Loyal (13.55), 2. At Risk (12.74), 3. VIP (12.49) 

-- Does The Lifetime Value Increase as The Number of Orders Increases?

SELECT total_orders, ROUND(AVG(lifetime_value), 2) AS avg_value
FROM customers_table
WHERE total_orders != 0
GROUP BY total_orders
ORDER BY avg_value DESC;

-- There is no correlation between total orders and average litetime value. 

-- Top Customer With Lifetime Value in Each Country

WITH customer_rank AS (
SELECT customer_id, country, lifetime_value,
ROW_NUMBER () OVER (PARTITION BY country ORDER BY lifetime_value DESC) AS rnk
FROM customers_table
)
SELECT *
FROM customer_rank
WHERE rnk = 1 ;

-- Average Order Value by Customer Segment

SELECT c.customer_segment, ROUND(AVG(o.total_amount), 2) AS avg_amount
FROM customers_table c
JOIN orders_table o
    ON c.customer_id = o.customer_id
GROUP BY customer_segment
ORDER BY avg_amount 
LIMIT 3 ;

-- 1. At Risk (1364.17), 2. New (1369.36), 3. Loyal (1409.75) 


-- Top 10 Customers Within Each Segment

WITH customers_segment_cte AS (
SELECT customer_id, customer_segment, lifetime_value,
ROW_NUMBER () OVER (PARTITION BY customer_segment ORDER BY lifetime_value DESC) AS rnk
FROM customers_table
)
SELECT *
FROM customers_segment_cte
WHERE rnk <= 10 ;

-- Customers Who Are Above Average Lifetime values

WITH ltv_cte AS (
SELECT AVG(lifetime_value) AS avg_value
FROM customers_table
)
SELECT customer_id, customer_segment, lifetime_value
FROM customers_table c
CROSS JOIN ltv_cte l
WHERE c.lifetime_value > l.avg_value ;

SELECT *
FROM customers_table ;

