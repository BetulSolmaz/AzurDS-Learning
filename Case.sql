---UNION

--- Charlotte sehrinde satilan ürünler ile Aurora sehrinde satilan ürünleri listeleyin.
SELECT product_name
from sale.customer c 
inner join sale.orders o on c.customer_id=o.customer_id
INNER JOIN sale.order_item oi on o.order_id= oi.order_id
INNER JOIN product.product p on oi.product_id= p.product_id
WHERE city='Charlotte'

UNION

SELECT product_name
from sale.customer c 
inner join sale.orders o on c.customer_id=o.customer_id
INNER JOIN sale.order_item oi on o.order_id= oi.order_id
INNER JOIN product.product p on oi.product_id= p.product_id
WHERE city='Aurora'

---
SELECT p.product_name
FROM sale.customer c, sale.orders o, sale.order_item oi, product.product p 
WHERE c.customer_id= o.customer_id
and o.order_id=oi.order_id
and oi.product_id= p.product_id
and city='Charlotte'

UNION ALL

SELECT p.product_name
FROM sale.customer c, sale.orders o, sale.order_item oi, product.product p 
WHERE c.customer_id= o.customer_id
and o.order_id=oi.order_id
and oi.product_id= p.product_id
and city='Aurora'

--- solution with IN operator

SELECT distinct product_name
from sale.customer c 
inner join sale.orders o on c.customer_id=o.customer_id
INNER JOIN sale.order_item oi on o.order_id= oi.order_id
INNER JOIN product.product p on oi.product_id= p.product_id
WHERE city IN ('Charlotte', 'Aurora')

--Some Important rules of UNION/UNION ALL
---sütunlarin icerigi farkli da olsa veri tipinin ayni olmasi gerekir.

SELECT brand_id
FROM product.brand
UNION
SELECT category_id
from product.category   --birlestirdik ama bi anlami yok.

SELECT brand_name
FROM product.brand
UNION ALL
SELECT category_id
from product.category   --- veri tipi farkli, hata verir.


---sütun sayilari ayni olmali
SELECT * 
FROM product.brand

UNION ALL

SELECT category_id
FROM product.category  --sütun sayisi ayni olmadigindan hata verdi.

--Farkli bir database den aldigimiz result i birlestirebiliriz.

--adi veya soyadi thomas olan tüm müsterileri getirin.

SELECT first_name, last_name
from sale.customer
WHERE first_name= 'Thomas'
UNION ALL
 SELECT first_name, last_name
from sale.customer
WHERE last_name= 'Thomas'

---INTERSECT---
--model yili hem 2018 hem 2020 olan ürünlere sahip olan tüm markalr döndüren sorgu

SELECT a.brand_id, b.brand_name
FROM product.product a, product.brand b
WHERE model_year=2018 and a.brand_id=b.brand_id
INTERSECT
SELECT a.brand_id, b.brand_name
FROM product.product a, product.brand b
WHERE model_year=2020 and a.brand_id=b.brand_id


SELECT *
FROM product.brand
WHERE brand_id IN (
    SELECT brand_id
FROM product.product
WHERE model_year=2018 
INTERSECT
SELECT brand_id
FROM product.product
WHERE model_year=2020  --- alternatif cözüm
)

--- 2018, 2019, 2020 de siparis veren müsteriler
SELECT a.customer_id, first_name, last_name
FROM sale.orders a, sale.customer b
WHERE YEAR(order_date)= 2018 and a.customer_id=b.customer_id
INTERSECT
SELECT a.customer_id, first_name, last_name
FROM sale.orders a, sale.customer b
WHERE YEAR(order_date)= 2019 and a.customer_id=b.customer_id
INTERSECT
SELECT a.customer_id, first_name, last_name
FROM sale.orders a, sale.customer b
WHERE YEAR(order_date)= 2020 and a.customer_id=b.customer_id

SELECT first_name, last_name
FROM sale.customer
WHERE customer_id IN(
    SELECT customer_id
FROM sale.orders 
WHERE YEAR(order_date)= 2018 
INTERSECT
    SELECT customer_id
FROM sale.orders 
WHERE YEAR(order_date)= 2019
INTERSECT
    SELECT customer_id
FROM sale.orders 
WHERE YEAR(order_date)= 2020 ---alternatif cözüm
)

---EXCEPT--
--2018 modeli olanlarin hangilerinin 2019 u yoktur?
SELECT brand_id, brand_name
from product.brand
WHERE brand_id IN (
SELECT brand_id
FROM product.product 
WHERE model_year=2018

EXCEPT

SELECT brand_id
FROM product.product 
WHERE model_year=2019  )

---sadece 2019 yilinda siparis edilen diger yillarda siparis edilmeyen ürünler
SELECT p.product_id, product_name
FROM sale.orders o 
inner join sale.order_item oi on o.order_id= oi.order_id
INNER JOIN product.product p on oi.product_id=p.product_id
WHERE YEAR(o.order_date)=2019

EXCEPT

SELECT oi.product_id, product_name
FROM sale.orders o 
inner join sale.order_item oi on o.order_id= oi.order_id
INNER JOIN product.product p on oi.product_id=p.product_id
WHERE YEAR(o.order_date)<>2019
 ---except unique degerler döndürür.

---CASE---
---order-status isimli alandaki degerlerin ne anlama geldigini iceren yeni bir alan, column  olustur.

SELECT*
FROM sale.orders

SELECT order_id, order_status,
        CASE order_status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Completed'
        END order_status_desc
FROM sale.orders             


--- Create a new column with the names of the stores to be consistent with the values in the store_ids column
SELECT first_name, last_name,
        CASE store_id
            WHEN 1 THEN 'Davi techno Retail'
            WHEN 2 THEN 'The BFLO Store'
            WHEN 3 THEN 'Burkers Outler'
            
        END store_name
FROM sale.staff             


---Searched Case---
SELECT order_id,order_status,
    CASE 
        WHEN order_status=1 THEN 'Pending'
        WHEN order_status=2 THEN 'Processing'
        WHEN order_status=3 THEN 'Rejected'
        WHEN order_status=4 THEN 'Completed'
    END    
FROM sale.orders;

SELECT first_name,last_name,email,
    CASE 
        WHEN email LIKE '%@gmail.' THEN 'Gmail'
        WHEN email LIKE '%@hotmail.' THEN 'Hotmail'
        WHEN email LIKE '%@yahoo.' THEN 'Yahoo'
        WHEN email is not null THEN 'Others'
        else null
    END  email_service_provider  
FROM sale.customer

SELECT first_name,last_name,email,
   LEN( CASE 
        WHEN email LIKE '%@gmail.' THEN 'Gmail'
        WHEN email LIKE '%@hotmail.' THEN 'Hotmail'
        WHEN email LIKE '%@yahoo.' THEN 'Yahoo'
        WHEN email is not null THEN 'Others'
    END ) email_service_provider  
FROM sale.customer

--group by ile kullanimi
SELECT COUNT(customer_id)
FROM sale.customer
GROUP BY  CASE 
        WHEN email LIKE '%@gmail.' THEN 'Gmail'
        WHEN email LIKE '%@hotmail.' THEN 'Hotmail'
        WHEN email LIKE '%@yahoo.' THEN 'Yahoo'
        WHEN email is not null THEN 'Others'
        else null
    END


---ayni sipariste hem mp4 player hem computer Accesories hem de speaker kategorilerinde ürün siparisi veren müsterileri bulun.

SELECT a.customer_id, a.first_name, A.last_name, C.order_id,
    sum(CASE  WHEN e.category_name='Computer Accessories' then 1 else 0 end) comp_accessories,
    sum(CASE  WHEN e.category_name='Speakers' then 1 else 0 end) speakers,
    sum(CASE  WHEN e.category_name='mp4 player' then 1 else 0 end) mp4

FROM sale.customer A, sale.orders B, sale.order_item C, product.product D, product.category E 
WHERE A.customer_id=B.customer_id
and B.order_id=C.order_id
and C.product_id=D.product_id
and D.category_id= E.category_id
GROUP by a.customer_id, a.first_name, A.last_name, C.order_id
HAVING 
     sum(CASE  WHEN e.category_name='Computer Accessories' then 1 else 0 end)<>0 
   and sum(CASE  WHEN e.category_name='Speakers' then 1 else 0 end)<>0
   and sum(CASE  WHEN e.category_name='mp4 player' then 1 else 0 end)<>0
ORDER BY 4





SELECT first_name, last_name
FROM (
    SELECT a.customer_id, a.first_name, A.last_name, C.order_id,
    sum(CASE  WHEN e.category_name='Computer Accessories' then 1 else 0 end) comp_accessories,
    sum(CASE  WHEN e.category_name='Speakers' then 1 else 0 end) speakers,
    sum(CASE  WHEN e.category_name='mp4 player' then 1 else 0 end) mp4

FROM sale.customer A, sale.orders B, sale.order_item C, product.product D, product.category E 
WHERE A.customer_id=B.customer_id
and B.order_id=C.order_id
and C.product_id=D.product_id
and D.category_id= E.category_id
GROUP by a.customer_id, a.first_name, A.last_name, C.order_id

) T
WHERE comp_accessories>0
and speakers>0
and mp4>0
