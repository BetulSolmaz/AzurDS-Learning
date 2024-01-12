SELECT * FROM INFORMATION_SCHEMA.TABLES
--1
SELECT city, count(customer_id) CountCustomer
FROM sale.customer
WHERE state = 'TX'
GROUP BY city



SELECT *
FROM sale.customer


--2
SELECT city, count(customer_id) CountCustomer
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING count(customer_id) > 5
ORDER BY CountCustomer desc; 


--3
SELECT TOP 10 product_id, product_name, list_price
FROM product.product
ORDER BY list_price desc;

--4
SELECT store_id, product_name,list_price, quantity
FROM product.stock A
INNER JOIN product.product B ON A.product_id = B.product_id
WHERE store_id = 2 AND quantity > 25
ORDER BY quantity


SELECT A.store_id, D.product_name, C.list_price, SUM(C.quantity) AS SumQuantity
FROM sale.store A
INNER JOIN sale.orders B ON A.store_id = B.store_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
INNER JOIN product.product D ON C.product_id = D.product_id
WHERE A.store_id = 2
GROUP BY A.store_id, D.product_name, C.list_price
HAVING SUM(C.quantity) > 25
ORDER BY SumQuantity

--5
SELECT first_name+' '+last_name name, city, order_date, order_id
FROM sale.customer A
INNER JOIN sale.orders B ON A.customer_id = B.customer_id
WHERE city = 'Boulder'
ORDER BY order_date


SELECT A.first_name + ' ' + A.last_name, A.city, B.order_date, B.order_id
FROM sale.customer A
LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
WHERE A.city = 'Boulder' AND B.order_date IS NOT NULL
GROUP BY A.first_name + ' ' + A.last_name, A.city, B.order_date, B.order_id
ORDER BY B.order_date;

--6
SELECT first_name+' '+last_name name, YEAR(order_date) YEAR, AVG(list_price*quantity*(1-discount)) AvgSale
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id = B.staff_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
GROUP BY first_name+' '+last_name, YEAR(order_date)
ORDER BY 1

SELECT A.first_name + ' ' + A.last_name, YEAR(B.order_date) Year, AVG(C.list_price * (1-C.discount) * C.quantity) Avg_Sales
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id = B.staff_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
GROUP BY A.first_name + ' ' + A.last_name, YEAR(B.order_date)
ORDER BY A.first_name + ' ' + A.last_name, YEAR(B.order_date)

--7
SELECT brand_name, product_name, SUM(quantity) SumQuantity
FROM product.product A
INNER JOIN product.brand B ON A.brand_id = B.brand_id
INNER JOIN sale.order_item C ON A.product_id = C.product_id
GROUP BY brand_name, product_name
ORDER BY 1,3 DESC;


SELECT b.[brand_name], p.product_name, COUNT(o.[quantity]) [Sales Quantitiy of Product]
FROM [product].[brand] b
INNER JOIN [product].[product] p ON b.brand_id = p.brand_id
INNER JOIN [sale].[order_item] o ON p.product_id = o.product_id
GROUP BY b.brand_name, p.product_name
ORDER BY 1, [Sales Quantitiy of Product] DESC;

SELECT	distinct brand_name, product_name, sum(quantity) sale_qua
FROM	product.product A, sale.order_item B,product.brand C
where A.product_id=B.product_id and A.brand_id=C.brand_id
group by brand_name, product_name
order by 3 desc

--8
SELECT brand_name, category_name
FROM product.brand A
INNER JOIN product.product B ON A.brand_id = B.brand_id
INNER JOIN product.category C ON B.category_id = C.category_id
GROUP BY brand_name, category_name;

SELECT b.[brand_name], c.[category_name]
FROM [product].[brand] b
INNER JOIN [product].[product] p ON b.brand_id = p.brand_id
INNER JOIN [product].[category] c ON p.category_id = c.category_id
GROUP BY b.brand_name, c.category_name
ORDER BY b.[brand_name]

SELECT b.[brand_name], COUNT(DISTINCT c.category_id) AS Num_Categories
FROM [product].[brand] b
INNER JOIN [product].[product] p ON b.brand_id = p.brand_id
INNER JOIN [product].[category] c ON p.category_id = c.category_id
GROUP BY b.brand_name

--9
SELECT brand_name, category_name, AVG(list_price) AvgPrice
FROM product.brand A
INNER JOIN product.product B ON A.brand_id = B.brand_id
INNER JOIN product.category C ON B.category_id = C.category_id
GROUP BY brand_name, category_name;

--10
SELECT brand_name, model_year, COUNT(product_name) CountProduct
FROM product.product A
INNER JOIN product.brand B ON A.brand_id = B.brand_id
GROUP BY brand_name, model_year
ORDER BY 1, 2


SELECT p.[model_year], b.[brand_name], COUNT(p.[product_name]) AS Annual_Amount
FROM [product].[brand] b
INNER JOIN [product].[product] p ON b.brand_id = p.brand_id
GROUP BY p.[model_year],b.[brand_name]
ORDER BY p.[model_year]


SELECT b.[brand_name], p.[model_year], COUNT(p.[product_name]) AS Annual_Amount
FROM [product].[brand] b
INNER JOIN [product].[product] p ON b.brand_id = p.brand_id
GROUP BY b.[brand_name], p.[model_year]
ORDER BY b.[brand_name], p.[model_year]

--11
SELECT TOP 1 store_name, YEAR(order_date) YEAR, Sum(quantity) SumQuantity
FROM sale.store A
INNER JOIN sale.orders B ON A.store_id = B.store_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
WHERE YEAR(order_date) = '2018'
GROUP BY store_name, YEAR(order_date)
ORDER BY SumQuantity DESC;

SELECT TOP 1 s.[store_name], SUM(i.[quantity])
FROM [sale].[store] s
INNER JOIN [sale].[orders] o ON s.store_id = o.store_id
INNER JOIN [sale].[order_item] i ON o.order_id = i.order_id
WHERE  DATENAME(YEAR, o.[order_date]) = '2018' -- year(o.[order_date])
GROUP BY s.[store_name] 
ORDER BY SUM(i.[quantity]) DESC;

--12
SELECT TOP 1 store_name, YEAR(order_date) YEAR, Sum(list_price * (1-C.discount) * C.quantity) SumQuantity
FROM sale.store A
INNER JOIN sale.orders B ON A.store_id = B.store_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
WHERE YEAR(order_date) = '2018'
GROUP BY store_name, YEAR(order_date)
ORDER BY SumQuantity DESC;

SELECT TOP 1 s.[store_name], SUM(i.list_price * (1 - i.discount) * i.quantity) AS sales_amount_2018
FROM [sale].[store] s
INNER JOIN [sale].[orders] o ON s.store_id = o.store_id
INNER JOIN [sale].[order_item] i ON o.order_id = i.order_id
WHERE  DATENAME(YEAR, o.[order_date]) = '2018' -- year(o.[order_date])
GROUP BY s.[store_name] 
ORDER BY SUM(i.[list_price]) DESC;

--13
SELECT TOP 1 A.first_name + ' ' + A.last_name, YEAR(order_date) YEAR, Sum(list_price * (1-C.discount) * C.quantity) SumQuantity
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id = B.staff_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
WHERE YEAR(order_date)= '2019'
GROUP BY first_name + ' ' + A.last_name, YEAR(order_date)
ORDER BY 1,2 DESC;

SELECT TOP 1 s.first_name + ' ' + s.last_name, SUM(i.list_price * (1 - i.discount) * i.quantity) AS sales_amount_2019
FROM [sale].[staff] s
INNER JOIN [sale].[orders] o ON s.store_id = o.store_id
INNER JOIN [sale].[order_item] i ON o.order_id = i.order_id
WHERE  DATENAME(YEAR, o.[order_date]) = '2019' -- year(o.[order_date])
GROUP BY s.first_name + ' ' + s.last_name 
ORDER BY 1,2 DESC;
