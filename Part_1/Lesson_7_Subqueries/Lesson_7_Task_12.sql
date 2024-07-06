--Определите количество отменённых заказов в таблице courier_actions и выясните, есть ли в этой таблице такие 
--заказы, которые были отменены пользователями, но при этом всё равно были доставлены. Посчитайте количество таких --заказов.

--Колонку с отменёнными заказами назовите orders_canceled. Колонку с отменёнными, но доставленными заказами 
--назовите orders_canceled_and_delivered. 

--Поля в результирующей таблице: orders_canceled, orders_canceled_and_delivered

WITH subquery_1 AS (
    SELECT order_id 
    FROM user_actions
    WHERE action = 'cancel_order'
)
SELECT COUNT(DISTINCT order_id) AS orders_canceled,
       SUM(CASE
           WHEN action = 'deliver_order' THEN 1
           ELSE 0
           END) AS orders_canceled_and_delivered
FROM  courier_actions
WHERE order_id IN (SELECT *
                   FROM subquery_1);
