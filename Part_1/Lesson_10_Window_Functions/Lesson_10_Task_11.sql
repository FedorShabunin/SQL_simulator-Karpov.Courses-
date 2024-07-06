--К запросу, полученному на предыдущем шаге, примените оконную функцию и для каждого дня посчитайте долю первых и
--повторных заказов. Сохраните структуру полученной ранее таблицы и добавьте только одну новую колонку с посчитанными значениями.

--Колонку с долей заказов каждой категории назовите orders_share. Значения в полученном столбце округлите до двух знаков
--после запятой. В результат также включите количество заказов в группах, посчитанное на предыдущем шаге.

--В расчётах по-прежнему учитывайте только неотменённые заказы.

--Результат отсортируйте сначала по возрастанию даты, затем по возрастанию значений в колонке с типом заказа.

--Поля в результирующей таблице: date, order_type, orders_count, orders_share

WITH 
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
type_of_order AS 
    (
    SELECT time ::DATE AS date,
           CASE 
           WHEN time = MIN(time) OVER (PARTITION BY user_id) THEN 'Первый'
           ELSE 'Повторный'
           END AS order_type
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    )
SELECT date,
       order_type,
       COUNT(order_type) AS orders_count,
       ROUND(COUNT(order_type) / (SUM(COUNT(order_type)) OVER (PARTITION BY date)), 2) AS orders_share
FROM type_of_order
GROUP BY date, order_type
ORDER BY date, order_type;
