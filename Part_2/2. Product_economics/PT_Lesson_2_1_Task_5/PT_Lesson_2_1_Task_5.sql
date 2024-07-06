--Для каждого дня в таблицах orders и user_actions рассчитайте следующие показатели:
--Выручку, полученную в этот день.
--Выручку с заказов новых пользователей, полученную в этот день.
--Долю выручки с заказов новых пользователей в общей выручке, полученной за этот день.
--Долю выручки с заказов остальных пользователей в общей выручке, полученной за этот день.
--Колонки с показателями назовите соответственно revenue, new_users_revenue, new_users_revenue_share, old_users_revenue_share.
--Колонку с датами назовите date. 
--Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.
--Результат должен быть отсортирован по возрастанию даты.
--Поля в результирующей таблице:
--date, revenue, new_users_revenue, new_users_revenue_share, old_users_revenue_share

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
not_canceled_orders AS
    (
    SELECT user_actions.user_id,
           orders.order_id,
           UNNEST(orders.product_ids) AS product_id,
           orders.creation_time ::DATE AS date
    FROM orders
    LEFT JOIN user_actions
    USING (order_id)
    WHERE orders.order_id NOT IN (SELECT order_id
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
min_date_paying_users AS
    (
    SELECT user_id,
           MIN(time ::DATE) AS date
    FROM user_actions
    GROUP BY user_id
    ),
new_revenue_per_day AS
    (
    SELECT min_date_paying_users.date,
           SUM(products.price) AS new_users_revenue
    FROM min_date_paying_users
    LEFT JOIN not_canceled_orders
    USING (user_id, date)
    LEFT JOIN products
    USING (product_id)
    GROUP BY min_date_paying_users.date
    )    
SELECT revenue_per_day.date,
       revenue_per_day.revenue,
       new_revenue_per_day.new_users_revenue,
       ROUND(100 * new_revenue_per_day.new_users_revenue ::numeric / revenue_per_day.revenue, 2) AS new_users_revenue_share,
       ROUND(100 * (revenue_per_day.revenue - new_revenue_per_day.new_users_revenue) ::numeric / revenue_per_day.revenue, 2) AS old_users_revenue_share
FROM revenue_per_day
LEFT JOIN new_revenue_per_day
USING (date)
ORDER BY date;
