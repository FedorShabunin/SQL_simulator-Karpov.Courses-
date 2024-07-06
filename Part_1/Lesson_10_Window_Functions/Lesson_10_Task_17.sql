--На основе информации в таблицах orders и products рассчитайте ежедневную выручку сервиса и отразите её в колонке daily_revenue.
--Затем с помощью оконных функций и функций смещения посчитайте ежедневный прирост выручки.
--Прирост выручки отразите как в абсолютных значениях, так и в % относительно предыдущего дня.
--Колонку с абсолютным приростом назовите revenue_growth_abs, а колонку с относительным — revenue_growth_percentage.

--Для самого первого дня укажите прирост равным 0 в обеих колонках. При проведении расчётов отменённые заказы не учитывайте.
--Результат отсортируйте по колонке с датами по возрастанию.

--Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage округлите до одного знака при помощи ROUND().

--Поля в результирующей таблице: date, daily_revenue, revenue_growth_abs, revenue_growth_percentage

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
           creation_time,
           unnest(product_ids) AS product_id
    FROM   orders
    WHERE  order_id NOT IN (SELECT order_id
                            FROM canceled_orders)
    ),
revenue AS
    (
    SELECT not_canceled_orders.creation_time ::DATE as date,
           SUM(products.price) AS daily_revenue
    FROM not_canceled_orders
        LEFT JOIN products 
        USING (product_id)
    GROUP BY not_canceled_orders.creation_time ::DATE
    )
SELECT date,
       daily_revenue,
       COALESCE(daily_revenue - LAG(daily_revenue) OVER (ORDER BY date), 0) AS revenue_growth_abs,
       COALESCE(ROUND(100 * COALESCE(daily_revenue - LAG(daily_revenue) OVER (ORDER BY date), 0) / LAG(daily_revenue) OVER (ORDER BY date) ::numeric, 1), 0) AS revenue_growth_percentage
FROM revenue
ORDER BY date;
