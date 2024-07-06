--Для каждого заказа, в котором больше 5 товаров, рассчитайте время, затраченное на его доставку. 

--В результат включите id заказа, время принятия заказа курьером, время доставки заказа и время, затраченное на 
--доставку. 
--Новые колонки назовите соответственно time_accepted, time_delivered и delivery_time.

--В расчётах учитывайте только неотменённые заказы. Время, затраченное на доставку, выразите в минутах, 
--округлив значения до целого числа. Результат отсортируйте по возрастанию id заказа.

--Поля в результирующей таблице: order_id, time_accepted, time_delivered и delivery_time

WITH 
subquery_1 AS (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
subquery_2 AS (
    SELECT order_id
    FROM orders
    WHERE order_id NOT IN (SELECT *
                           FROM subquery_1)
        AND array_length(product_ids, 1) > 5)
SELECT order_id,
       MIN(time) AS time_accepted,
       MAX(time) AS time_delivered,
       (EXTRACT(EPOCH FROM (MAX(time) - MIN(time))) / 60) ::int AS delivery_time
FROM courier_actions
WHERE order_id IN (SELECT *
                   FROM subquery_2)
GROUP BY order_id
ORDER BY order_id;
