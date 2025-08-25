/* ==========================
   DATA IMPORT & PREVIEW
   ========================== */

-- Preview top 10 rows
SELECT TOP 10 * 
FROM test;

-- Count total rows
SELECT COUNT(*) AS total_rows 
FROM test;


/* ==========================
   DATA CLEANING
   ========================== */

-- Check for NULL values
SELECT * 
FROM test
WHERE sale_date IS NULL
   OR transactions_id IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delete rows with critical NULL values
DELETE FROM test
WHERE quantiy IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;


/* ==========================
   EXPLORATORY DATA ANALYSIS (EDA)
   ========================== */

-- 1. Total number of sales (transactions)
SELECT COUNT(*) AS total_sales 
FROM test;

-- 2. Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
FROM test;

-- 3. Number of unique categories
SELECT COUNT(DISTINCT category) AS total_categories 
FROM test;

-- 4. List of distinct categories
SELECT DISTINCT category 
FROM test;


/* ==========================
   BUSINESS QUESTIONS & ANALYSIS
   ========================== */

-- Q1: All sales made on '2022-11-05'
SELECT * 
FROM test 
WHERE sale_date = '2022-11-05';

-- Q2: Sales from 'Clothing' category with quantity >= 4 in November 2022
SELECT * 
FROM test 
WHERE category = 'Clothing' 
  AND YEAR(sale_date) = 2022 
  AND MONTH(sale_date) = 11
  AND quantiy >= 4;

-- Q3: Total sales and count of transactions for each category
SELECT category, 
       SUM(total_sale) AS total_sales, 
       COUNT(*) AS total_transactions
FROM test 
GROUP BY category;

-- Q4: Average age of customers who purchased from 'Beauty' category
SELECT CAST(AVG(age) AS DECIMAL(10,2)) AS average_age 
FROM test  
WHERE category = 'Beauty';

-- Q5: Number of transactions by gender and category
SELECT category, 
       gender, 
       COUNT(transactions_id) AS total_transactions
FROM test 
GROUP BY category, gender;

-- Q6: Average sales for each month (find best month & year)
SELECT YEAR(sale_date) AS Year, 
       MONTH(sale_date) AS Month, 
       AVG(total_sale) AS average_sales
FROM test 
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY average_sales DESC;

-- Q7: Top 5 customers based on highest total sales
SELECT TOP 5 customer_id, 
       SUM(total_sale) AS total_sales
FROM test  
GROUP BY customer_id 
ORDER BY total_sales DESC;

-- Q8: Unique customers for each category
SELECT category, 
       COUNT(DISTINCT customer_id) AS unique_customers
FROM test 
GROUP BY category;
