--Используя запрос из предыдущего задания, рассчитайте суммарную стоимость каждого заказа. 
--Выведите колонки с id заказов и их стоимостью. Колонку со стоимостью заказа назовите order_price. 
--Результат отсортируйте по возрастанию id заказа.

--Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

--Поля в результирующей таблице: order_id, order_price
WITH subquery_1 AS 
(
    WITH
    o AS (
        SELECT order_id,
               unnest (product_ids) product_id
        FROM orders
        )
    SELECT o.order_id,
           o.product_id,
           p.price
    FROM o
        LEFT JOIN products p
        USING (product_id)
    ORDER BY o.order_id, o.product_id
)
SELECT subquery_1.order_id,
       SUM(subquery_1.price) order_price
FROM subquery_1
GROUP BY subquery_1.order_id
ORDER BY subquery_1.order_id
LIMIT 1000;
