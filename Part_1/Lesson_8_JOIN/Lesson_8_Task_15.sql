--По данным таблиц orders, products и user_actions посчитайте ежедневную выручку сервиса. 
--Под выручкой будем понимать стоимость всех реализованных товаров, содержащихся в заказах.

--Колонку с датой назовите date, а колонку со значением выручки — revenue.

--В расчётах учитывайте только неотменённые заказы.

--Результат отсортируйте по возрастанию даты.

--Поля в результирующей таблице: date, revenue
WITH 
canceled_orders AS 
    (
    SELECT order_id
    FROM   user_actions
    WHERE  action = 'cancel_order'
    ),
not_canceled_orders AS 
    (
    SELECT DATE(creation_time) AS date,
           order_id,
           UNNEST(product_ids) AS product_id
    FROM orders
    WHERE order_id NOT IN (SELECT *
                           FROM canceled_orders)
    )
SELECT not_canceled_orders.date,
       SUM(products.price) AS revenue
FROM not_canceled_orders
    LEFT JOIN products
    USING (product_id)
GROUP BY date
ORDER BY date;
