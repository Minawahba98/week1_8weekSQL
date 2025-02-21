# week1_8weekSQL
# SQL Challenge - Week 1

![Case Study #1](1.png)

## Overview
This repository contains SQL queries for the first week of an 8-week SQL challenge. The queries are designed to analyze customer purchases at a restaurant, providing insights such as total spending, visit counts, popular menu items, and loyalty program effects.

![Database Schema](Screenshot 2025-02-20 203307)

## Case Study Questions
Below are the key questions addressed in this SQL challenge:

1. **Total Spending**: What is the total amount each customer spent at the restaurant?
2. **Visit Frequency**: How many days has each customer visited the restaurant?
3. **First Purchase**: What was the first item from the menu purchased by each customer?
4. **Most Popular Item**: What is the most purchased item on the menu and how many times was it purchased by all customers?
5. **Customer Favorites**: Which item was the most popular for each customer?
6. **First Purchase After Membership**: Which item was purchased first by the customer after they became a member?
7. **Last Purchase Before Membership**: Which item was purchased just before the customer became a member?
8. **Pre-Membership Spending**: What is the total number of items and amount spent by each member before they became a member?
9. **Loyalty Points Calculation**: If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
10. **Bonus Loyalty Points**: In the first week after a customer joins the program (including their join date), they earn 2x points on all items, not just sushi. How many points do customer A and B have at the end of January?

## Database Schema
The queries assume the presence of the following tables:

- **Sales**: Records each purchase made by a customer.
- **Menu**: Contains details about menu items, including product names and prices.
- **Members**: Stores membership details, including join dates.

## Example Queries
### 1. Total Spending per Customer
```sql
SELECT Sales.customer_id, SUM(price) AS total_spent
FROM Sales 
FULL JOIN Menu ON Sales.product_id = Menu.product_id
GROUP BY Sales.customer_id;
```

### 2. Customer Visit Count
```sql
SELECT Customer_id, COUNT(DISTINCT order_date) AS visit_count
FROM Sales
GROUP BY Customer_id;
```

### 3. First Purchased Item per Customer
```sql
SELECT DISTINCT Sales.customer_id, Sales.order_date, Menu.product_name 
FROM Sales
FULL JOIN Menu ON Sales.product_id = Menu.product_id
WHERE Sales.order_date IN (SELECT MIN(order_date) FROM Sales)
ORDER BY Sales.order_date ASC;
```

### 9. Loyalty Points Calculation
```sql
SELECT Sales.customer_id,
       SUM(
           CASE 
               WHEN product_name = 'sushi' THEN price * 10 * 2
               ELSE price * 10
           END
       ) AS spent_points
FROM Menu 
FULL JOIN Sales ON Menu.product_id = Sales.product_id
GROUP BY Sales.customer_id
ORDER BY spent_points DESC;
```

## How to Run the Queries
1. Ensure your database contains the **Sales**, **Menu**, and **Members** tables.
2. Copy and execute each SQL query using your preferred database tool (e.g., PostgreSQL, MySQL, SQL Server, or SQLite).
3. Modify table and column names if needed to match your database schema.

## Next Steps
- Continue refining SQL queries and optimizing performance.
- Move on to Week 2 of the challenge!

---

### Author
Mina Wahba

### License
MIT License
