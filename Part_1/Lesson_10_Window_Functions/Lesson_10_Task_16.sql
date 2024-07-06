--На основе информации в таблицах orders и products рассчитайте стоимость каждого заказа, ежедневную выручку сервиса и
--долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах.
--В результат включите следующие колонки: id заказа, время создания заказа, стоимость заказа, выручку за день,
--в который был совершён заказ, а также долю стоимости заказа в выручке за день, выраженную в процентах.

--При расчёте долей округляйте их до трёх знаков после запятой.

--Результат отсортируйте сначала по убыванию даты совершения заказа (именно даты, а не времени),
--потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.

--При проведении расчётов отменённые заказы не учитывайте.

--Поля в результирующей таблице:

--order_id, creation_time, order_price, daily_revenue, percentage_of_daily_revenue

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
    SELECT DISTINCT not_canceled_orders.order_id,
           not_canceled_orders.creation_time,
           SUM(products.price) OVER (PARTITION BY not_canceled_orders.order_id) AS order_price,
           SUM(products.price) OVER (PARTITION BY not_canceled_orders.creation_time ::DATE) AS daily_revenue
    FROM not_canceled_orders
        LEFT JOIN products 
        USING (product_id)
    )
SELECT order_id,
       creation_time,
       order_price,
       daily_revenue,
       ROUND(100 *order_price / daily_revenue, 3) AS percentage_of_daily_revenue
FROM revenue
ORDER BY creation_time ::DATE DESC, 
         ROUND(100 *order_price / daily_revenue, 3) DESC, 
         order_id;
