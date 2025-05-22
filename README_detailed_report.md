
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

## 🧠 SQL Concepts Used

- **Window Functions**: `LAG`, `RANK`, `ROW_NUMBER`, `SUM() OVER()`
- **Date Functions**: `EXTRACT`, `TO_CHAR`, `AGE`, `DATE_DIFF`
- **Aggregations**: `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
- **Joins**: `INNER JOIN`, `JOIN USING`
- **CTEs and Subqueries**

---

## 🛠️ How to Use This Project

1. Create a PostgreSQL or MySQL database.
2. Import the provided CSVs: `customers.csv`, `products.csv`, `orders.csv`.
3. Use the `retail_sales_sql_project_README.md` or `.sql` script to create tables and run analysis.
4. Visualize the findings in your favorite BI tool (Power BI, Tableau, etc).

---

## 📎 Business Use Cases Covered

- Customer segmentation
- Sales performance tracking
- Product/category performance
- Time-series trend analysis
- Purchase frequency metrics
- Campaign planning and retention tracking

---

## 📌 Future Improvements

- Add customer location for geo-based analysis
- Track order status (delivered, returned, etc.)
- Integrate with Python or Power BI for automated reporting
- Include customer reviews and ratings for sentiment analysis

---

## 🤝 Credits

Data generated using Python and Faker library. Created by [Your Name] for SQL analytics portfolio.

