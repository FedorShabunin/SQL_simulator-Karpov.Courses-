--Из таблицы courier_actions отберите топ 10% курьеров по количеству доставленных за всё время заказов.
--Выведите id курьеров, количество доставленных заказов и порядковый номер курьера в соответствии с числом доставленных заказов.

--У курьера, доставившего наибольшее число заказов, порядковый номер должен быть равен 1, а
--у курьера с наименьшим числом заказов — числу, равному десяти процентам от общего количества курьеров в таблице courier_actions.

--При расчёте номера последнего курьера округляйте значение до целого числа.

--Колонки с количеством доставленных заказов и порядковым номером назовите соответственно orders_count и courier_rank.
--Результат отсортируйте по возрастанию порядкового номера курьера.

--Поля в результирующей таблице: courier_id, orders_count, courier_rank

SELECT courier_id,
       COUNT(order_id) AS orders_count,
       ROW_NUMBER() OVER (ORDER BY COUNT(order_id) DESC, courier_id) AS courier_rank
FROM courier_actions
WHERE action = 'deliver_order'
GROUP BY courier_id
LIMIT (SELECT 0.1 * COUNT(DISTINCT courier_id)
       FROM courier_actions);
