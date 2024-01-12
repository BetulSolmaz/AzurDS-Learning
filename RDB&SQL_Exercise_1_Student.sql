SELECT * from INFORMATION_SCHEMA.TABLES
---- 1. List all the cities in the Texas and the numbers of customers in each city.----
SELECT city, COUNT(customer_id) Count_customer
FROM sale.customer WHERE [state]='TX' 
GROUP BY city


---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---
SELECT city, COUNT(customer_id) Count_customer
FROM sale.customer WHERE [state]='CA' 
GROUP BY city
HAVING COUNT(customer_id)>5 
order by Count_customer DESC

---- 3. List the top 10 most expensive products----
SELECT top 10 product_name,list_price 
FROM product.product
ORDER BY list_price DESC


---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----
SELECT A.store_id, D.product_name, C.list_price, SUM(C.quantity) AS SumQuantity
FROM sale.store A
INNER JOIN sale.orders B ON A.store_id = B.store_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
INNER JOIN product.product D ON C.product_id = D.product_id
WHERE A.store_id = 2
GROUP BY A.store_id, D.product_name, C.list_price
HAVING SUM(C.quantity) > 25
ORDER BY SumQuantity


---- 5. Find the sales order of the customers who lives in Boulder order by order date----
SELECT first_name+' ' +last_name name, city, order_date, order_id
FROM sale.customer A
INNER join sale.orders B on A.customer_id= B.customer_id
WHERE city='Boulder'
ORDER BY order_date;

---- 6. Get the sales by staffs and years using the AVG() aggregate function.
SELECT first_name+' ' +last_name name, YEAR(order_date), AVG(list_price*quantity*(1-discount)) Avg_sales
FROM sale.staff A 
inner join sale.orders B on A.staff_id= B.staff_id
INNER JOIN sale.order_item C on B.order_id= C.order_id
GROUP BY first_name+' ' +last_name, YEAR(order_date)
ORDER BY 1

---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----
SELECT brand_name, product_name, COUNT(quantity) sumquantity
FROM product.product A inner JOIN product.brand B on A.brand_id= B.brand_id
INNER join sale.order_item C on A.product_id= C.product_id
GROUP by brand_name, product_name
ORDER by 1,3 DESC


SELECT  distinct brand_name, product_name, SUM(quantity) sumquantity
FROM product.product A inner JOIN product.brand B on A.brand_id= B.brand_id
INNER join sale.order_item C on A.product_id= C.product_id
GROUP by brand_name, product_name
ORDER by 1,3 DESC


---- 8. What are the categories that each brand has?----
SELECT brand_name, category_name
FROM product.brand A inner join product.product B on A.brand_id= B.brand_id
inner join product.category C on B.category_id = C.category_id
GROUP by brand_name, category_name

---- 9. Select the avg prices according to brands and categories----
SELECT brand_name, category_name, AVG(list_price) avg_prices
FROM product.brand A inner join product.product B on A.brand_id= B.brand_id
inner join product.category C on B.category_id = C.category_id
GROUP by brand_name, category_name


---- 10. Select the annual amount of product produced according to brands----
SELECT brand_name, model_year, COUNT(product_id)  count
FROM product.brand A inner JOIN product.product B on A.brand_id=B.brand_id
GROUP by brand_name, model_year
ORDER by 1,2


---- 11. Select the store which has the most sales quantity in 2018.----
SELECT top 1 store_name, YEAR(order_date) year, SUM(quantity) sumquantity 
FROM sale.store A inner join sale.orders B on A.store_id=B.store_id
inner join sale.order_item C on B.order_id= C.order_id
WHERE YEAR(order_date)='2018'
GROUP by store_name, YEAR(order_date)
ORDER by sumquantity DESC


---- 12 Select the store which has the most sales amount in 2018.----
SELECT top 1 store_name, YEAR(order_date) year, SUM(list_price*quantity*(1-discount)) sumquantity
FROM sale.store A inner join sale.orders B on A.store_id=B.store_id
inner join sale.order_item C on B.order_id= C.order_id
WHERE YEAR(order_date)='2018'
GROUP by store_name, YEAR(order_date)
ORDER by sumquantity DESC


---- 13. Select the personnel which has the most sales amount in 2019.----
SELECT top 1 first_name+' ' +last_name name, YEAR(order_date) year, SUM(list_price*quantity*(1-discount)) sumquantity
FROM sale.staff A inner join sale.orders B on A.staff_id=B.staff_id
inner join sale.order_item C on B.order_id= C.order_id
WHERE YEAR(order_date)='2019'
GROUP by first_name+' ' +last_name, YEAR(order_date)
ORDER by sumquantity DESC
