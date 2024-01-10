


SELECT top 5 * FROM product.product ORDER BY list_price DESC

SELECT * FROM product.product WHERE model_year> 2018 and list_price > 2000


SELECT * FROM product.product WHERE (model_year> 2018 or list_price > 2000) and brand_id=4
--or ve and kullanirken parantez kullanmak daha saglikli olur.

SELECT * FROM product.product WHERE model_year not in (2018,1029)

SELECT * FROM product.product WHERE product_name LIKE '%Sams___%';

-- Date functions
-- Data Types
CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT * FROM t_date_time    

SELECT GETDATE()

INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

SELECT GETDATE()
SELECT DAY(GETDATE()) as [DAY]
SELECT MONTH(GETDATE()) as [MONTH]
SELECT DATENAME(Weekday ,GETDATE())
SELECT DATENAME(MONTH ,GETDATE())


SELECT GETDATE()
SELECT DATEPART(MONTH, GETDATE())

---DATEDIFF

SELECT DATEDIFF(MINUTE, '2024-01-10 09:30:06.970', GETDATE())

SELECT DATEDIFF(YEAR, '1985-10-28', GETDATE())

---DATEADD
SELECT GETDATE()
SELECT DATEADD (HOUR,5, GETDATE())

SELECT order_date, DATEADD(day, 5, order_date) as nachfünf  FROM sale.orders;


---endmonth
SELECT EOMONTH(GETDATE(), 1)
SELECT EOMONTH('2023-02-01')

-----ISDATE
SELECT ISDATE('123456')
SELECT ISDATE('2011-3-21')
SELECT ISDATE('17/3/2024')---- gün-ay-yil i tarih olarak kabul etmedi. YMD veya MDY kabul ediyor.


SELECT *,DATEDIFF(day, order_date ,shipped_date) Daydiff  FROM sale.orders where DATEDIFF(day, order_date ,shipped_date)>2

---String functions---
SELECT CAST('ali' as char(10))
SELECT CAST('ali' as varchar(10))     

---LEN
SELECT LEN(' Betül')  --bastaki ve aradaki bosluklari sayar ama sondakini saymaz, .,;- bu karakterleri sayar

---charindex
SELECT CHARINDEX('r', 'Ömer Serdar')
SELECT CHARINDEX('r', 'Ömer Serdar', 5)
SELECT CHARINDEX('er', 'Ömer Serdar')

---PATINDEX
SELECT PATINDEX('%er%', 'Ömer Serdar')

---LEFT RIGHT SUBSTRING FUNCTIONS bu fonksiyonlar veri temizlemede isimize yarar.
SELECT LEFT('Elif', 2)
SELECT RIGHT('Elif', 2)
SELECT SUBSTRING('matthew connor', 3, 5)

---LOWER, UPPER, STRING-SPLIT
SELECT LOWER('MERVE')
SELECT UPPER('merve')
SELECT * FROM string_split('Edwin, Mateo, Owen', ',')

---SELECT CONCAT('c', 'a')
SELECT UPPER(SUBSTRING('character',1,1))+ LOWER(SUBSTRING('character',2,8)) 

--TRIM, LTRIM, RTRIM 
SELECT TRIM ('   diane  ')
diane
SELECT LTRIM ('   diane  ')
diane  
SELECT RTRIM ('   diane  ')
   diane

---REPLACE VE STR
SELECT REPLACE('character string', ' ', '-')
SELECT STR(5424) --- on karakterlik yer ayiriyor default olarak
SELECT STR(5424, 4) --böyle sayi verirsek o kadar yer ayirir.

---CAST, CONVERT
SELECT CAST(1234.567 AS varchar(15)) --- veri tiplerini dönüstürür.
SELECT CAST(1234.567 AS int)

SELECT CONVERT(numeric(5,2), 256.9874)
SELECT CONVERT(varchar(20), GETDATE(), 100)

--- ROUND
SELECT ROUND(122.545, 1)
SELECT ROUND(122.599, 1,0)
SELECT ROUND(122.599, 1, 1)  --sondaki bir son rakamlari 0 saymasina yariyor. ilk rakam ise , den sonra kac deger alacak onu gösteriyor.

SELECT ISNULL(phone, 5555555555555), phone FROM sale.customer


----COALESCE, NULLIF, ISNUMERIC
SELECT COALESCE(NULL, NULL, 78,456)

SELECT COALESCE(phone, email), phone, email FROM sale.customer -- null olmayan veriyi getirir.

SELECT *, NULLIF(state, 'NC')
from sale.customer

SELECT ISNUMERIC(5)