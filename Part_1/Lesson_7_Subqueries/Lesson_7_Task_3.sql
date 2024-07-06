--Выведите из таблицы products информацию о всех товарах кроме самого дешёвого.

--Результат отсортируйте по убыванию id товара.

--Поля в результирующей таблице: product_id, name, price

WITH subquery_1 AS (SELECT MIN(price)
                    FROM   products)
SELECT product_id,
       name,
       price
FROM   products
WHERE  price != (SELECT *
                 FROM   subquery_1)
ORDER BY product_id DESC;
