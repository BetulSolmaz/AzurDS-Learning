---Grouping Operations
--Having


--product tablosunda herhangi bir product id nin coklayip coklamadigini kontrol ediniz.
SELECT COUNT(product_id), COUNT(distinct product_id)
FROM product.product

SELECT product_id, COUNT(*)
FROM product.product
GROUP BY product_id
HAVING COUNT(*)>1   --- birden cok olan product_id olmadigini gördük.


-- list_price i max >4000, min< 500 olan productlarin category_id sini getir.
SELECT category_id, MAX(list_price) maxprice, MIN(list_price) minprice
FROM product.product
GROUP BY category_id
HAVING MAX(list_price)>4000 OR MIN(list_price)<500

--- ortalama ürün fiyatlarini marka isimleri ile getir.
SELECT brand_name, AVG(list_price) AVGPrice
FROM product.product A RIGHT JOIN product.brand B ON A.brand_id= B.brand_id
GROUP BY brand_name


SELECT brand_name, AVG(list_price) AVGPrice
FROM product.product A RIGHT JOIN product.brand B ON A.brand_id= B.brand_id
GROUP BY brand_name
HAVING AVG(list_price)>1000


--bir siparişin toplam net tutarını getiriniz. (müşterinin sipariş için ödediği tutar)
--discount' ı ve quantity' yi ihmal etmeyiniz.
SELECT	order_id, SUM(quantity*list_price*(1-discount)) total_net_amount
FROM	sale.order_item
GROUP BY
		order_id


--State' lerin aylık sipariş sayılarını hesaplayınız
SELECT [state], MONTH(order_date) months,YEAR(order_date) years, COUNT(order_id) number_of_order 
FROM sale.customer A 
INNER JOIN sale.orders B 
ON A.customer_id=B.customer_id
GROUP by [state],YEAR(order_date), MONTH(order_date)
ORDER BY [state], months  ---1,2 veya 1 ASC, 2 DESC ile de gösterebiliriz.

---GROUP SETTINGS
---summary table
SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year

--- 1. sadece markaya ait toplam tutar
--- 2. sadece model yilina ait top. tutar
--- 3. marka ve model kiriliminda top.tutar
--- 4. tüm satislardan elde edilen top.tutar
SELECT Brand, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary    
GROUP BY  
        GROUPING sets (
            (Brand), (Model_Year), (Brand, Model_Year),() 
        )    
ORDER BY 1,2       

---RollUp
SELECT Brand, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary    
GROUP BY  
        rollup (Brand, Model_Year)
ORDER BY 1 DESC        

--Cube
SELECT Brand,Category, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary    
GROUP BY  
        cube (Brand,Category, Model_Year)
ORDER BY 1,2 DESC   

---PIVOT TABLE
SELECT *
FROM sale.sales_summary








