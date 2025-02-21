/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
1. What is the total amount each customer spent at the restaurant?
select Sales.customer_id , sum(price)
from Sales 
full join menu
on Sales.product_id = menu.product_id
group by Sales.customer_id  
2. How many days has each customer visited the restaurant?
select Customer_id ,  count(Distinct order_date) from Sales
group by Customer_id
-- 3. What was the first item from the menu purchased by each customer?
select Distinct(customer_id) , order_date , menu.product_name from Sales
Full join menu
on Sales.product_id = menu.product_id
where Sales.order_date in 
	(select min(order_date) from sales)
order by order_date ASC 
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select menu.product_name , Count(order_date) 
from menu
full join Sales
on menu.product_id = Sales.product_id
group by  menu.product_name
order by Count(Sales.order_date) DESC
limit 1 
5. Which item was the most popular for each customer? 
select Distinct Customer_id , product_name ,  count(order_date) from menu
full join Sales 
On menu.product_id = Sales.product_id 
group by product_name , Customer_id 
order by count(order_date) DESC
limit 4
6. Which item was purchased first by the customer after they became a member?
With first_purshing as (select Sales.customer_id , 
 		min(order_date) as first_order_date
from sales
full join menu
on menu.product_id = sales.product_id
Group by Sales.customer_id)
select Sales.customer_id , Sales.order_date , sales.product_id , menu.product_name
from Sales
full join  first_purshing 
on first_purshing.customer_id = Sales.customer_id
and  Sales.order_date = first_purshing.first_order_date
full join menu
on sales.product_id = menu.product_id
full join members
on members.customer_id = Sales.customer_id
where order_date = members.join_date 
-- and order_date > first_purshing.first_order_date
order by Sales.order_date 
7. Which item was purchased just before the customer became a member?
With first_purshing as (select Sales.customer_id , 
 		min(order_date) as first_order_date
from sales
full join menu
on menu.product_id = sales.product_id
Group by Sales.customer_id)
select Sales.customer_id , Sales.order_date , sales.product_id , menu.product_name
from Sales
full join  first_purshing 
on first_purshing.customer_id = Sales.customer_id
and  Sales.order_date = first_purshing.first_order_date
full join menu
on sales.product_id = menu.product_id
full join members
on members.customer_id = Sales.customer_id
where order_date = first_purshing.first_order_date
-- and order_date > first_purshing.first_order_date
order by Sales.order_date 
 8. What is the total items and amount spent for each member before they became a member?
 With first_purshing as (select Sales.customer_id , 
 		min(order_date) as first_order_date
from sales
full join menu
on menu.product_id = sales.product_id
Group by Sales.customer_id)
select Sales.customer_id ,sum( sales.product_id ) , menu.product_name ,
Count(menu.price) , order_date
from Sales
full join  first_purshing 
on first_purshing.customer_id = Sales.customer_id
and  Sales.order_date = first_purshing.first_order_date
full join menu
on sales.product_id = menu.product_id
full join members
on members.customer_id = Sales.customer_id 
group by Sales.customer_id ,menu.product_name , order_date , first_purshing.first_order_date
Having order_date = first_purshing.first_order_date 
 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select Sales.customer_id ,
Sum (case 
When product_name = 'sushi' Then price * 10 * 2
else price * 10
end ) AS spent_points
from menu 
full join Sales
on menu.product_id = sales.product_id
group by Sales.customer_id
ORDER BY spent_points DESC;
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN s.order_date BETWEEN m.join_date AND m.join_date + INTERVAL '6 days' 
            THEN 
                CASE 
                    WHEN me.product_name = 'sushi' THEN me.price * 10 * 2
                    ELSE me.price * 10 * 2
                END
            ELSE 
                CASE 
                    WHEN me.product_name = 'sushi' THEN me.price * 10 * 2
                    ELSE me.price * 10
                END
        END
    ) AS total_points
FROM sales s
INNER JOIN menu me ON s.product_id = me.product_id
INNER JOIN members m ON s.customer_id = m.customer_id
WHERE s.order_date <= '2024-01-31'  
GROUP BY s.customer_id
ORDER BY total_points DESC;
 
