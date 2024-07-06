--Используя функцию unnest, определите 10 самых популярных товаров в таблице orders.

--Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. Если товар встречается в --одном заказе несколько раз (когда было куплено несколько единиц товара), это тоже учитывается при подсчёте. 
--Учитывайте только неотменённые заказы.

--Выведите id товаров и то, сколько раз они встречались в заказах (то есть сколько раз были куплены). Новую колонку --с количеством покупок товаров назовите times_purchased.

--Результат отсортируйте по возрастанию id товара.

--Поля в результирующей таблице: product_id, times_purchased

WITH 
subquery_1 AS (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
subquery_2 AS (
    SELECT UNNEST(product_ids) AS product_id,
           COUNT(*) AS times_purchased
    FROM orders
    WHERE order_id NOT IN (SELECT *
                           FROM subquery_1)
    GROUP BY UNNEST(product_ids)
    ORDER BY COUNT(*) DESC
    LIMIT 10
    )
SELECT product_id,
       times_purchased
FROM subquery_2
ORDER BY product_id;
