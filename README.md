# SQL Challenge - Week 1

![Case Study #1](1.png)

## Overview
This repository contains SQL queries for the first week of an 8-week SQL challenge. The queries are designed to analyze customer purchases at a restaurant, providing insights such as total spending, visit counts, popular menu items, and loyalty program effects.

![Database Schema][(Screenshot 2025-02-20 203307.png)]

## Case Study Questions & Solutions
Below are the key questions addressed in this SQL challenge along with their corresponding SQL solutions:

### 1. What is the total amount each customer spent at the restaurant?
```sql
SELECT Sales.customer_id, SUM(price)
FROM Sales 
FULL JOIN Menu ON Sales.product_id = Menu.product_id
GROUP BY Sales.customer_id;
```

### 2. How many days has each customer visited the restaurant?
```sql
SELECT Customer_id, COUNT(DISTINCT order_date) 
FROM Sales
GROUP BY Customer_id;
```

### 3. What was the first item from the menu purchased by each customer?
```sql
SELECT DISTINCT(customer_id), order_date, menu.product_name 
FROM Sales
FULL JOIN Menu ON Sales.product_id = Menu.product_id
WHERE Sales.order_date IN 
    (SELECT MIN(order_date) FROM Sales)
ORDER BY order_date ASC;
```

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT menu.product_name, COUNT(order_date) 
FROM Menu
FULL JOIN Sales ON menu.product_id = Sales.product_id
GROUP BY menu.product_name
ORDER BY COUNT(Sales.order_date) DESC
LIMIT 1;
```

### 5. Which item was the most popular for each customer?
```sql
SELECT DISTINCT Customer_id, product_name, COUNT(order_date) 
FROM Menu
FULL JOIN Sales ON menu.product_id = Sales.product_id 
GROUP BY product_name, Customer_id 
ORDER BY COUNT(order_date) DESC
LIMIT 4;
```

### 6. Which item was purchased first by the customer after they became a member?
```sql
WITH first_purchasing AS (
    SELECT Sales.customer_id, MIN(order_date) AS first_order_date
    FROM Sales
    FULL JOIN Menu ON menu.product_id = Sales.product_id
    GROUP BY Sales.customer_id)
SELECT Sales.customer_id, Sales.order_date, Sales.product_id, Menu.product_name
FROM Sales
FULL JOIN first_purchasing ON first_purchasing.customer_id = Sales.customer_id
AND Sales.order_date = first_purchasing.first_order_date
FULL JOIN Menu ON Sales.product_id = Menu.product_id
FULL JOIN Members ON Members.customer_id = Sales.customer_id
WHERE order_date = Members.join_date 
ORDER BY Sales.order_date;
```

### 7. Which item was purchased just before the customer became a member?
```sql
WITH first_purchasing AS (
    SELECT Sales.customer_id, MIN(order_date) AS first_order_date
    FROM Sales
    FULL JOIN Menu ON menu.product_id = Sales.product_id
    GROUP BY Sales.customer_id)
SELECT Sales.customer_id, Sales.order_date, Sales.product_id, Menu.product_name
FROM Sales
FULL JOIN first_purchasing ON first_purchasing.customer_id = Sales.customer_id
AND Sales.order_date = first_purchasing.first_order_date
FULL JOIN Menu ON Sales.product_id = Menu.product_id
FULL JOIN Members ON Members.customer_id = Sales.customer_id
WHERE order_date = first_purchasing.first_order_date
ORDER BY Sales.order_date;
```

### 8. What is the total items and amount spent for each member before they became a member?
```sql
WITH first_purchasing AS (
    SELECT Sales.customer_id, MIN(order_date) AS first_order_date
    FROM Sales
    FULL JOIN Menu ON menu.product_id = Sales.product_id
    GROUP BY Sales.customer_id)
SELECT Sales.customer_id, SUM(Sales.product_id), Menu.product_name,
       COUNT(Menu.price), order_date
FROM Sales
FULL JOIN first_purchasing ON first_purchasing.customer_id = Sales.customer_id
AND Sales.order_date = first_purchasing.first_order_date
FULL JOIN Menu ON Sales.product_id = Menu.product_id
FULL JOIN Members ON Members.customer_id = Sales.customer_id 
GROUP BY Sales.customer_id, Menu.product_name, order_date, first_purchasing.first_order_date
HAVING order_date = first_purchasing.first_order_date;
```

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```sql
SELECT Sales.customer_id,
SUM(
    CASE 
        WHEN product_name = 'sushi' THEN price * 10 * 2
        ELSE price * 10
    END) AS spent_points
FROM Menu 
FULL JOIN Sales ON menu.product_id = Sales.product_id
GROUP BY Sales.customer_id
ORDER BY spent_points DESC;
```

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```sql
SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN s.order_date BETWEEN m.join_date AND m.join_date + INTERVAL '6 days' THEN 
                CASE 
                    WHEN me.product_name = 'sushi' THEN me.price * 10 * 2
                    ELSE me.price * 10 * 2
                END
            ELSE 
                CASE 
                    WHEN me.product_name = 'sushi' THEN me.price * 10 * 2
                    ELSE me.price * 10
                END
        END) AS total_points
FROM sales s
INNER JOIN menu me ON s.product_id = me.product_id
INNER JOIN members m ON s.customer_id = m.customer_id
WHERE s.order_date <= '2024-01-31'  
GROUP BY s.customer_id
ORDER BY total_points DESC;
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
