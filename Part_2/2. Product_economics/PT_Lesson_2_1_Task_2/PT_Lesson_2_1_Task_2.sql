--Для каждого дня в таблицах orders и user_actions рассчитайте следующие показатели:
--Выручку на пользователя (ARPU) за текущий день.
--Выручку на платящего пользователя (ARPPU) за текущий день.
--Выручку с заказа, или средний чек (AOV) за текущий день.
--Колонки с показателями назовите соответственно arpu, arppu, aov. Колонку с датами назовите date. 
--При расчёте всех показателей округляйте значения до двух знаков после запятой.
--Результат должен быть отсортирован по возрастанию даты. 
--Поля в результирующей таблице: date, arpu, arppu, aov

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
not_canceled_orders AS
    (
    SELECT order_id,
           UNNEST(product_ids) AS product_id,
           creation_time ::DATE AS date
    FROM orders
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    ),
revenue_per_day AS
    (
    SELECT not_canceled_orders.date,
           SUM(products.price) AS revenue
    FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
    GROUP BY date
    ),
users_orders AS
    (
    SELECT time ::DATE AS date,
           COUNT(DISTINCT order_id) AS number_orders,
           COUNT(DISTINCT user_id) AS number_pay_users
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    GROUP BY time ::DATE
    ),
all_users AS
    (
    SELECT time ::DATE AS date,
           COUNT(DISTINCT user_id) AS number_users
    FROM user_actions
    GROUP BY time ::DATE
    )
 SELECT revenue_per_day.date,
        ROUND(revenue_per_day.revenue ::numeric / all_users.number_users, 2) AS arpu,
        ROUND(revenue_per_day.revenue ::numeric / users_orders.number_pay_users, 2) AS arppu,
        ROUND(revenue_per_day.revenue ::numeric / users_orders.number_orders, 2) AS aov
FROM revenue_per_day
LEFT JOIN users_orders
USING (date)
LEFT JOIN all_users
USING (date)
ORDER BY revenue_per_day.date
