--Для каждого дня, представленного в таблице user_actions, рассчитайте следующие показатели:

--Общее число заказов.
--Число первых заказов (заказов, сделанных пользователями впервые).
--Число заказов новых пользователей (заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом).
--Долю первых заказов в общем числе заказов (долю п.2 в п.1).
--Долю заказов новых пользователей в общем числе заказов (долю п.3 в п.1).
--Колонки с показателями назовите соответственно orders, first_orders, new_users_orders, first_orders_share,
--new_users_orders_share. Колонку с датами назовите date.
--Проследите за тем, чтобы во всех случаях количество заказов было выражено целым числом.
--Все показатели с долями необходимо выразить в процентах. При расчёте долей округляйте значения до двух знаков после запятой.

--Результат должен быть отсортирован по возрастанию даты.

--Поля в результирующей таблице: date, orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
min_date_user AS
    (
    SELECT user_id,
           MIN(time) ::DATE AS date
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    GROUP BY user_id
    ),
min_date_user_full AS
    (
    SELECT user_id,
           MIN(time) ::DATE AS date
    FROM user_actions
    GROUP BY user_id
    ),
not_canceled_orders AS
    (
    SELECT time ::DATE AS date,
           user_id,
           order_id
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    ),
total_number_of_orders AS
    (
    SELECT time::DATE AS date,
           COUNT(DISTINCT user_actions.order_id) AS orders
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                               FROM canceled_orders)
    GROUP BY date
    ),
number_of_first_orders AS
    (
    SELECT min_date_user.date,
           COUNT(DISTINCT min_date_user.user_id) AS first_orders
    FROM min_date_user
    GROUP BY min_date_user.date
    ),
number_of_new_users_orders AS
    (
    SELECT min_date_user_full.date,
           COUNT(DISTINCT not_canceled_orders.order_id) AS new_users_orders
    FROM min_date_user_full
        LEFT JOIN not_canceled_orders
        ON min_date_user_full.date = not_canceled_orders.date
        AND min_date_user_full.user_id = not_canceled_orders.user_id
    GROUP BY min_date_user_full.date
    )
SELECT total_number_of_orders.date,
       total_number_of_orders.orders,
       number_of_first_orders.first_orders,
       number_of_new_users_orders.new_users_orders,
       ROUND(100 * number_of_first_orders.first_orders / total_number_of_orders.orders ::numeric, 2) AS first_orders_share,
       ROUND(100 * number_of_new_users_orders.new_users_orders / total_number_of_orders.orders ::numeric, 2) AS new_users_orders_share
FROM total_number_of_orders
    LEFT JOIN number_of_first_orders
    USING (date)
    LEFT JOIN number_of_new_users_orders
    USING (date)
ORDER BY total_number_of_orders.date;
