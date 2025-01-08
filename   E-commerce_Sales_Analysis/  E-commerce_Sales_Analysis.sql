-- E-commerce_Sales_Analysis

-- I got the dataset from kaggle
-- The dataset contains the following columns:

-- 1. product_id: Unique identifier for each product.
-- 2. product_name: Name of the product.
-- 3. category: Product category.
-- 4. price: Price of the product.
-- 5. review_score: Average customer review score (1 to 5).
-- 6. review_count: Total number of reviews.
-- 7. sales_month_1 to sales_month_12: Monthly sales data for each product over the past year

-- Queries

-- 1. Query to get the total sales by product
SELECT product_id,
	   product_name, 
	   SUM(sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + sales_month_6 +
        sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + sales_month_11 + sales_month_12) AS total_sales
FROM ecommerce_sales
GROUP BY product_id, product_name
ORDER BY total_sales DESC;
 
-- 2. Query to get top seling category
SELECT category, 
       SUM(sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + sales_month_6 +
	   sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + sales_month_11 + sales_month_12) AS total_sales
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 3. Query to get Best and worst Products by Review Score
SELECT product_id,
	   product_name,
       review_score
FROM ecommerce_sales
-- ORDER BY review_score DESC;  -- BEST
ORDER BY review_score ASC;      -- WORST

-- 4. Monthly Sales Trend for a Specific Product

SELECT product_id,
	   product_name,
	   sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, sales_month_6,
       sales_month_7, sales_month_8, sales_month_9, sales_month_10, sales_month_11, sales_month_12
FROM ecommerce_sales
WHERE product_name = 'product_1';
       

-- 5. Query to get Total Sales per Month Across All Products
SELECT 
    'Month 1' AS month, SUM(sales_month_1) AS total_sales 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 2', SUM(sales_month_2) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 3', SUM(sales_month_3) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 4', SUM(sales_month_4) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 5', SUM(sales_month_5) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 6', SUM(sales_month_6) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 7', SUM(sales_month_7) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 8', SUM(sales_month_8) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 9', SUM(sales_month_9) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 10', SUM(sales_month_10) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 11', SUM(sales_month_11) 
FROM ecommerce_sales
UNION ALL
SELECT 'Month 12', SUM(sales_month_12) 
FROM ecommerce_sales
 
ORDER BY total_sales DESC;


-- 6. Queries to get Top 5 Products with the Most Reviews
SELECT product_id,
       product_name,
       review_count
FROM ecommerce_sales
ORDER BY review_count DESC
LIMIT 5;

-- 7. Query to get Average Price of Products by Category
SELECT category,
       ROUND(AVG(price),2) AS Avg_price
FROM ecommerce_sales
GROUP BY category
ORDER BY Avg_price DESC;
 
-- 8. Query to get Category with the Highest Average Review Score
SELECT category,
       ROUND(AVG(review_score),2) AS Avg_review_score
FROM ecommerce_sales
GROUP BY category
ORDER BY Avg_review_score;

-- 9. Query to get Products with High Sales but Low Review Scores
SELECT product_id,
       product_name,
       review_score,
       (sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + sales_month_6 +
	   sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + sales_month_11 + sales_month_12) AS total_sales
FROM ecommerce_sales
WHERE review_score < 3
ORDER BY total_sales DESC;

-- 10. Query to get Top 5 Categories with the Most Products
SELECT category,
       COUNT(product_id) AS product_count
FROM ecommerce_sales
GROUP BY category
ORDER BY product_count DESC
LIMIT 5;
	   
-- 11. Query to Identify Seasonal Products (Highest Sales in Specific Months)
SELECT 
    product_id, 
    product_name, 
    GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
             sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
             sales_month_11, sales_month_12) AS peak_sales,
    CASE 
        WHEN sales_month_1 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'January'
        WHEN sales_month_2 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'February'
        
        WHEN sales_month_3 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN ' March'
        WHEN sales_month_4 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'April'
        WHEN sales_month_5 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'May'
        WHEN sales_month_6 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'June'
        WHEN sales_month_7 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'July'
        WHEN sales_month_8 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'August'
        WHEN sales_month_9 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'September'
        WHEN sales_month_10 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'October'
        WHEN sales_month_11 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN 'November'
        WHEN sales_month_12 = GREATEST(sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
                                      sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
                                      sales_month_11, sales_month_12) THEN ' December'
        
    END AS peak_month
FROM ecommerce_sales;




