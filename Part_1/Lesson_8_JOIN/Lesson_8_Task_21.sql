--Выясните, какие пары товаров покупают вместе чаще всего.

--Пары товаров сформируйте на основе таблицы с заказами. Отменённые заказы не учитывайте. 
--В качестве результата выведите две колонки — колонку с парами наименований товаров и колонку со значениями, показывающими, 
--сколько раз конкретная пара встретилась в заказах пользователей. Колонки назовите соответственно pair и count_pair.

--Пары товаров должны быть представлены в виде списков из двух наименований. Пары товаров внутри списков должны быть отсортированы 
--в порядке возрастания наименования. Результат отсортируйте сначала по убыванию частоты встречаемости пары товаров в заказах, 
--затем по колонке pair — по возрастанию.

--Поля в результирующей таблице: pair, count_pair

WITH
canceled_orders AS 
    (
    SELECT order_id
    FROM   user_actions
    WHERE  action = 'cancel_order'
    )
SELECT array_sort(array[m.name, n.name]) AS pair,
       COUNT(o.order_id) AS count_pair
FROM   products m 
    JOIN products n
    ON m.product_id < n.product_id 
    JOIN orders o
    ON m.product_id = any(o.product_ids) 
        AND n.product_id = any(o.product_ids) 
        AND o.order_id NOT IN (SELECT *
                               FROM canceled_orders)
GROUP BY array[m.product_id, n.product_id], 
         array[m.name, n.name]
ORDER BY count_pair DESC, pair;
