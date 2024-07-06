--Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

--Число новых пользователей.
--Число новых курьеров.
--Общее число пользователей на текущий день.
--Общее число курьеров на текущий день.
--Колонки с показателями назовите соответственно new_users, new_couriers, total_users, total_couriers.
--Колонку с датами назовите date. Проследите за тем, чтобы показатели были выражены целыми числами.
--Результат должен быть отсортирован по возрастанию даты.

--Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers

WITH 
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
    )
SELECT min_date_user.date,
       COUNT(DISTINCT min_date_user.user_id) AS new_users,
       COUNT(DISTINCT min_date_couriers.courier_id) AS new_couriers,
       SUM(COUNT(DISTINCT min_date_user.user_id)) OVER (ORDER BY min_date_user.date) ::int AS total_users,
       SUM(COUNT(DISTINCT min_date_couriers.courier_id)) OVER (ORDER BY min_date_user.date) ::int AS total_couriers
FROM min_date_user
    LEFT JOIN min_date_couriers
    USING(date)
GROUP BY min_date_user.date
ORDER BY min_date_user.date;
