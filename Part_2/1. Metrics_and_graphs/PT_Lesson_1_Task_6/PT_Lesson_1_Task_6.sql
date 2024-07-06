--На основе данных в таблицах user_actions, courier_actions и orders для каждого дня рассчитайте следующие показатели:

--Число платящих пользователей на одного активного курьера.
--Число заказов на одного активного курьера.
--Колонки с показателями назовите соответственно users_per_courier и orders_per_courier. Колонку с датами назовите date.
--При расчёте показателей округляйте значения до двух знаков после запятой.

--Результирующая таблица должна быть отсортирована по возрастанию даты.

--Поля в результирующей таблице: date, users_per_courier, orders_per_courier

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
    ),
paying_users_count AS
    (
    SELECT time ::DATE AS date,
           COUNT(DISTINCT user_id) AS paying_users
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    GROUP BY date
    ),
active_couriers_count AS
    (
    SELECT time ::DATE AS date,
           COUNT(DISTINCT courier_id) AS active_couriers
    FROM courier_actions
    WHERE order_id IN (SELECT order_id
                       FROM delivered_orders)
    GROUP BY date
    ),
total_number_of_orders AS
    (
    SELECT time::DATE AS date,
           COUNT(DISTINCT user_actions.order_id) AS orders
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                               FROM canceled_orders)
    GROUP BY date
    )
SELECT paying_users_count.date,
       ROUND(paying_users_count.paying_users / active_couriers_count.active_couriers ::numeric, 2) AS users_per_courier,
       ROUND(total_number_of_orders.orders / active_couriers_count.active_couriers ::numeric, 2) AS orders_per_courier
FROM paying_users_count 
    LEFT JOIN active_couriers_count
    USING (date)
    LEFT JOIN total_number_of_orders
    USING (date)
ORDER BY paying_users_count.date;
