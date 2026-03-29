-- 1. Checking the date range
SELECT 
    MIN(transaction_date) AS Start_date,
    MAX(transaction_date) AS Latest_date
FROM `workspace`.`default`.`case_study_1`;

-- 2. Checking the names of the different stores
SELECT DISTINCT 
    store_location
FROM `workspace`.`default`.`case_study_1`;

-- 3. Checking product categories, types, and details
SELECT DISTINCT 
    product_category,
    product_type,
    product_detail
FROM `workspace`.`default`.`case_study_1`;

-- 4. Checking price range
SELECT 
    MIN(unit_price) AS cheapest_price,
    MAX(unit_price) AS expensive_price
FROM `workspace`.`default`.`case_study_1`;

-- 5. Checking counts of transactions, stores, and products
SELECT 
    COUNT(DISTINCT transaction_id) AS number_of_transactions,
    COUNT(DISTINCT store_id) AS number_of_stores,
    COUNT(DISTINCT product_id) AS number_of_products
FROM `workspace`.`default`.`case_study_1`;

-- 6. Viewing transaction details with day and month names
SELECT 
    transaction_id,
    transaction_date,
    DAYNAME(transaction_date) AS Day_name,
    MONTHNAME(transaction_date) AS Month_name
FROM `workspace`.`default`.`case_study_1`;

-- 7. Calculating total revenue
SELECT 
    SUM(unit_price * transaction_qty) AS Total_Revenue
FROM `workspace`.`default`.`case_study_1`;

-- 8. Calculating revenue per day
SELECT 
    transaction_date,
    DAYNAME(transaction_date) AS Day_name,
    MONTHNAME(transaction_date) AS Month_name,
    SUM(transaction_qty * unit_price) AS Revenue_per_day
FROM `workspace`.`default`.`case_study_1`
GROUP BY 
    transaction_date,
    DAYNAME(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY 
    transaction_date ASC;

-- 9. Combining functions to get a clean & enhanced data set
SELECT 
    transaction_id,
    transaction_date,
    transaction_time,
    transaction_qty,
    store_id,
    store_location,
    product_id,

 -- 10. Casting unit_price
 CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) AS unit_price, 

    product_category,
    product_type,
    product_detail,
    (transaction_qty * unit_price) AS Revenue, 
    CASE 
        WHEN DAYNAME(transaction_date) IN ('Sun', 'Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_classification,

    -- 11. Time classification
    CASE 
  when date_format(transaction_time,'HH:MM:SS') BETWEEN '05:00:00' AND '08:59:59' THEN '01. Rush_hour'
  when date_format(transaction_time,'HH:MM:SS') BETWEEN '09:00:00' AND '11:59:59' THEN '02. Mid_Morning'
  when date_format(transaction_time,'HH:MM:SS')BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
  when date_format(transaction_time,'HH:MM:SS') BETWEEN '16:00:00' AND '18:59:59' THEN '04. Rush_hour'
  ELSE 'Night'
    END AS Time_classification,

-- 12. Spend bucket
    CASE  
        WHEN (transaction_qty * unit_price) <= 50 THEN '01. Low_spend'
        WHEN (transaction_qty * unit_price) BETWEEN 51 AND 200 THEN '02. Medium_spend'
        WHEN (transaction_qty * unit_price) BETWEEN 201 AND 400 THEN '03. Moreki'
        ELSE '04. Blesser'
    END AS Spend_bucket
FROM `workspace`.`default`.`case_study_1`;
