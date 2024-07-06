--Посчитайте количество уникальных клиентов в таблице user_actions, сделавших за последнюю неделю хотя бы один 
--заказ.

--Полученную колонку с числом клиентов назовите users_count. В качестве текущей даты, от которой откладывать 
--неделю, используйте последнюю дату в той же таблице user_actions.

--Поле в результирующей таблице: users_count

SELECT COUNT(DISTINCT user_id) AS users_count
FROM   user_actions
WHERE  time >= (SELECT MAX(time) - interval'1 week'
                FROM   user_actions);
