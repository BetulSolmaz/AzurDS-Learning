---1.soru: yahoo.com olanlarin sayisi

SELECT COUNT(*)
FROM sale.customer
WHERE email LIKE '%yahoo%';

SELECT * from sale.customer

SELECT COUNT(DISTINCT customer_id)
FROM sale.customer
WHERE email LIKE '%yahoo%';

--2.soru: 
SELECT SUBSTRING(email,1, CHARINDEX('@', email)-1) 
FROM  sale.customer

SELECT LEFT(email, CHARINDEX('@', email)-1) 
FROM  sale.customer

--3.Soru

SELECT COALESCE(phone, email) as contact, phone, email FROM sale.customer -- coalesce yerine isnull da kullanilir. 
                                                                           --farki, isnull da sadece iki parametre yazabiliriz.

--4.Soru
SELECT SUBSTRING(street, 3,1), street FROM sale.customer    
where isnumeric(SUBSTRING(street, 3,1))=1   


--JOINS
--- Inner JOIN (yazim cesitleri)
SELECT product_id, product_name, product.product.category_id, category_name
FROM product.product
INNER JOIN product.category ON product.product.category_id= product.category.category_id

SELECT product_id, product_name, product.product.category_id, category_name
FROM product.product
JOIN product.category ON product.product.category_id= product.category.category_id  ---inner yazmasak da olur.

SELECT product_id, product_name, A.category_id, category_name
FROM product.product as A
INNER JOIN product.category as B ON A.category_id= B.category_id

SELECT product_id, product_name, A.category_id, category_name
FROM product.product as A, product.category as B 
WHERE A.category_id= B.category_id --AND

SELECT first_name, last_name, store_name
FROM sale.staff as A
INNER JOIN sale.store as B ON A.store_id= B.store_id

--Left Join
-- hic siparis verilmemis ürünler
SELECT COUNT(distinct product_id)
FROM sale.order_item

SELECT  A.product_id, B.order_id FROM product.product A
LEFT JOIN sale.order_item B ON A.product_id=B.product_id
WHERE order_id is NULL


-- product_id si 310 dan büyük olan ürün bilgilerini stok miktarları ile birlikte listeleyin
---beklenen: product tablosunda olup stok bilgisi olmayan ürünleri de görmek.

SELECT Distinct A.product_id, product_name, quantity, B.product_id FROM product.product A
LEFT JOIN product.stock B ON A.product_id=B.product_id
WHERE A.product_id>310


---Right JOIN
SELECT Distinct A.product_id, product_name,B.* FROM product.stock A
RIGHT JOIN product.product B ON A.product_id=B.product_id
WHERE B.product_id>310

-- farkli tablolardan farkli ürünleri böyle sayabilirirz.
--SELECT	COUNT(DISTINCT A.product_id), COUNT(DISTINCT B.product_id)
--FROM	product.stock B
--		RIGHT JOIN
--		product.product A
--		ON A.product_id = B.product_id
--WHERE	A.product_id > 310


SELECT  B.staff_id, first_name, last_name,A.* FROM sale.orders A
RIGHT JOIN sale.staff B ON A.staff_id=B.staff_id


--SELECT	A.staff_id, A.first_name, A.last_name, COUNT(order_id)
--FROM	sale.orders B
--		RIGHT JOIN
--		sale.staff A
--		ON B.staff_id = A.staff_id
--GROUP BY
--		A.staff_id, A.first_name, A.last_name


---Full Outer Join
--- ürünlerin stok miktarlari ve siparis bilgilerini birlikte listele

SELECT TOP 100 A.product_id, A.product_name, B.*, C.order_id 
FROM product.product A FULL OUTER JOIN product.stock B on A.product_id=B.product_id
full OUTER JOIN sale.order_item C on A.product_id=C.product_id
ORDER BY B.product_id, C.product_id 


---Cross Join
SELECT B.store_id, A.product_id, 0 as quantity
FROM product.product A CROSS JOIN sale.store B
WHERE A.product_id not IN (select product_id from product.stock)   

-- Self Join
SELECT
    A.first_name,   
    B.first_name AS manager_name
    FROM sale.staff A
    LEFT JOIN sale.staff B ON B.staff_id = A.manager_id;

--VIEW
CREATE VIEW ORDER_CUSTOMER AS
SELECT A.*, B.city, B.[state]
FROM sale.orders a INNER JOIN sale.customer B on A.customer_id=B.customer_id
WHERE order_date <= '2018-01-31';