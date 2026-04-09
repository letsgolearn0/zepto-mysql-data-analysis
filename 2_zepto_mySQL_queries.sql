USE 2_zepto_mySQL;
drop table if exists zepto;

-- Creating table
create table zepto(
sku_id INT AUTO_INCREMENT PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock TINYINT,
quantity INTEGER
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/aguilajoseph/Desktop/Codes/Projects/DataAnalytics/1_zepto.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, @outOfStock, quantity)
SET outOfStock = IF(@outOfStock = 'TRUE', 1, 0);

-- Data Exploration:

-- Count of rows
SELECT COUNT(*) FROM zepto;

-- Sample data
SELECT * FROM zepto LIMIT 10;

-- Null values
SELECT * FROM zepto
WHERE name IS NULL
or
category IS NULL
or
mrp IS NULL
or
discountPercent IS NULL
or
availableQuantity IS NULL
or
discountedSellingPrice IS NULL
or
weightInGms IS NULL
or
outOfStock IS NULL
or
quantity IS NULL;

-- Different product categories
SELECT DISTINCT category FROM zepto
ORDER BY category;

-- Products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id) 
FROM zepto
GROUP BY outOfStock;

-- Product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Data Cleaning:

-- Products with price = zero
SELECT * FROM zepto 
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- Disable safe mode temporarily then delete one row from zepto table
SET SQL_SAFE_UPDATES = 0;
DELETE FROM zepto
WHERE mrp = 0;
SET SQL_SAFE_UPDATES = 1;

-- Disable safe mode temporarily then  convert prices from Indian rupees cents (paise) into Indian rupees
SET SQL_SAFE_UPDATES = 0;
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;
SELECT mrp, discountedSellingPrice FROM zepto;
SET SQL_SAFE_UPDATES = 1;


-- Q1. Find the top 10 best-value products based on the discount percentage. 
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = 1 and mrp > 300
ORDER BY mrp DESC;

-- Q3. Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than 7500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT DISTINCT category,
ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, discountedSellingPrice, weightInGms,
ROUND(discountedSellingPrice/weightInGMs, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100 AND weightInGms > 0
ORDER BY price_per_gram ASC;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE 
	WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
END AS weight_category
FROM zepto;

-- Q8. What is the Total Inventory Weight Per Category
SELECT DISTINCT category,
SUM(weightInGMs * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

