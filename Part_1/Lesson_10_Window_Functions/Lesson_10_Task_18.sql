--С помощью оконной функции рассчитайте медианную стоимость всех заказов из таблицы orders, оформленных в нашем сервисе. 
--В качестве результата выведите одно число. Колонку с ним назовите median_price. Отменённые заказы не учитывайте.

--Поле в результирующей таблице: median_price

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
ordered_orders AS
    (
    SELECT not_canceled_orders.order_id,
           SUM(products.price) AS order_price,
           ROW_NUMBER () OVER(ORDER BY SUM(products.price)) AS number,
           COUNT(not_canceled_orders.order_id) OVER () AS quantity
    FROM not_canceled_orders
        LEFT JOIN products 
        USING (product_id)
    GROUP BY not_canceled_orders.order_id
    )
SELECT CASE
       WHEN MOD(COUNT(number), 2) = 1 THEN (
                                            SELECT order_price
                                            FROM ordered_orders
                                            WHERE number = (quantity + 1) / 2
                                            )
       WHEN MOD(COUNT(number), 2) = 0 THEN (
                                            SELECT AVG(order_price)
                                            FROM ordered_orders
                                            WHERE number IN (quantity / 2, quantity / 2 + 1)
                                            )
       END AS median_price
FROM ordered_orders;
