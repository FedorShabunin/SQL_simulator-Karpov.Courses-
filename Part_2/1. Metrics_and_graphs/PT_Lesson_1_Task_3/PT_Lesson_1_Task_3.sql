--Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

--Число платящих пользователей.
--Число активных курьеров.
--Долю платящих пользователей в общем числе пользователей на текущий день.
--Долю активных курьеров в общем числе курьеров на текущий день.
--Колонки с показателями назовите соответственно paying_users, active_couriers, paying_users_share, active_couriers_share.
--Колонку с датами назовите date. Проследите за тем, чтобы абсолютные показатели были выражены целыми числами.
--Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.

--Результат должен быть отсортирован по возрастанию даты. 

--Поля в результирующей таблице: date, paying_users, active_couriers, paying_users_share, active_couriers_share

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
min_date_user AS
    (
    SELECT user_id,
           MIN(time) ::DATE AS date
    FROM user_actions
    GROUP BY user_id
    ),
min_date_couriers AS
    (
    SELECT courier_id,
           MIN(time) :: DATE AS date
    FROM courier_actions
    GROUP BY courier_id
    ),
total_users_couriers AS
    (
    SELECT min_date_user.date,
           SUM(COUNT(DISTINCT min_date_user.user_id)) OVER (ORDER BY min_date_user.date) ::int AS total_users,
           SUM(COUNT(DISTINCT min_date_couriers.courier_id)) OVER (ORDER BY min_date_user.date) ::int AS total_couriers
    FROM min_date_user
    LEFT JOIN min_date_couriers
    USING(date)
GROUP BY min_date_user.date
    )
SELECT paying_users_count.date,
       paying_users_count.paying_users,
       active_couriers_count.active_couriers,
       ROUND(100 * paying_users_count.paying_users / total_users_couriers.total_users ::numeric, 2) AS paying_users_share,
       ROUND(100 * active_couriers_count.active_couriers / total_users_couriers.total_couriers ::numeric, 2) AS active_couriers_share
FROM paying_users_count
    LEFT JOIN active_couriers_count
    USING (date)
    LEFT JOIN total_users_couriers
    USING (date)
ORDER BY date;
