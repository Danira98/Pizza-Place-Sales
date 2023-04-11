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

SELECT*FROM orders;

--DROP TABLE pizzas CASCADE;
--DROP TABLE order_details;

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
	datepart(hour,order_time) as hour
INTO peak_hours
FROM orders
GROUP BY datepart(hour,order_time)
ORDER BY COUNT(order_id) DESC;

SELECT*FROM peak_hours;
DROP TABLE peak_hours;