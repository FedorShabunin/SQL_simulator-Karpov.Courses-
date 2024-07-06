--На основе данных в таблице orders для каждого часа в сутках рассчитайте следующие показатели:

--Число успешных (доставленных) заказов.
--Число отменённых заказов.
--Долю отменённых заказов в общем числе заказов (cancel rate).
--Колонки с показателями назовите соответственно successful_orders, canceled_orders, cancel_rate.
--Колонку с часом оформления заказа назовите hour.
--При расчёте доли отменённых заказов округляйте значения до трёх знаков после запятой.

--Результирующая таблица должна быть отсортирована по возрастанию колонки с часом оформления заказа.

--Поля в результирующей таблице: hour, successful_orders, canceled_orders, cancel_rate

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
delivered_orders AS
    (
    SELECT order_id
    FROM courier_actions
    WHERE action = 'deliver_order' 
    )
SELECT EXTRACT(HOUR from orders.creation_time) ::int AS hour,
       COUNT(delivered_orders.order_id) AS successful_orders,
       COUNT(canceled_orders.order_id) AS canceled_orders,
       ROUND(COUNT(canceled_orders.order_id) / COUNT(orders.order_id) ::numeric, 3) AS cancel_rate
FROM orders
    LEFT JOIN canceled_orders
    USING (order_id)
    LEFT JOIN delivered_orders
    USING (order_id)
GROUP BY hour
ORDER BY hour;
