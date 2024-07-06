--По данным из таблицы user_actions определите пять пользователей, сделавших в августе 2022 года наибольшее 
--количество заказов.

--Выведите две колонки — id пользователей и число оформленных ими заказов. Колонку с числом оформленных заказов 
--назовите created_orders.

--Результат отсортируйте сначала по убыванию числа заказов, сделанных пятью пользователями, затем по возрастанию id --этих пользователей.

--Поля в результирующей таблице: user_id, created_orders

SELECT user_id,
       COUNT(DISTINCT order_id) AS created_orders
FROM   user_actions
WHERE  action = 'create_order'
    AND DATE_TRUNC('month', time) = '2022-08-01'
GROUP BY user_id
ORDER BY COUNT(DISTINCT order_id) DESC, user_id 
LIMIT 5;
