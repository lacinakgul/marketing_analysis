

-- Exploratory Data Analysis of Orders Table

SELECT *
FROM orders_table ;

-- Top 3 Revenue by Category

SELECT category, ROUND(SUM(total_amount), 2) AS revenue
FROM orders_table
GROUP BY category
ORDER BY revenue DESC 
LIMIT 3 ;

-- 1. Electronics, 2. Clothing, 3. Home


-- Payment Method Distribution

SELECT payment_method, COUNT(*) AS orders
FROM orders_table
GROUP BY payment_method ;

-- 1. Card, 2.Bank Transfer, 3. Google Pay, 4. Apple Pay, 5. PayPal

-- Average Discount by Category

SELECT category, ROUND(AVG(discount), 2) AS avg_discount
FROM orders_table
GROUP BY category ;


-- Top 10 Customers by Category

WITH customers_cte AS (
SELECT category, customer_id, SUM(total_amount) AS total_sales
FROM orders_table
GROUP BY category, customer_id
),
ranking AS (
SELECT *,
ROW_NUMBER () OVER (PARTITION BY category ORDER BY total_sales DESC) AS rnk
FROM customers_cte 
)
SELECT *
FROM ranking
WHERE rnk <= 10
ORDER BY rnk, category ;


-- Biggest Revenue Brand in Every Category

WITH category_cte AS (
SELECT category, brand, ROUND(SUM(total_amount), 2) AS revenue
FROM orders_table
GROUP BY category, brand
),
ranking AS (
SELECT *,
ROW_NUMBER () OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk
FROM category_cte 
)
SELECT *
FROM ranking
WHERE rnk = 1 ;


-- The Most Valuable Customers in Groups

WITH valuable_customers_cte AS (
SELECT o.customer_id, c.customer_segment, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM orders_table o
JOIN customers_table c
    ON c.customer_id = o.customer_id
GROUP BY customer_id, customer_segment
)
SELECT *,
NTILE(4) OVER(ORDER BY total_sales DESC) customer_quartile
FROM valuable_customers_cte ;


-- Monthly Revenue Ranking

WITH monthly_revenue_cte AS (
SELECT 
MONTH(order_date) AS order_month, ROUND(SUM(total_amount), 2) AS revenue
FROM orders_table
GROUP BY order_month
)
SELECT *,
DENSE_RANK () OVER (ORDER BY revenue DESC) AS rnk
FROM monthly_revenue_cte ;

-- Average Review Score by Customer Segment

SELECT ROUND(AVG(o.review_score), 2) AS avg_review_score, c.customer_segment
FROM orders_table o
JOIN customers_table c
   ON o.customer_id = c.customer_id
GROUP BY c.customer_segment ;

-- Best Selling Category Within Each Segment

WITH sales_cte AS (
SELECT c.customer_segment, o.category, SUM(o.total_amount) AS revenue
FROM orders_table o
JOIN customers_table c
   ON o.customer_id = c.customer_id
GROUP BY c.customer_segment, o.category
),
ranking AS (
SELECT *,
DENSE_RANK () OVER (PARTITION BY customer_segment ORDER BY revenue DESC) AS rnk
FROM sales_cte 
)
SELECT *
FROM ranking
WHERE rnk = 1 ;

-- Number one category is electronics for each segment. 



