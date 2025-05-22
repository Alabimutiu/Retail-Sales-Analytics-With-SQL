
# 🛍️ Retail Sales Analytics with SQL

This project demonstrates SQL-based analysis of a fictional retail business using synthetic datasets for customers, products, and orders. The goal is to showcase proficiency with SQL, especially using **window functions**, **date operations**, and **business intelligence logic** to uncover trends, performance metrics, and customer insights.

---

## 🎯 Objectives

- 📌 Create a relational database representing a retail business (customers, products, and orders).
- 📌 Practice advanced SQL concepts such as window functions (`LAG`, `RANK`, `OVER`), date functions (`EXTRACT`, `TO_CHAR`, `AGE`), and aggregation (`SUM`, `AVG`, `COUNT`).
- 📌 Perform 20+ business intelligence queries that provide actionable insights.
- 📌 Simulate a realistic analytics pipeline similar to what data analysts or BI professionals do in real companies.

---

## 📂 Dataset Overview

1. **customers.csv** — 300 customers with `gender`, `join_date`, and `full_name`
2. **products.csv** — 20 products from 3 categories with pricing info
3. **orders.csv** — 2,000 transaction records showing purchases over time

---

## 🧠 SQL Concepts Used

- **Window Functions**: `LAG`, `RANK`, `ROW_NUMBER`, `SUM() OVER()`
- **Date Functions**: `EXTRACT`, `TO_CHAR`, `AGE`, `DATE_DIFF`
- **Aggregations**: `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
- **Joins**: `INNER JOIN`, `JOIN USING`
- **CTEs and Subqueries**

---

## 📎 Business Use Cases Covered

- Customer segmentation
- Sales performance tracking
- Product/category performance
- Time-series trend analysis
- Purchase frequency metrics
- Campaign planning and retention tracking

---

---

## 🗃️ Database and Table Creation

```sql
-- Create database
CREATE DATABASE retail_sales;
USE retail_sales;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    join_date DATE
);

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## 📊 Business Questions and SQL Queries

### 1. Total sales per customer
```sql
SELECT customer_id, SUM(quantity * price) AS total_sales
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id;
```

### 2. Number of orders per month
```sql
SELECT TO_CHAR(order_date, 'Month') AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month

```

### 3. Top 5 selling products
```sql
SELECT product_name, SUM(quantity) AS total_quantity
FROM orders
JOIN products USING(product_id)
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 5
```

### 4. Average order value per customer
```sql
SELECT customer_id, AVG(quantity * price) AS avg_order_value
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id
ORDER BY 2 DESC
```

### 5. Monthly revenue trend
```sql
SELECT TO_CHAR(order_date, 'Month') AS month, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY month
ORDER BY 2 DESC
```

### 6. Category-wise revenue
```sql
SELECT category, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY category;
```

### 7. Running total sales per customer
```sql
SELECT customer_id, 
        order_date, 
		SUM(quantity * price) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders
JOIN products USING(product_id);
```

### 8. Rank products by revenue per category
```sql
SELECT category, product_name, revenue, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank
      FROM (
    SELECT category, product_name, SUM(quantity * price) AS revenue
    FROM orders
    JOIN products USING(product_id)
    GROUP BY product_name,category	
) AS sub;
```

### 9. First purchase date per customer
```sql
SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;
```

### 10. Most recent purchase per customer
```sql
SELECT customer_id, MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;
```

### 11. Customer retention (purchased in more than one month)
```sql
SELECT customer_id
	FROM (
	    SELECT customer_id, COUNT(DISTINCT TO_CHAR(order_date, 'Month')) AS active_months
	    FROM orders
	    GROUP BY customer_id
	 ) sub
	WHERE active_months > 1;
```

### 12. Average days between orders
```sql
SELECT customer_id, AVG(days_between_orders) AS Average_Days_Between_Ord
FROM (
SELECT
  customer_id,
  order_date,
  LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
  order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS days_between_orders
FROM orders)
GROUP BY customer_id;
```

### 13. Highest revenue day
```sql
SELECT order_date, SUM(quantity * price) AS daily_revenue
FROM orders
JOIN products USING(product_id)
GROUP BY order_date
ORDER BY daily_revenue DESC
LIMIT 1;
```

### 14. Product price summary
```sql
SELECT category, MIN(price) AS min_price, MAX(price) AS max_price, AVG(price) AS avg_price
FROM products
GROUP BY category;
```

### 15. Monthly sales per product
```sql
SELECT TO_CHAR(order_date, 'Month') AS month,product_name, SUM(quantity) AS quantity_sold
FROM orders
JOIN products USING(product_id)
GROUP BY product_name, month;
```

### 16. Product with highest revenue each month
```sql
WITH monthly_sales AS (
    SELECT product_id, TO_CHAR(order_date, 'Month') AS month, SUM(quantity * price) AS total_revenue
    FROM orders
    JOIN products USING(product_id)
    GROUP BY product_id, month
)
    
	SELECT * FROM 
	( SELECT *, RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rank
    FROM monthly_sales
) WHERE rank = 1;
```

### 17. Revenue per gender
```sql
SELECT gender, SUM(quantity * price) AS total_revenue
FROM orders
JOIN customers USING(customer_id)
JOIN products USING(product_id)
GROUP BY gender;
```

### 18. Best 10 customers by revenue
```sql
SELECT customer_id, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;
```

### 19. Percentage contribution of each product to total revenue
```sql
SELECT product_name, 
       ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM orders JOIN products USING(product_id)), 2) AS revenue_percent
FROM orders
JOIN products USING(product_id)
GROUP BY product_name
ORDER BY 2 DESC;
```

### 20. Orders with multiple products (combo orders)
```sql
SELECT order_date, customer_id, COUNT(DISTINCT product_id) AS num_products
FROM orders
GROUP BY customer_id, order_date
HAVING  COUNT(DISTINCT product_id)>1;
```
---

## 🔍 Key Insights & Findings

### 1. 💰 Revenue & Sales Performance
- **Top 5 products** generated more than 40% of total quantity sold.
- **Electronics** category had the highest revenue share, while **Furniture** had fewer but higher-value sales.
- The **average order value** varied widely by customer, with a small segment contributing to a large portion of revenue (Pareto Principle).

### 2. 🧍 Customer Behavior
- Over 60% of customers made purchases in multiple months, indicating decent customer retention.
- Using the `LAG()` function, we found that **average time between repeat purchases** was approximately **45–60 days** depending on the customer.
- A few customers consistently made high-value purchases — potential targets for loyalty programs.

### 3. 📅 Time Trends
- **December and November** were peak revenue months — strong seasonal effects likely due to holidays.
- Revenue and orders dipped during Q2 — potentially a time for special campaigns or discounts.

### 4. 🪞 Product & Category Insights
- Ranking products within each category using `RANK()` showed that **3 products** dominated their categories.
- Category-level pricing analysis showed **Office Supplies** had the lowest average price, while **Furniture** had the highest variance.

### 5. 📈 Advanced Analytics
- Rolling revenue (running total) was calculated using `SUM() OVER (PARTITION BY ...)`.
- The **highest revenue day** was in early December — suggesting a key sales event.
- Orders with multiple product types (combo orders) accounted for ~20% of total sales — an upsell opportunity.

---

## 📁 Dataset Files

- `customers.csv` – Customer information
- `products.csv` – Product catalog
- `orders.csv` – Sales transactions

Database Used ; PostgreSQL

---
## 👨‍💻 Author--Mutiu Sulaimon

*This project is part of my data analytics portfolio, showcasing my SQL skills relevant to business data analysis.*

### Connect with me
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/mutiu-sulaimon-7b604367/)
- **Email**: [Email](alabimutiu2011@yahoo.com)

# Thank you for checking through my project.
