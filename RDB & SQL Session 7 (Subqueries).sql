



---Session 7


---Homework-1


--The street column has some string characters (5C, 43E, 234F, etc.) 
--that are mistakenly added to the end of the numeric characters in the first part of the street records. Remove these typos in this column. 

--street sütununda baþtaki rakamsal ifadenin sonuna yanlýþlýkla eklenmiþ string karakterleri temizleyin
--önce boþluða kadar olan kýsmý alýnýz
--sonra where ile sonunda harf olan kayýtlarý bulunuz
--bu harfi kaldýrýn



SELECT	street, REPLACE(street, SUBSTRING(street, 1, CHARINDEX(' ', street)-1), SUBSTRING(street, 1, CHARINDEX(' ', street)-2)) new_street,
		SUBSTRING(street, 1, CHARINDEX(' ', street)-1) rakam_grubu,
		SUBSTRING(street, CHARINDEX(' ', street)-1, 1) temizlenecek,
		SUBSTRING(street, 1, CHARINDEX(' ', street)-2) yeni_rakam_grubu
FROM	sale.customer
WHERE	ISNUMERIC(SUBSTRING(street, CHARINDEX(' ', street)-1, 1)) = 0









---Homework-2

--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.
-- Ýki günden geç kargolanan sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz.


CREATE VIEW v_order_day AS
SELECT	order_id, DATENAME(DW, order_date) [dayofweek]
FROM	sale.orders
WHERE	DATEDIFF(day, order_date, shipped_date) > 2



SELECT *
FROM v_order_day
PIVOT
(
COUNT(order_id)
FOR [dayofweek] 
IN	([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])
) AS PVT




SELECT *
FROM 
	(
	SELECT	order_id, DATENAME(DW, order_date) [dayofweek]
	FROM	sale.orders
	WHERE	DATEDIFF(day, order_date, shipped_date) > 2
	) AS A
PIVOT
(
COUNT(order_id)
FOR [dayofweek] 
IN	([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])
) AS PVT






---Pop-up Quizzzz

--1

--Create a report shows monthwise turnovers of the BFLO Store.


/*
		JAN	FEB	MARH
2018	256	656	22
2019
2020
*/


SELECT	B.order_id, B.order_date, C.*, quantity*list_price*(1-discount) net_price
FROM	sale.store A
		INNER JOIN
		sale.orders B
		ON A.store_id = B.store_id
		INNER JOIN
		sale.order_item C
		ON B.order_id = C.order_id
WHERE
		A.store_name = 'the BFLO Store'



-----
SELECT *
FROM
(
SELECT	YEAR(B.order_date) [Year], MONTH(B.order_date) month_num,  DATENAME(MONTH, B.order_date) [MONTH] , quantity*list_price*(1-discount) net_price
FROM	sale.store A
		INNER JOIN
		sale.orders B
		ON A.store_id = B.store_id
		INNER JOIN
		sale.order_item C
		ON B.order_id = C.order_id
WHERE
		A.store_name = 'the BFLO Store'
	) A
PIVOT
(
SUM(net_price)
FOR [Year]
IN ([2018], [2019], [2020],[2021])
) AS PVT
ORDER BY
month_num





---2

--Create a report that shows daywise turnovers by the week of the BFLO Store.




--------------/////////////////////




--------SUBQUERIES & CTE's



--Write a query that shows all employees in the store where Davis Thomas works.

-- Davis Thomas'nýn çalýþtýðý maðazadaki tüm personelleri listeleyin.


SELECT *
FROM	sale.staff
WHERE	store_id = (
					SELECT	store_id
					FROM	sale.staff
					WHERE	first_name = 'Davis'
							AND	
							last_name = 'Thomas'
					)


-----


-- /////////

-- Write a query that shows the employees for whom Charles Cussona is a first-degree manager. 
--(To which employees are Charles Cussona a first-degree manager?)
-- Charles	Cussona 'ýn yöneticisi olduðu personelleri listeleyin.

SELECT *
FROM	sale.staff
WHERE	manager_id = (
						SELECT	staff_id
						FROM	sale.staff
						WHERE	first_name = 'Charles'
								AND		
								last_name = 'Cussona'
						)

----------


-- ///////////////


-- Write a query that returns the customers located where ‘The BFLO Store' is located.
-- 'The BFLO Store' isimli maðazanýn bulunduðu þehirdeki müþterileri listeleyin.


SELECT	first_name, last_name, city
FROM	sale.customer
WHERE	city = (
					SELECT	city
					FROM	sale.store
					WHERE	store_name = 'The BFLO Store'
					)


--SELECT	first_name, last_name, A.city
--FROM	sale.customer A
--		INNER JOIN
--		sale.store B
--		ON A.city = B.city
--WHERE	store_name = 'The BFLO Store'



-------



--//////

--Write a query that returns the list of products that are more expensive than the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr.


SELECT *
FROM	product.product
WHERE	list_price > (
						SELECT	list_price
						FROM	product.product
						WHERE	product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
						) 

						
------ MULTIPLE ROW SUBQUERIES ------


--/////////////////


-- Write a query that returns customer first names, last names and order dates. 
-- The customers who are order on the same dates as Laurel Goldammer.

-- Laurel Goldammer isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.



SELECT	first_name, last_name, b.order_date
FROM	sale.customer A
		INNER JOIN
		sale.orders B
		ON A.customer_id = B.customer_id
WHERE	B.order_date IN (
							SELECT	order_date
							FROM	sale.customer A
									INNER JOIN
									sale.orders B
									ON A.customer_id = B.customer_id
							WHERE	first_name = 'Laurel'
									AND
									last_name = 'Goldammer'
							) 

---------------


SELECT z.first_name, z.last_name, y.order_date
FROM (
		SELECT	B.*
		FROM	sale.customer A
				INNER JOIN
				sale.orders B
				ON A.customer_id = B.customer_id
		WHERE	first_name = 'Laurel'
				AND
				last_name = 'Goldammer'
	) AS X
	INNER JOIN
	sale.orders Y
	ON X.order_date = Y.order_date
	INNER JOIN
	sale.customer Z
	ON Y.customer_id = Z.customer_id 




-----/////////////



--List the products that ordered in the last 10 orders in Buffalo city.
-- Buffalo þehrinde son 10 sipariþte sipariþ verilen ürünleri listeleyin.

SELECT	DISTINCT B.product_name
FROM	sale.order_item A
		INNER JOIN
		product.product B
		ON A.product_id = B.product_id
WHERE	A.order_id IN (
						SELECT	TOP 10 order_id
						FROM	sale.orders X
								INNER JOIN
								sale.customer Y
								ON X.customer_id = Y.customer_id
						WHERE	Y.city = 'Buffalo'
						ORDER BY
								order_id DESC
							)


;GO
CREATE VIEW V_MELAEMK AS
SELECT	DISTINCT B.product_name
FROM	sale.order_item A
		INNER JOIN
		product.product B
		ON A.product_id = B.product_id
WHERE	A.order_id IN (
						SELECT	TOP 10 order_id
						FROM	sale.orders X
								INNER JOIN
								sale.customer Y
								ON X.customer_id = Y.customer_id
						WHERE	Y.city = 'Buffalo'
						ORDER BY
								order_id DESC
							)

