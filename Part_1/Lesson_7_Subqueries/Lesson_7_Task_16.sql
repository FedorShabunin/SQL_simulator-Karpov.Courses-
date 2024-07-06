--Из таблицы couriers выведите всю информацию о курьерах, которые в сентябре 2022 года доставили 30 и более 
--заказов. Результат отсортируйте по возрастанию id курьера.

--Поля в результирующей таблице: courier_id, birth_date, sex

WITH subquery_1 AS (
    SELECT courier_id
    FROM courier_actions
    WHERE action = 'deliver_order'
        AND DATE_TRUNC('month', time) = '2022-09-01'
    GROUP BY courier_id
    HAVING (COUNT(DISTINCT order_id) >= 30)
)
SELECT courier_id, 
       birth_date,
       sex
FROM couriers
WHERE courier_id IN (SELECT *
                     FROM subquery_1)
ORDER BY courier_id;
