--По таблицам orders и user_actions для каждого дня рассчитайте следующие показатели:
--Накопленную выручку на пользователя (Running ARPU).
--Накопленную выручку на платящего пользователя (Running ARPPU).
--Накопленную выручку с заказа, или средний чек (Running AOV).
--Колонки с показателями назовите соответственно running_arpu, running_arppu, running_aov. Колонку с датами назовите date. 
--При расчёте всех показателей округляйте значения до двух знаков после запятой.
--Результат должен быть отсортирован по возрастанию даты. 
--Поля в результирующей таблице: date, running_arpu, running_arppu, running_aov

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
           COUNT(DISTINCT order_id) AS number_orders,
           SUM(products.price) AS revenue
    FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
    GROUP BY date
    ),
min_date_paying_users AS
    (
    SELECT user_id,
           MIN(time ::DATE) AS date
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    GROUP BY user_id
    ),
paying_users AS
    (
    SELECT date,
           COUNT(DISTINCT user_id) AS new_pay_users
    FROM min_date_paying_users
    GROUP BY date
    ),
min_date_all_users AS
    (
    SELECT user_id,
           MIN(time ::DATE) AS date
    FROM user_actions
    GROUP BY user_id
    ),
all_users AS
    (
    SELECT date,
           COUNT(DISTINCT user_id) AS new_users
    FROM min_date_all_users
    GROUP BY date
    )
 SELECT revenue_per_day.date,
        ROUND((SUM(revenue_per_day.revenue) OVER (ORDER BY date))::numeric / (SUM(all_users.new_users) OVER (ORDER BY date)), 2) AS running_arpu,
        ROUND((SUM(revenue_per_day.revenue) OVER (ORDER BY date))::numeric / (SUM (paying_users.new_pay_users) OVER (ORDER BY date)), 2) AS running_arppu,
        ROUND((SUM(revenue_per_day.revenue) OVER (ORDER BY date))::numeric / (SUM(revenue_per_day.number_orders) OVER (ORDER BY date)), 2) AS running_aov
FROM revenue_per_day
LEFT JOIN paying_users
USING (date)
LEFT JOIN all_users
USING (date)
ORDER BY revenue_per_day.date
