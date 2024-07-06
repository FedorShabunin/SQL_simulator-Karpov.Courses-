--Для каждого дня недели в таблицах orders и user_actions рассчитайте следующие показатели:
--Выручку на пользователя (ARPU).
--Выручку на платящего пользователя (ARPPU).
--Выручку на заказ (AOV).
--При расчётах учитывайте данные только за период с 26 августа 2022 года по 8 сентября 2022 года включительно — так,
--чтобы в анализ попало одинаковое количество всех дней недели (ровно по два дня).
--В результирующую таблицу включите как наименования дней недели (например, Monday), так и порядковый номер дня недели
--(от 1 до 7, где 1 — это Monday, 7 — это Sunday).
--Колонки с показателями назовите соответственно arpu, arppu, aov. Колонку с наименованием дня недели назовите weekday,
--а колонку с порядковым номером дня недели weekday_number.
--При расчёте всех показателей округляйте значения до двух знаков после запятой.
--Результат должен быть отсортирован по возрастанию порядкового номера дня недели.
--Поля в результирующей таблице: 
--weekday, weekday_number, arpu, arppu, aov

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
    SELECT TO_CHAR(not_canceled_orders.date, 'Day') AS weekday,
           EXTRACT(ISODOW FROM not_canceled_orders.date) AS weekday_number,
           SUM(products.price) AS revenue
    FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
    WHERE date >= '2022-08-26' AND date <= '2022-09-08'
    GROUP BY EXTRACT(ISODOW FROM not_canceled_orders.date), TO_CHAR(not_canceled_orders.date, 'Day')
    ),
users_orders AS
    (
    SELECT EXTRACT(ISODOW FROM time) AS weekday_number,
           COUNT(DISTINCT order_id) AS number_orders,
           COUNT(DISTINCT user_id) AS number_pay_users
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
        AND time ::DATE >= '2022-08-26' AND time ::DATE <= '2022-09-08'
    GROUP BY EXTRACT(ISODOW FROM time)
    ),
all_users AS
    (
    SELECT EXTRACT(ISODOW FROM time) AS weekday_number,
           COUNT(DISTINCT user_id) AS number_users
    FROM user_actions
    WHERE time ::DATE >= '2022-08-26' AND time ::DATE <= '2022-09-08'
    GROUP BY EXTRACT(ISODOW FROM time)
    )
 SELECT revenue_per_day.weekday,
        revenue_per_day.weekday_number,
        ROUND(revenue_per_day.revenue ::numeric / all_users.number_users, 2) AS arpu,
        ROUND(revenue_per_day.revenue ::numeric / users_orders.number_pay_users, 2) AS arppu,
        ROUND(revenue_per_day.revenue ::numeric / users_orders.number_orders, 2) AS aov
FROM revenue_per_day
LEFT JOIN users_orders
USING (weekday_number)
LEFT JOIN all_users
USING (weekday_number)
ORDER BY revenue_per_day.weekday_number;
