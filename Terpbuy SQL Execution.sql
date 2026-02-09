-- Part 1 - SQL Analysis

-- Q.1) How many rows of data are stored for each table in the database? 
-- List the name of each table followed by the number of rows it has.
use terpbuy;
select count(category_id)
from category;

select count(customer_id)
from customer;

select count(department_id)
from department;

select count(order_line_id)
from order_line;

select distinct count(order_id)
from orders;

select distinct count(product_id)
from product;

-- Q.2) Which products are considered high-priced products? A high-priced product has a price exceeding $100.00. 
-- List the names and prices of the high-priced products.
select product_name,product_price
from product
where product_price>100
order by product_price desc;

-- Q.3)List all orders placed by customers in the state of Florida. Note: The state abbreviation for Florida is 'FL'. 
-- Include the customers’ first names, last names, city, and segment, along with the order ID and order date.
select *
from customer;

select *
from orders;

select c.first_name,c.last_name,c.city,c.segment,c.state,o.order_id,o.order_date
from customer c
inner join orders o on o.customer_id=c.customer_id
where c.state='FL';

-- or an easy way
select c.first_name,c.last_name,c.city,c.segment,c.state,o.order_id,o.order_date
from customer c,orders o
where c.state='FL';

-- Q.4)List all products that fall in one of the following categories: 'Computers', 'Toys', 'Tennis  & Racquet'. 
-- Include the products’ names, category, department, and price.
select p.product_name,p.category_id,p.department_id,p.product_price,c.category_name
from product p,category c
where c.category_name in ('Computers','Toys','Tennis & Racquet');

select *
from department;

select *
from product;

select *
from category;

-- Q.5) TerpBuy is considering reducing its product offerings.
--  Which products have not yet been sold? Include the name, category, and department for each such product.

select *
from order_line;

select p.product_name,p.category_id,p.department_id,ol.quantity_sold
from product p
inner join order_line ol on ol.product_id=p.product_id
where quantity_sold=0;

-- Hence there are no products which are not sold.All the products are sold.Therefore no need of reducing product offerings.

-- Q.6) List the names of all cities from where orders are shipped. Also, for such cities, find the number of orders 
-- for which shipping was delayed.Sort the list of cities in order from the highest to the least number of shipping orders.
select order_city,count(*) as 'Delayed Shipping'
from orders 
where order_status in ('ON_HOLD','PENDING_PAYMENT','PENDING','SUSPECTED_FRAUD')
group by order_city
order by count(*) desc;

-- Q.7)How many customers are there in each segment? 
-- Show the most popular segment at the top of the result. Incorporate a column alias in the result.
select *
from customer;

select count(customer_id) as 'No of Customers',segment as 'Types of Segments'
from customer
where segment in ('CONSUMER','CORPORATE','HOME_OFFICE')
GROUP by segment
order by count(customer_id) desc;

-- The most popular segment is the consumer segment

-- Q.8)How many orders were placed in the first quarter of 2021? Note: A quarter consists of three months. 
-- Incorporate a column alias in the result.
-- New SQL functions used -- year,quarter
select *
from orders;

select count(order_id) as 'Total Orders'
from orders
where year(order_date)=2021
and quarter(order_date)=1;

-- or by using another method

select count(order_id) as 'Total Orders'
from orders
where order_date between '2021-01-01' and '2021-03-31';

-- Q.9)List in alphabetical order all states supporting multiple customer segments.
-- (Inshort we want the count of segments under each state in alphapetical order)
	select segment
	from customer
	where state='AZ';

select state,segment
from customer
order by state;

select state as 'States',count(distinct segment) as 'Segment Count'
from customer
group by state
having count(distinct segment)>1
order by state;

-- Q.10)To help the commercial sales department with its marketing, 
-- find all customers in the corporate segment who have not placed any orders. 
-- Include each customers’ first name, last name, street, city, state, and zip code.
--  Sort the results by the last name first and then by the first name.
select *
from customer;

select *
from orders;

select c.last_name,c.first_name,c.street,c.city,c.state,c.zipcode,c.segment,o.order_id
from customer c
left join orders o on o.customer_id=c.customer_id
where c.segment='CORPORATE' AND o.order_id is null
order by c.last_name,c.first_name;

-- Q.11)There has been a recall of the product Nike Mens Free 5.0+ Running Shoe. 
-- TerpBuy would have to offer a discount coupon to all customers who purchased this product. 
-- Find all orders that included this product as a part of the purchase. For all such orders, list the customers’ 
-- first names, last names, street, state, zip code, and order date. Each customer can be offered only one discount coupon. 
-- Hence, do not list the same customer more than once.
select *
from customer;

select *
from orders;

select *
from order_line;

select *
from product;

select distinct c.first_name,c.last_name,c.street,c.state,c.zipcode,o.order_date,p.product_name
from customer c
inner join orders o on o.customer_Id=c.customer_Id
inner join order_line ol on ol.order_id=o.order_id
inner join product p on p.product_id=ol.product_id
where product_name='Nike Mens Free 5.0+ Running Shoe';

-- Q.12) Premium customers are those customers who have placed orders with order amounts greater than the average order amount.
--  For each customer, find the first and last names, and the order amount for all orders that exceeded the average order amount.
select c.first_name,c.last_name,ol.total_price
from customer c
inner join orders o on o.customer_Id=c.customer_Id
inner join order_line ol on ol.order_id=o.order_id
where ol.total_price >(
select avg(total_price)
from order_line
);

select *
from order_line;

select avg(total_price)
from order_line;
