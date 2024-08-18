SELECT *
FROM pizza_sales

--Total revenue
SELECT ROUND(SUM(total_price),2) as total_revenue
FROM pizza_sales

--Average order value 

SELECT ROUND(SUM(total_price)/COUNT(DISTINCT(order_id)),2) as avr_order_value
FROM pizza_sales
ORDER BY avr_order_value

--Total Pizzas Sold
SELECT SUM(quantity) AS total_pizzas_sold
FROM pizza_sales 
ORDER BY total_pizzas_sold

--Total Orders 
SELECT COUNT(DISTINCT order_id) as total_orders
FROM pizza_sales

--Average Pizzas per Order 
SELECT CAST(CAST(SUM(quantity) AS decimal(10,2))/
CAST(COUNT(DISTINCT order_id)AS DECIMAL (10,2))AS DECIMAL(10,2)) AS avr_pizzas_per_order
FROM pizza_sales
ORDER BY avr_pizzas_per_order

-- Total orders daily trend
SELECT DATENAME(DW, order_date) as order_day, COUNT(DISTINCT order_id) as Total_orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY Total_orders desc

--Hourly Trend
SELECT DATEPART(HOUR, order_time) AS order_hours,
COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY  DATEPART(HOUR, order_time)
ORDER BY total_orders DESC

--Percentage of sales by pizza category 

SELECT pizza_category, 
CAST(SUM(total_price)*100/(SELECT SUM(total_price) 
FROM pizza_sales 
WHERE MONTH(order_date)=1)
AS DECIMAL(10,2)) as perc_of_sales
FROM pizza_sales
WHERE MONTH(order_date)=1
GROUP BY pizza_category
ORDER BY perc_of_sales DESC

-- Percentage of sales by pizza size (April, MONTH =4)

SELECT pizza_size,CAST(SUM(total_price)AS decimal (10,2)) as total_sales, CAST(SUM(total_price)*100/(SELECT SUM(total_price)
FROM pizza_sales
WHERE MONTH(order_date)=4
)AS decimal(10,2)) AS PCT_Size
FROM pizza_sales 
WHERE MONTH(order_date)=4
GROUP BY pizza_size
ORDER BY PCT_Size DESC

--Quarter
SELECT pizza_size,CAST(SUM(total_price)AS decimal (10,2)) as total_sales, CAST(SUM(total_price)*100/(SELECT SUM(total_price)
FROM pizza_sales
WHERE DATEPART(QUARTER,order_date)=1
)AS decimal(10,2)) AS PCT_Size
FROM pizza_sales 
WHERE DATEPART(QUARTER,order_date)=1
GROUP BY pizza_size
ORDER BY PCT_Size DESC

 --Total pizzas sold by pizza category 
 SELECT pizza_category, SUM(quantity) as total_pizzas_sold
 FROM pizza_sales
 GROUP BY pizza_category
 ORDER BY total_pizzas_sold DESC

 --Total Pizzas sold by size

 SELECT pizza_size, SUM(quantity) as total_pizzas_sold_size
 FROM pizza_sales
 GROUP BY pizza_size 
 ORDER BY total_pizzas_sold_size DESC

 --Top 5 pizzas by quantity sold 

SELECT TOP 5 pizza_name, SUM(quantity) as quantity, SUM(total_price) as sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY quantity DESC

--Bottom 5 
SELECT TOP 5 pizza_name, SUM(quantity) as quantity, SUM(total_price) as sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY quantity 
