--На основе запроса из предыдущего задания для каждого пользователя рассчитайте, сколько в среднем времени проходит между
--его заказами. Посчитайте этот показатель только для тех пользователей, которые за всё время оформили более одного
--неотмененного заказа.

--Среднее время между заказами выразите в часах, округлив значения до целого числа. Колонку со средним значением времени
--назовите hours_between_orders. Результат отсортируйте по возрастанию id пользователя.

--Добавьте в запрос оператор LIMIT и включите в результат только первые 1000 записей.

--Поля в результирующей таблице: user_id, hours_between_orders

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
time_between_orders AS
    (
    SELECT user_id,
           order_id,
           time,
           EXTRACT(EPOCH FROM AGE(time, LAG(time, 1) OVER (PARTITION BY user_id ORDER BY time))) AS diff_time
    
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    )
SELECT user_id,
       ROUND(AVG(diff_time) / 3600) ::INT AS hours_between_orders
FROM time_between_orders

GROUP BY user_id
HAVING COUNT(order_id) > 1
ORDER BY user_id
LIMIT 1000;
