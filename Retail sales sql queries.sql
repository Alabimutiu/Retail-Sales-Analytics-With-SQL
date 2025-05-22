## 🗃️ Database and Table Creation

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
)

SELECT* FROM orders;
SELECT * FROM products
SELECT*FROM customers

---Business Questions and SQL Queries

--- 1. Total sales per customer

SELECT customer_id, SUM(quantity * price) AS total_sales
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id;


--- 2. Number of orders per month

SELECT EXTRACT(MONTH FROM order_date) AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month

SELECT TO_CHAR(order_date, 'Month') AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month

--- 3. Top 5 selling products

SELECT product_name, SUM(quantity) AS total_quantity
FROM orders
JOIN products USING(product_id)
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 5


--- 4. Average order value per customer

SELECT customer_id, AVG(quantity * price) AS avg_order_value
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id
ORDER BY 2 DESC


--- 5. Monthly revenue trend

SELECT TO_CHAR(order_date, 'Month') AS month, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY month
ORDER BY 2 DESC


--- 6. Category-wise revenue

SELECT category, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY category;


--- 7. Running total sales per customer

SELECT customer_id, 
        order_date, 
		SUM(quantity * price) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders
JOIN products USING(product_id);


---8. Rank products by revenue per category

SELECT category, product_name, revenue, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank
      FROM (
    SELECT category, product_name, SUM(quantity * price) AS revenue
    FROM orders
    JOIN products USING(product_id)
    GROUP BY product_name,category	
) AS sub


--- 9. First purchase date per customer

SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;


---10. Most recent purchase date per customer

SELECT customer_id, MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;


---11. Customer retention (purchased in more than one month)

	SELECT customer_id
	FROM (
	    SELECT customer_id, COUNT(DISTINCT TO_CHAR(order_date, 'Month')) AS active_months
	    FROM orders
	    GROUP BY customer_id
	 ) sub
	WHERE active_months > 1;


---12. Average days between orders

SELECT customer_id, AVG(days_between_orders) AS Average_Days_Between_Ord
FROM (
SELECT
  customer_id,
  order_date,
  LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
  order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS days_between_orders
FROM orders)
GROUP BY customer_id


---13. Highest revenue day

SELECT order_date, SUM(quantity * price) AS daily_revenue
FROM orders
JOIN products USING(product_id)
GROUP BY order_date
ORDER BY daily_revenue DESC
LIMIT 1;


---14. Product price summary

SELECT category, MIN(price) AS min_price, MAX(price) AS max_price, AVG(price) AS avg_price
FROM products
GROUP BY category;


---15. Monthly sales per product

SELECT TO_CHAR(order_date, 'Month') AS month,product_name, SUM(quantity) AS quantity_sold
FROM orders
JOIN products USING(product_id)
GROUP BY product_name, month


--- 16. Product with highest revenue each month

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


--- 17. Revenue per gender

SELECT gender, SUM(quantity * price) AS total_revenue
FROM orders
JOIN customers USING(customer_id)
JOIN products USING(product_id)
GROUP BY gender;


---18. Best 10 customers by revenue

SELECT customer_id, SUM(quantity * price) AS revenue
FROM orders
JOIN products USING(product_id)
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;


---19. Percentage contribution of each product to total revenue

SELECT product_name, 
       ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM orders JOIN products USING(product_id)), 2) AS revenue_percent
FROM orders
JOIN products USING(product_id)
GROUP BY product_name
ORDER BY 2 DESC


--- 20. Orders with multiple products (combo orders)

SELECT order_date, customer_id, COUNT(DISTINCT product_id) AS num_products
FROM orders
GROUP BY customer_id, order_date
HAVING  COUNT(DISTINCT product_id)>1

