--Для каждого пользователя в таблице user_actions посчитайте порядковый номер каждого заказа.

--Для этого примените оконную функцию ROW_NUMBER к колонке с временем заказа.
--Не забудьте указать деление на партиции по пользователям и сортировку внутри партиций. Отменённые заказы не учитывайте.

--Новую колонку с порядковым номером заказа назовите order_number.
--Результат отсортируйте сначала по возрастанию id пользователя, затем по возрастанию порядкового номера заказа.

--Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

--Поля в результирующей таблице: user_id, order_id, time, order_number

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    )
SELECT user_id,
       order_id,
       time,
       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY time) AS order_number
FROM user_actions
WHERE order_id NOT IN (SELECT order_id
                       FROM canceled_orders)
ORDER BY user_id, order_id
LIMIT 1000;
