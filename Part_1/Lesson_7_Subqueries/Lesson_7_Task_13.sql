--По таблицам courier_actions и user_actions снова определите число недоставленных заказов и среди них посчитайте 
--количество отменённых заказов и количество заказов, которые не были отменены (и соответственно, пока ещё не были --доставлены).

--Колонку с недоставленными заказами назовите orders_undelivered, колонку с отменёнными заказами назовите 
--orders_canceled, 
--колонку с заказами «в пути» назовите orders_in_process.

--Поля в результирующей таблице: orders_undelivered, orders_canceled, orders_in_process

WITH subquery_1 AS (
    SELECT order_id
    FROM courier_actions
    WHERE action = 'deliver_order')
SELECT COUNT(DISTINCT order_id) AS orders_undelivered,
       SUM(CASE
           WHEN action = 'cancel_order' THEN 1
           ELSE 0
           END) AS orders_canceled,
       COUNT(DISTINCT order_id) - SUM(CASE
                                      WHEN action = 'cancel_order' THEN 1
                                      ELSE 0
                                      END) AS orders_in_process
FROM user_actions
WHERE order_id NOT IN (SELECT *
                       FROM subquery_1);
