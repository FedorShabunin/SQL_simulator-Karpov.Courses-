--Объедините запрос из предыдущего задания с частью запроса, который вы составили в задаче 11, 
--то есть объедините запрос со стоимостью заказов с запросом, в котором вы считали размер каждого заказа из таблицы user_actions.

--На основе объединённой таблицы для каждого пользователя рассчитайте следующие показатели:
--общее число заказов — колонку назовите orders_count
--среднее количество товаров в заказе — avg_order_size
--суммарную стоимость всех покупок — sum_order_value
--среднюю стоимость заказа — avg_order_value
--минимальную стоимость заказа — min_order_value
--максимальную стоимость заказа — max_order_value
--Полученный результат отсортируйте по возрастанию id пользователя.

--Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

--Помните, что в расчётах мы по-прежнему учитываем только неотменённые заказы. 
--При расчёте средних значений, округляйте их до двух знаков после запятой.

--Поля в результирующей таблице: 

--user_id, orders_count, avg_order_size, sum_order_value, avg_order_value, min_order_value, max_order_value


WITH
canceled_orders AS 
    (
    SELECT order_id
    FROM   user_actions
    WHERE  action = 'cancel_order'
    ),
not_canceled_orders AS 
    (
    SELECT DISTINCT 
           user_id, 
           order_id
    FROM user_actions
    WHERE order_id NOT IN (SELECT *
                           FROM canceled_orders)
    ),
task_11 AS 
    (
    SELECT u.user_id, 
           u.order_id, 
           o.product_ids
    FROM not_canceled_orders AS u
        LEFT JOIN orders o
        USING (order_id)
    ORDER BY u.user_id, u.order_id
    ),
list_of_products AS 
    (
    SELECT order_id,
           unnest (product_ids) product_id
    FROM orders
    ) ,
products_with_price AS 
    (   
    SELECT list_of_products.order_id,
           list_of_products.product_id,
           products.price
    FROM list_of_products
        LEFT JOIN products
        USING (product_id)
    ORDER BY list_of_products.order_id, list_of_products.product_id
    ),
task_13 AS 
    (
    SELECT products_with_price.order_id,
           SUM(products_with_price.price) AS order_price
    FROM products_with_price
    GROUP BY products_with_price.order_id
    ORDER BY products_with_price.order_id
    )
SELECT task_11.user_id,
       COUNT(task_11.order_id) AS orders_count,
       ROUND(AVG(array_length(task_11.product_ids, 1)), 2) AS avg_order_size,
       SUM(task_13.order_price) AS sum_order_value,
       ROUND(AVG(task_13.order_price),2) AS avg_order_value,
       MIN(task_13.order_price) AS min_order_value,
       MAX(task_13.order_price) AS max_order_value
FROM task_11
    LEFT JOIN task_13
    USING(order_id)
GROUP BY task_11.user_id
ORDER BY task_11.user_id
LIMIT 1000;
