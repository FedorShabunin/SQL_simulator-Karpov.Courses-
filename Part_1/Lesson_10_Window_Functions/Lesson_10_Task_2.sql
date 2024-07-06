--Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной колонке для каждой записи 
--проставьте цену самого дорогого товара. Колонку с этим значением назовите max_price.

--Затем для каждого товара посчитайте долю его цены в стоимости самого дорогого товара — просто поделите одну колонку на другую
--Полученные доли округлите до двух знаков после запятой. Колонку с долями назовите share_of_max.

--Выведите всю информацию о товарах, включая значения в новых колонках.
--Результат отсортируйте сначала по убыванию цены товара, затем по возрастанию id товара.

--Поля в результирующей таблице: product_id, name, price, max_price, share_of_max

SELECT product_id,
       name,
       price,
       MAX(price) OVER () AS max_price,
       ROUND(price / MAX(price) OVER (),2) AS share_of_max
FROM products
ORDER BY price DESC, product_id;
