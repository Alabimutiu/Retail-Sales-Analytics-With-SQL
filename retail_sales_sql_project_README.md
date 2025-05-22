
# 🛒 Retail Sales SQL Project

This project uses synthetic business data to analyze customer behavior, product performance, and sales trends using SQL. The dataset includes 3 tables: `customers`, `products`, and `orders`.

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
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month;
```

### 3. Top 5 selling products
```sql
SELECT product_name, SUM(quantity) AS total_quantity
FROM orders
JOIN products USING(product_id)
GROUP BY product_id
ORDER BY total_quantity DESC
LIMIT 5;
```

### 4. Average order value per customer
```sql
SELECT customer_id, AVG(quantity * price) AS avg_order_value
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id;
```

### 5. Monthly revenue trend
```sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY month
ORDER BY month;
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
SELECT customer_id, order_date, SUM(quantity * price) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
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
    GROUP BY product_id
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
    SELECT customer_id, COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) AS active_months
    FROM orders
    GROUP BY customer_id
) sub
WHERE active_months > 1;
```

### 12. Average days between orders
```sql
SELECT customer_id, AVG(DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date))) AS avg_days_between
FROM orders;
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
SELECT product_name, DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(quantity) AS quantity_sold
FROM orders
JOIN products USING(product_id)
GROUP BY product_id, month;
```

### 16. Product with highest revenue each month
```sql
WITH monthly_sales AS (
    SELECT product_id, DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(quantity * price) AS total_revenue
    FROM orders
    JOIN products USING(product_id)
    GROUP BY product_id, month
)
SELECT *
FROM (
    SELECT *, RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rank
    FROM monthly_sales
) ranked
WHERE rank = 1;
```

### 17. Revenue per gender
```sql
SELECT gender, SUM(quantity * price) AS total_revenue
FROM orders
JOIN customers USING(customer_id)
JOIN products USING(product_id)
GROUP BY gender;
```

### 18. Best customers by revenue
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
GROUP BY product_id;
```

### 20. Orders with multiple products (combo orders)
```sql
SELECT order_date, customer_id, COUNT(DISTINCT product_id) AS num_products
FROM orders
GROUP BY customer_id, order_date
HAVING num_products > 1;
```

---

## 📁 Dataset Files

- `customers.csv` – Customer information
- `products.csv` – Product catalog
- `orders.csv` – Sales transactions

You can import these into MySQL, PostgreSQL, or SQLite for analysis.

---
