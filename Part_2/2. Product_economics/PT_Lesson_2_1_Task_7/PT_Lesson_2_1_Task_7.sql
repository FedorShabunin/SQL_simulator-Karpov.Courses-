--Для каждого дня в таблицах orders и courier_actions рассчитайте следующие показатели:
--1. Выручку, полученную в этот день.
--2. Затраты, образовавшиеся в этот день.
--3. Сумму НДС с продажи товаров в этот день.
--4. Валовую прибыль в этот день (выручка за вычетом затрат и НДС).
--5. Суммарную выручку на текущий день.
--6. Суммарные затраты на текущий день.
--7. Суммарный НДС на текущий день.
--8. Суммарную валовую прибыль на текущий день.
--9. Долю валовой прибыли в выручке за этот день (долю п.4 в п.1).
--10. Долю суммарной валовой прибыли в суммарной выручке на текущий день (долю п.8 в п.5).
--Колонки с показателями назовите соответственно revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax,
--total_gross_profit, gross_profit_ratio, total_gross_profit_ratio
--Колонку с датами назовите date.
--Долю валовой прибыли в выручке необходимо выразить в процентах, округлив значения до двух знаков после запятой.
--Результат должен быть отсортирован по возрастанию даты.
--Поля в результирующей таблице: date, revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax,
--total_gross_profit, gross_profit_ratio,total_gross_profit_ratio

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
active_couriers AS
    (
    SELECT courier_id,
           time ::DATE AS date,
           COUNT(order_id) AS orders_per_couriers
    FROM courier_actions
    WHERE action = 'deliver_order'
    GROUP BY time ::DATE, courier_id
    HAVING COUNT(order_id) >= 5
    ORDER BY time ::DATE, courier_id
    ),
courier_bonus AS
    (
    SELECT date,
           CASE
           WHEN date <= '2022-08-31' THEN COUNT(courier_id) * 400
           WHEN date >= '2022-09-01' THEN COUNT(courier_id) * 500
           END AS bonus
    FROM active_couriers
    GROUP BY date
    ),
orders_per_day AS
    (
    SELECT time ::DATE AS date,
           150 * COUNT(DISTINCT order_id) AS pay_delivery
    FROM courier_actions
    WHERE action = 'deliver_order'
    GROUP BY time ::DATE
    ),
packed_orders AS 
    (
    SELECT time ::DATE AS date,
           CASE
           WHEN time ::DATE <= '2022-08-31' THEN 140 * COUNT(DISTINCT order_id)
           WHEN time ::DATE >= '2022-09-01' THEN 115 * COUNT(DISTINCT order_id) 
           END AS pay_packed_orders
    FROM courier_actions
    WHERE action = 'accept_order' AND order_id NOT IN (SELECT order_id
                                                       FROM canceled_orders)
    GROUP BY time ::DATE
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
costs_per_day AS
    (
    SELECT orders_per_day.date,
           CASE
           WHEN date <= '2022-08-31' 
           THEN 120000 + COALESCE(courier_bonus.bonus, 0) + orders_per_day.pay_delivery + packed_orders.pay_packed_orders
           WHEN date >= '2022-09-01' 
           THEN 150000 + COALESCE(courier_bonus.bonus, 0) + orders_per_day.pay_delivery + packed_orders.pay_packed_orders
           END ::numeric AS costs
    FROM orders_per_day
    LEFT JOIN courier_bonus
    USING (date)
    LEFT JOIN packed_orders
    USING (date)
    ),
taxes_per_day AS
    (
    SELECT not_canceled_orders.date,
           SUM(CASE
               WHEN name IN ('сахар', 'сухарики', 'сушки', 'семечки', 
                             'масло льняное', 'виноград', 'масло оливковое', 
                             'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 
                             'овсянка', 'макароны', 'баранина', 'апельсины', 
                             'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 
                             'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 
                             'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 
                             'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 
                             'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины'
                            )
               THEN ROUND(10 * price ::numeric / 110 , 2)
               ELSE ROUND(20 * price ::numeric / 120 , 2)
               END) AS tax
    FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
    GROUP BY date
    )
SELECT revenue_per_day.date,
       revenue_per_day.revenue,
       costs_per_day.costs,
       taxes_per_day.tax,
       revenue_per_day.revenue - costs_per_day.costs - taxes_per_day.tax AS gross_profit,
       SUM(revenue_per_day.revenue) OVER (ORDER BY date) AS total_revenue, 
       SUM(costs_per_day.costs) OVER (ORDER BY date) AS total_costs,
       SUM(taxes_per_day.tax) OVER (ORDER BY date) total_tax,
       SUM(revenue_per_day.revenue - costs_per_day.costs - taxes_per_day.tax) OVER (ORDER BY date) AS total_gross_profit,
       ROUND(100 * (revenue_per_day.revenue - costs_per_day.costs - taxes_per_day.tax) ::numeric / revenue_per_day.revenue, 2) AS gross_profit_ratio,
       ROUND(100 * SUM(revenue_per_day.revenue - costs_per_day.costs - taxes_per_day.tax) OVER (ORDER BY date) / SUM(revenue_per_day.revenue) OVER (ORDER BY date), 2) AS total_gross_profit_ratio
FROM revenue_per_day
LEFT JOIN costs_per_day
USING (date)
LEFT JOIN taxes_per_day
USING (date)
ORDER BY date;
