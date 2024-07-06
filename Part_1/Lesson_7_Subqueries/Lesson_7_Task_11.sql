--Выясните, есть ли в таблице courier_actions такие заказы, которые были приняты курьерами, но не были доставлены --пользователям. Посчитайте количество таких заказов.

--Колонку с числом заказов назовите orders_count.

--Поле в результирующей таблице: orders_count

WITH subquery_1 AS (
    SELECT order_id
    FROM courier_actions
    WHERE action = 'deliver_order'
)
SELECT COUNT(order_id) AS orders_count
FROM courier_actions
WHERE order_id NOT IN (SELECT *
                       FROM subquery_1);
