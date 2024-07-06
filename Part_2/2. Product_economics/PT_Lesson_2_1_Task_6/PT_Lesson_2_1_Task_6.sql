--Для каждого товара, представленного в таблице products, за весь период времени в таблице orders рассчитайте следующие показатели:
--Суммарную выручку, полученную от продажи этого товара за весь период.
--Долю выручки от продажи этого товара в общей выручке, полученной за весь период.
--Колонки с показателями назовите соответственно revenue и share_in_revenue. Колонку с наименованиями товаров назовите product_name.
--Долю выручки с каждого товара необходимо выразить в процентах. При её расчёте округляйте значения до двух знаков после запятой.
--Товары, округлённая доля которых в выручке составляет менее 0.5%, объедините в общую группу с названием «ДРУГОЕ» (без кавычек),
--просуммировав округлённые доли этих товаров.
--Результат должен быть отсортирован по убыванию выручки от продажи товара.
--Поля в результирующей таблице: product_name, revenue, share_in_revenue

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
revenue_per_product AS
    (
    SELECT products.name AS product_name,
           SUM(products.price) AS revenue
    FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
    GROUP BY products.name
    ),
all_product_revenue AS
    (
    SELECT CASE
           WHEN 100 * revenue ::numeric/ SUM(revenue) OVER () < 0.5 THEN 'ДРУГОЕ'
           ELSE product_name
           END,
           revenue,
           ROUND (100 * revenue ::numeric/ SUM(revenue) OVER (), 2) AS share_in_revenue
    FROM revenue_per_product
    )
SELECT product_name,
       SUM(revenue) AS revenue,
       SUM(share_in_revenue) AS share_in_revenue
FROM all_product_revenue
GROUP BY product_name
ORDER BY revenue DESC;
