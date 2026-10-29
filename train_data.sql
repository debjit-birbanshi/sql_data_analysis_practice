CREATE TABLE train_data(
	Row_ID INT,
	Order_ID VARCHAR(100),
	Order_Date DATE,
	Ship_Date DATE,
	Ship_Mode VARCHAR(50),
	Customer_ID VARCHAR(50),
	Customer_Name VARCHAR(100),
	Segment VARCHAR(100),
	Country VARCHAR(50),
	City VARCHAR(100),
	State VARCHAR(50),
	Postal_Code INT,
	Region VARCHAR(50),
	Product_ID VARCHAR(150),
	Category VARCHAR(100),
	Sub_Category VARCHAR(50),
	Product_Name VARCHAR(100),
	Sales NUMERIC(10,2)

);


SELECT * FROM train_data

SELECT COUNT(*) FROM train_data

SELECT COUNT(DISTINCT(Customer_name)) as Unique_name FROM train_data;

SELECT ship_mode, SUM(sales) AS total_sales FROM train_data
GROUP BY ship_mode
ORDER BY total_sales DESC;


-- 1. Find all unique product categories in the dataset.

SELECT
	DISTINCT(category) AS unique_category
FROM train_data;


-- 2. Calculate total sales for each category and sort them from highest to lowest.

SELECT 
	category,
	SUM(sales) AS total_sales
FROM train_data
GROUP BY category
ORDER BY total_sales DESC;

-- 3. Find the top 5 sub-categories with the highest total sales.

SELECT 
	sub_category,
	SUM(sales) AS total_sales
FROM train_data
GROUP BY  sub_category
ORDER BY total_sales DESC
LIMIT 5;

-- 4. Find customers whose total sales exceed $1,000.

SELECT
    customer_name,
    SUM(sales) AS total_sales
FROM train_data
GROUP BY customer_name
HAVING SUM(sales) > 1000;

-- 5. Count the number of rows for each shipping mode.

SELECT 
	ship_mode, 
	COUNT(*) AS count
FROM train_data
GROUP BY ship_mode
ORDER BY count DESC;

-- 6. Calculate the average sales for each customer segment, rounded to 2 decimal places.

SELECT 
	segment,
	ROUND(AVG(sales),2) AS aa
FROM train_data
GROUP BY segment;

-- 7. Find all states with total sales greater than $2,000.

SELECT
	state,
	SUM(sales) AS total_sales
FROM train_data
GROUP BY state
HAVING SUM(sales) >2000
ORDER BY total_sales DESC;

-- 8. Find cities with at least 3 unique customers.

SELECT
    city,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM train_data
GROUP BY city
HAVING COUNT(DISTINCT customer_id) >= 3
ORDER BY unique_customers DESC;


-- 9. Find Technology products in the West region with sales greater than $100.

SELECT
	region,
	category,
	product_name,
	sales
FROM train_data
WHERE sales > 100 AND category = 'Technology' AND region = 'West';

-- 10. Find products with individual row sales greater than the overall average sales.

SELECT 
	product_name,
	sales
FROM train_data
WHERE sales > (SELECT
	AVG(sales)
FROM train_data)
ORDER BY product_name ASC

-- 11. Find customers who appear in at least 3 rows.

SELECT 
	customer_id,
	customer_name,
	COUNT(*) AS total_rows
FROM train_data
GROUP BY customer_id,customer_name
HAVING COUNT(*) >=3
ORDER BY total_rows DESC;

-- 12. For each region, calculate total sales, average sales, and number of rows.

SELECT 
	region,
	ROUND(AVG(sales),2) AS avg_sales,
	SUM(sales) AS total_sales,
	COUNT(region) as total_rows
FROM train_data
GROUP BY region

-- 13. For each customer segment, calculate total sales separately for Furniture, Office Supplies, and Technology.

SELECT 
	segment,
	category,
	SUM(sales) AS total_sales
FROM train_data
GROUP BY segment, category
ORDER BY segment ASC, category ASC;

-- 14. Find order IDs containing more than one distinct product ID.
SELECT
    Order_ID,
    COUNT(DISTINCT Product_ID) AS total_products
FROM train_data
GROUP BY Order_ID
HAVING COUNT(DISTINCT Product_ID) > 1
ORDER BY total_products DESC;

-- 15. Calculate the number of days between order date and ship date for every row.

SELECT 
		order_date,
		ship_date,
		ship_date - order_date AS date_difference
FROM train_data

-- 16. Calculate total sales for each month and year, sorted chronologically.

SELECT
    EXTRACT(YEAR FROM ship_date) AS year,
    EXTRACT(MONTH FROM ship_date) AS month,
    SUM(sales) AS total_sales
FROM train_data
GROUP BY
    EXTRACT(YEAR FROM ship_date),
    EXTRACT(MONTH FROM ship_date)
ORDER BY
    year ASC,
    month ASC;

-- 17. Find the highest-sales row within each product category.

WITH ranked_sales AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY sales DESC, row_id
        ) AS rn
    FROM train_data
)
SELECT *
FROM ranked_sales
WHERE rn = 1;

-- 18. Rank customers by total sales within each customer segment.

WITH customer_sales AS (
    SELECT
        customer_name,
        segment,
        SUM(sales) AS total_sales
    FROM train_data
    GROUP BY customer_name, segment
)
SELECT
    customer_name,
    segment,
    total_sales,
    DENSE_RANK() OVER (
        PARTITION BY segment
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales
ORDER BY segment, sales_rank;

-- 19. Find customers who placed orders on at least 2 distinct order dates.

SELECT 
	customer_name,
	COUNT(DISTINCT order_date) AS order_count
FROM train_data
GROUP BY customer_name
HAVING COUNT(DISTINCT order_date)>=2
ORDER BY order_count DESC

-- 20. Calculate a running total of sales ordered by order date.

SELECT
	order_date,
	order_id,
	sales,
	SUM(sales) OVER (
	ORDER BY order_date ASC, order_id ASC
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total
FROM train_data
ORDER BY order_date ASC, order_id ASC




