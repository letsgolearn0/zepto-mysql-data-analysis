# zepto-mysql-data-analysis
End-to-end MySQL data analysis project on Zepto dataset with data cleaning, EDA, and business insights.

🛒 Zepto E-commerce SQL Data Analysis (MySQL)
This project is a real-world data analyst portfolio project using an e-commerce dataset inspired by Zepto, one of India’s fastest-growing quick-commerce platforms.
It demonstrates a complete SQL workflow in MySQL, from raw data import to data cleaning and business-driven insights.
📺 Inspired by a tutorial from Amlan Mohanty, but implemented independently using MySQL instead of PostgreSQL.
📌 Project Overview
This project simulates how data analysts work in an e-commerce environment using SQL:
✅ Build and structure a real-world inventory database
✅ Perform Exploratory Data Analysis (EDA)
✅ Clean messy data (nulls, invalid values, pricing conversion)
✅ Generate business insights using SQL queries
📁 Dataset Overview
Source: Kaggle (Zepto product inventory dataset)
Each row represents a SKU (Stock Keeping Unit)
Duplicate product names exist due to variations in size, weight, and pricing — reflecting real-world e-commerce data
🧾 Columns
sku_id – Unique product identifier (Primary Key)
name – Product name
category – Product category (Fruits, Snacks, etc.)
mrp – Maximum Retail Price (converted from paise to ₹)
discountPercent – Discount applied
discountedSellingPrice – Final selling price
availableQuantity – Inventory count
weightInGms – Product weight
outOfStock – Stock status (0 = In Stock, 1 = Out of Stock)
quantity – Units per package
🛠️ Tech Stack
MySQL
SQL (Data Analysis & Querying)
🔧 Project Workflow
1. Database & Table Creation
CREATE TABLE zepto(
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
2. Data Import (CSV)
LOAD DATA LOCAL INFILE 'path/to/your/file.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, @outOfStock, quantity)
SET outOfStock = IF(@outOfStock = 'TRUE', 1, 0);
3. 🔍 Data Exploration
Count total records
Preview dataset
Identify null values
List unique product categories
Compare in-stock vs out-of-stock products
Detect duplicate product names (multiple SKUs)
4. 🧹 Data Cleaning
Removed rows where mrp or discountedSellingPrice = 0
Converted pricing from paise → rupees
Ensured consistency in numeric values
5. 📊 Business Insights
🔝 Top 10 products with highest discounts
📉 High-MRP products that are out of stock
💰 Estimated revenue per category
🛍️ Expensive products with low discounts
📊 Top 5 categories with highest average discounts
⚖️ Price per gram (value-for-money analysis)
📦 Product grouping by weight (Low / Medium / Bulk)
🧮 Total inventory weight per category
📂 How to Use This Project
Clone the repository:
git clone https://github.com/letsgolearn0/zepto-mysql-data-analysis
cd zepto-mysql-data-analysis
Open your MySQL client
Create and select a database:
CREATE DATABASE zepto_project;
USE zepto_project;
Run the SQL script provided in the repository
Import the dataset (update file path if needed)
⚠️ Notes
Enable local file import if needed:
SET GLOBAL local_infile = 1;
Convert the dataset to UTF-8 format if you encounter encoding issues
📜 License
This project is licensed under the MIT License — feel free to use, modify, and include it in your portfolio.
🙌 Acknowledgment
Inspired by a YouTube tutorial by Amlan Mohanty
Rebuilt independently using MySQL with custom queries and workflow
