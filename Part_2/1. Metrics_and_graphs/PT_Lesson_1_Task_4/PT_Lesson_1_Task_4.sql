--Для каждого дня, представленного в таблице user_actions, рассчитайте следующие показатели:

--Долю пользователей, сделавших в этот день всего один заказ, в общем количестве платящих пользователей.
--Долю пользователей, сделавших в этот день несколько заказов, в общем количестве платящих пользователей.
--Колонки с показателями назовите соответственно single_order_users_share, several_orders_users_share.
--Колонку с датами назовите date. Все показатели с долями необходимо выразить в процентах.
--При расчёте долей округляйте значения до двух знаков после запятой.

--Результат должен быть отсортирован по возрастанию даты.

--Поля в результирующей таблице: date, single_order_users_share, several_orders_users_share

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
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
orders_per_day AS
    (
    SELECT user_id,
           time ::DATE AS date,
           COUNT(DISTINCT order_id) AS number_of_orders
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    GROUP BY time ::DATE, user_id
    ),
number_of_users AS
    (
    SELECT date,
       SUM(CASE
           WHEN number_of_orders = 1 THEN 1
           ELSE 0
           END) AS single_orders,
       SUM(CASE
           WHEN number_of_orders > 1 THEN 1
           ELSE 0
           END) AS several_orders
    FROM orders_per_day
    GROUP BY date
    )
SELECT number_of_users.date,
       ROUND(100 * number_of_users.single_orders / paying_users_count.paying_users ::numeric, 2) AS single_order_users_share,
       ROUND(100 * number_of_users.several_orders / paying_users_count.paying_users ::numeric, 2) AS several_orders_users_share
FROM number_of_users
    LEFT JOIN paying_users_count
    USING (date)
    ORDER BY number_of_users.date;
