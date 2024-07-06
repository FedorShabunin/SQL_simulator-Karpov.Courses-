--Дополните запрос из предыдущего задания и теперь для каждого дня, представленного в таблицах user_actions и courier_actions,
--дополнительно рассчитайте следующие показатели:

--Прирост числа новых пользователей.
--Прирост числа новых курьеров.
--Прирост общего числа пользователей.
--Прирост общего числа курьеров.
--Показатели, рассчитанные на предыдущем шаге, также включите в результирующую таблицу.

--Колонки с новыми показателями назовите соответственно new_users_change, new_couriers_change, total_users_growth,
--total_couriers_growth. Колонку с датами назовите date.

-- показатели прироста считайте в процентах относительно значений в предыдущий день.
--При расчёте показателей округляйте значения до двух знаков после запятой.

--Результирующая таблица должна быть отсортирована по возрастанию даты.

--Поля в результирующей таблице: 
--date, new_users, new_couriers, total_users, total_couriers, new_users_change, new_couriers_change, total_users_growth,
--total_couriers_growth

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
    ),
last_query AS
    (
    SELECT min_date_user.date,
           COUNT(DISTINCT min_date_user.user_id) AS new_users,
           COUNT(DISTINCT min_date_couriers.courier_id) AS new_couriers,
           SUM(COUNT(DISTINCT min_date_user.user_id)) OVER (ORDER BY min_date_user.date) ::int AS total_users,
           SUM(COUNT(DISTINCT min_date_couriers.courier_id)) OVER (ORDER BY min_date_user.date) ::int AS total_couriers
    FROM min_date_user
        LEFT JOIN min_date_couriers
        USING(date)
    GROUP BY min_date_user.date
    )
SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       ROUND(100 * (new_users - LAG(new_users, 1) OVER ()) / LAG(new_users, 1) OVER () ::numeric, 2) AS new_users_change,
       ROUND(100 * (new_couriers - LAG(new_couriers, 1) OVER ()) / LAG(new_couriers, 1) OVER () ::numeric, 2) AS new_couriers_change,
       ROUND(100 * (total_users - LAG(total_users, 1) OVER ()) / LAG(total_users, 1) OVER () ::numeric, 2) AS total_users_growth,
       ROUND(100 * (total_couriers - LAG(total_couriers, 1) OVER ()) / LAG(total_couriers, 1) OVER () ::numeric, 2) AS total_couriers_growth
FROM last_query
ORDER BY date;
