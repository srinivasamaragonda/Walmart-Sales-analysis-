-- 1. Build a database

CREATE DATABASE WALMART_SALES;
USE WALMART_SALES;
SELECT * FROM SALES;
SELECT `Invoice ID` FROM SALES;
-- Select columns with null values in them
select * from sales
where 'city' is null;
alter table sales
drop time_of_day;

/*1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and
Evening. This will help answer the question on which part of the day most sales are made.*/
ALTER TABLE SALES
ADD COLUMN  time_of_day varchar(20);     
SET SQL_SAFE_UPDATES = 0;
update sales
SET time_of_day= 
CASE
WHEN extract(hour from  time)BETWEEN 0.00 and 11.59 then 'morning'
WHEN extract(hour from  time)BETWEEN 12 and 17 then 'afternoon'
ELSE 'evening' END;
/*2. Add a new column named day_name that contains the extracted days of the week on which the
given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which
week of the day each branch is busiest.*/

ALTER TABLE sales
ADD column day_name varchar(20);
update sales
set day_name=dayname(str_to_date(Date,'%Y-%m-%d'));
/*3. Add a new column named month_name that contains the extracted months of the year on which the
given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most
sales and profit.*/
update sales
set month_name=monthname(str_to_date(Date,'%Y-%m-%d'));

SELECT * FROM sales;
-- --------- Generic Question -------------------
----- BusinessQuestions To Answer GenericQuestion----------------

-- 1. How many unique cities does the data have?
select count(distinct city) AS unique_cities
FROM sales;
-- 2. In which city is each branch?
SELECT DISTINCT branch, city
FROM sales;

-- ###################### Product #############################

-- 1. How many unique product lines does the data have?
SELECT COUNT(DISTINCT `Product line`) AS unique_product_lines
FROM sales;
-- 2. What is the most common payment method?
SELECT payment, count(*) AS count
FROM sales
GROUP BY payment
ORDER BY count DESC
LIMIT 1;
-- 3. What is the most selling product line?
SELECT `product line`, SUM(quantity) AS total_quantity_sold
FROM SALES
GROUP BY `product line`
ORDER BY total_quantity_sold DESC;
-- 4. What is the total revenue by month?
select month_name,SUM(Total) AS revenue
FROM sales
GROUP BY month_name
ORDER BY revenue;
-- 5. What month had the largest COGS?
SELECT `product line`,SUM(Total) AS total_revenue
FROM sales
GROUP BY `product line`
ORDER BY total_revenue DESC
LIMIT 1;
-- 6. What product line had the largest revenue?
SELECT city,SUM(Total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;
-- 7. What is the city with the largest revenue?
select city,max(total) AS largest
 from sales
 group by city
 order by largest;
-- 8. What product line had the largest VAT?
select `product line`,SUM(`tax 5%`) AS total_vat
FROM sales
GROUP BY `product line`
ORDER BY total_vat DESC
LIMIT 1;
/*9. Fetch each product line and add a column to those product line showing "Good","Bad"
 if its greater than average sales*/
select `product line`,avg(total) as av,
if(avg(Total)>(select avg(total) from sales),"good", "bad") as cat
from sales
group by `product line`;
-- 10. Which branch sold more products than average product sold?
SELECT branch,avg(quantity) AS product
from sales
group by branch
having avg(quantity)>(select avg(quantity)from sales);
-- 11. What is the most common product line by gender?

select `product line`, gender, count(*) AS common
from sales
group by gender,`product line`
order by common DESC;

-- 12. What is the average rating of each product line?
select `product line`,avg(rating) as average_rating
from sales
group by `product line`;

-- ######################## Sales #################################
-- 1. Number of sales made in each time of the day per weekday
select sum(quantity),time_of_day
from sales
group by time_of_day;
-- 2. Which of the customer types brings the most revenue?
select `customer type`,sum(total) AS most_revenue
from sales
group by `customer type`
order by most_revenue;
-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, max(`Tax 5%`) AS VAT
from sales
group by city
order by VAT DESC
limit 1;
-- 4. Which customer type pays the most in VAT?
select `customer type`, max(`Tax 5%`) AS max
from sales
group by `customer type`
order by max;

-- ######################## Customer ################################

-- 1. How many unique customer types does the data have?
select distinct(`customer type`)
from sales;
-- 2. How many unique payment methods does the data have?
select distinct(payment)
from sales;
-- 3. What is the most common customer type?
select count(`customer type`) AS common
from sales
group by `customer type`
order by common;
-- 4. Which customer type buys the most?
select `customer type`,max(quantity) AS buys
from sales 
group by `customer type`
order by buys;
-- 5. What is the gender of most of the customers?
select `customer type` ,max(gender) AS most
from sales
group by `customer type`
order by most;
-- 6. What is the gender distribution per branch?
select branch,count(gender) AS distribution
from sales
group by branch
order by distribution desc;
-- 7. Which time of the day do customers give most ratings?
select time_of_day,max(rating) AS most
from sales
group by time_of_day
order by most;
-- 8. Which time of the day do customers give most ratings per branch?
select branch,time_of_day,max(rating) AS most
from sales
group by branch,time_of_day
order by most;
-- 9. Which day of the week has the best avg ratings?
select day_name,avg(rating) AS avg
from sales
group by day_name
order by avg;
-- 10. Which day of the week has the best average ratings per branch?
select  branch,day_name,avg(rating) AS avg
from sales
group by branch,day_name
order by avg;

 -- #####################   conclusions   ##############################
-- Sales Trends by Product Line
-- Revenue and Profit Insights
-- Customer Segmentation and Preferences
-- Branch Performance
-- Time-Based Sales Patterns
-- #########################################################################