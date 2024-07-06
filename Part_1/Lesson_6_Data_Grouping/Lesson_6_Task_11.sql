--Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество 
--заказов в каждой группе. Учитывайте только заказы, оформленные по будням. В результат включите только те размеры --заказов, общее число которых превышает 2000. Для расчётов используйте данные из таблицы orders.

--Выведите две колонки: размер заказа и число заказов такого размера. Колонки назовите соответственно order_size и --orders_count.

--Результат отсортируйте по возрастанию размера заказа.

--Поля в результирующей таблице: order_size, orders_count

--Когда решите эту задачу, вернитесь к одной из предыдущих и подумайте, могли бы мы ещё каким-то способом сделать --так, чтобы в результат не попала группа с NULL значениями. Можете самостоятельно написать ещё один запрос и 
--попробовать сдать его в качестве альтернативного решения.

SELECT array_length(product_ids, 1) AS order_size,
       COUNT(DISTINCT order_id) AS orders_count
FROM   orders
WHERE  TO_CHAR(creation_time, 'Dy') NOT IN ('Sat', 'Sun')
GROUP BY array_length(product_ids, 1) 
HAVING COUNT(DISTINCT order_id) > 2000
ORDER BY array_length(product_ids, 1);
