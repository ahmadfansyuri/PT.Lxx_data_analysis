CREATE DATABASE lemonilo;
USE lemonilo;
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE pemesanan(TradeDate CHAR(15),
						user_id int,
						category varchar(20),
                        order_status VARCHAR(10));

UPDATE pemesanan SET TradeDate = str_to_date(TradeDate, "%m/%d/%Y");
SELECT * FROM pemesanan;

/*a. How many unique users who ever done a complete order?*/
/*answer=333 users*/
SELECT DISTINCT count(user_id), order_status
from pemesanan
where order_status = "Completed";

/*b. Please aggregate number of users in each category based on order_status*/
SELECT order_status, category, count(*) as total
from pemesanan
group by order_status, category
order by order_status asc;

/*c. How long does an average user repurchase an item? Please refer to completed order only*/
/*answer= 0 no same user_id repurchase the item on the Data*/
SELECT user_id, order_status, AVG(TradeDate - PriorDate)
FROM (
  SELECT
    user_id,
    TradeDate,
    order_status,
    LAG(TradeDate) OVER (PARTITION BY user_id ORDER BY TradeDate) as PriorDate
  FROM pemesanan
  where order_status="completed") as coba
GROUP BY user_id;

/*e. Which category has highest number of unpaid orders?*/
/*answer: Personal hygiene*/
SELECT category, count(*) as highest_unpaid
from pemesanan
where order_status="Unpaid"
group by category
order by highest_unpaid desc
limit 1;

SELECT user_id, COUNT(user_id) AS count
FROM pemesanan
GROUP BY user_id;
