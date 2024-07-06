--Для каждого дня в таблице orders рассчитайте следующие показатели:
--1. Выручку, полученную в этот день.
--2. Суммарную выручку на текущий день.
--3. Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.
--Колонки с показателями назовите соответственно revenue, total_revenue, revenue_change. Колонку с датами назовите date.
--Прирост выручки рассчитайте в процентах и округлите значения до двух знаков после запятой.
--Результат должен быть отсортирован по возрастанию даты.
--Поля в результирующей таблице: date, revenue, total_revenue, revenue_change

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
    SELECT --not_canceled_orders.order_id,
           not_canceled_orders.date,
           SUM(products.price) AS revenue
           --SUM(products.price) OVER (ORDER BY date)
    FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
    GROUP BY date
    )
SELECT date,
       revenue,
       SUM(revenue) OVER (ORDER BY date) AS total_revenue,
       ROUND(100 * (revenue - LAG(revenue, 1) OVER()) ::numeric / LAG(revenue, 1) OVER(), 2) AS revenue_change
FROM revenue_per_day
ORDER BY date
