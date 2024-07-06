--Для каждой даты в таблице user_actions посчитайте количество первых заказов, совершённых пользователями.

--Первыми заказами будем считать заказы, которые пользователи сделали в нашем сервисе впервые. 
--В расчётах учитывайте только неотменённые заказы.

--В результат включите две колонки: дату и количество первых заказов в эту дату. 
--Колонку с датами назовите date, а колонку с первыми заказами — first_orders.

--Результат отсортируйте по возрастанию даты.

--Поля в результирующей таблице: date, first_orders

WITH 
subquery_1 AS (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
subquery_2 AS (
    SELECT DATE(MIN(time)) AS date,
    user_id
    FROM user_actions
    WHERE order_id NOT IN (SELECT *
                          FROM subquery_1)
    GROUP BY user_id
    )
SELECT date,
       COUNT(user_id) AS first_orders
FROM subquery_2
GROUP BY date
ORDER BY date;
