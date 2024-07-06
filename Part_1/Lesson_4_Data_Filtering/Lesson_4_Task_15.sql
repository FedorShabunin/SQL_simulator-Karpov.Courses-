--Из таблицы user_actions получите информацию о всех отменах заказов, которые пользователи совершали в 
--течение августа 2022 года по средам с 12:00 до 15:59.

--Результат отсортируйте по убыванию id отменённых заказов.

--Поля в результирующей таблице: user_id, order_id, action, time

SELECT user_id,
       order_id,
       action,
       time
FROM   user_actions
WHERE  action = 'cancel_order'
    AND DATE_TRUNC('month', time) = '2022-08-01'
    AND EXTRACT(DOW FROM time) = 3 
    AND EXTRACT(HOUR FROM time) BETWEEN 12 AND 15
ORDER BY order_id DESC;
