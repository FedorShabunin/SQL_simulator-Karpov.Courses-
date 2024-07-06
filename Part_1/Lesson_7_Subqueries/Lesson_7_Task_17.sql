--Рассчитайте средний размер заказов, отменённых пользователями мужского пола.

--Средний размер заказа округлите до трёх знаков после запятой. Колонку со значением назовите avg_order_size.

--Поле в результирующей таблице: avg_order_size

WITH 
subquery_1 AS (
    SELECT user_id
    FROM users
    WHERE sex = 'male'
    ),
subquery_2 AS (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
        AND user_id IN (SELECT *
                        FROM subquery_1)
    )
SELECT ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 3) AS avg_order_size
FROM orders
WHERE order_id IN (SELECT *
                  FROM subquery_2);
