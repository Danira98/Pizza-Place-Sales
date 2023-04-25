
CREATE TABLE orders (
	order_id int,
	order_date date,
	order_time time,
	PRIMARY KEY (order_id)
);

CREATE TABLE pizza_types (
	pizza_type_id varchar(30),
	p_name text,
	category varchar(30),
	ingredients varchar(100),
	PRIMARY KEY (pizza_type_id)	
);
--Note: Line 17 was giving issues due to a special character. Fix: Save original csv to be csv UTF-8 

CREATE TABLE pizzas (
	pizza_id varchar(30),
	pizza_type_id varchar(30),
	size_l text,
	price decimal,
	PRIMARY KEY(pizza_id),
	FOREIGN KEY(pizza_type_id) REFERENCES pizza_types(pizza_type_id) 
);

CREATE TABLE order_details (
	order_details_id int,
	order_id int,
	pizza_id varchar(30),
	quantity int,
	PRIMARY KEY (order_details_id),
	FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id),
	FOREIGN KEY(order_id) REFERENCES orders(order_id)
);

--Code to answer the first set of questions:

--How many customers do we have each day(descending order)?
SELECT COUNT(order_id),
	order_date
INTO customers_per_day
FROM orders
GROUP BY order_date
ORDER BY COUNT(order_id) DESC;

SELECT*FROM customers_per_day;

-- Peak hours for business
SELECT COUNT(order_id),
	EXTRACT(hour from order_time) as hours
INTO peak_hours
FROM orders
GROUP BY hours
ORDER BY COUNT(order_id) DESC;

SELECT*FROM peak_hours;

--How many pizzas are typically in an order?
-- Use FROM(SELECT...) AS name; when doing operations like these
SELECT
	SUM(od.total_quantity)/COUNT(order_id) AS Pizza_avg
INTO avg_orders
FROM(
	SELECT order_id,
		SUM(quantity)as total_quantity
	FROM order_details
	GROUP BY order_id)AS od;
SELECT*FROM avg_orders;

--Best sellers
SELECT*FROM order_details;

SELECT count(order_id),
	pizza_id
INTO best_sellers
FROM order_details
GROUP BY (pizza_id)
ORDER BY COUNT(order_id) DESC;

SELECT*FROM best_sellers;

-- How much revenue was brought this year?

SELECT SUM(p.price *od.quantity)
INTO revenue
FROM order_details AS od
INNER JOIN pizzas as p
ON(od.pizza_id=p.pizza_id);

SELECT*FROM revenue;

-- How much revenue was brought per month
SELECT SUM(p.price *od.quantity) AS rev,
	EXTRACT(MONTH FROM o.order_date) AS months
INTO sales_per_month
FROM order_details AS od
JOIN orders as o
ON(od.order_id=o.order_id)
JOIN pizzas as p
ON(od.pizza_id=p.pizza_id)
GROUP BY (months)
ORDER BY rev DESC;


SELECT*FROM sales_per_month;

-- Least sold

SELECT count(order_id),
	pizza_id
INTO least_sold
FROM order_details
GROUP BY (pizza_id)
ORDER BY COUNT(order_id);

SELECT*FROM least_sold;