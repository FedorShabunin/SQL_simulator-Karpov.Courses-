--Используя запрос из предыдущего задания, посчитайте, сколько в среднем товаров заказывает каждый пользователь. 
--Выведите id пользователя и среднее количество товаров в заказе. Среднее значение округлите до двух знаков после запятой. 
--Колонку посчитанными значениями назовите avg_order_size. 
--Результат выполнения запроса отсортируйте по возрастанию id пользователя. 

--Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

--Поля в результирующей таблице: user_id, avg_order_size

SELECT result.user_id,
       ROUND(AVG(array_length(product_ids, 1)), 2) avg_order_size
FROM (
WITH
subquery_1 AS (
    SELECT order_id
    FROM   user_actions
    WHERE  action = 'cancel_order'
    ),
subquery_2 AS (
    SELECT DISTINCT 
           user_id, 
           order_id
    FROM user_actions
    WHERE order_id NOT IN (SELECT *
                           FROM subquery_1))
SELECT u.user_id, 
       u.order_id, 
       o.product_ids
FROM subquery_2 u
    LEFT JOIN orders o
    USING (order_id)
ORDER BY u.user_id, u.order_id
) AS result
GROUP BY result.user_id
ORDER BY result.user_id
LIMIT 1000;
