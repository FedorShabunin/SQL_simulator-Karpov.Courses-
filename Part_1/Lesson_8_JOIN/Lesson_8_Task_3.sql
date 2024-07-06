--С помощью LEFT JOIN объедините таблицы user_actions и users по ключу user_id. 
--Обратите внимание на порядок таблиц — слева users_actions, справа users. 
--В результат включите две колонки с user_id из обеих таблиц. 
--Эти две колонки назовите соответственно user_id_left и user_id_right. 
--Также в результат включите колонки order_id, time, action, sex, birth_date. 
--Отсортируйте получившуюся таблицу по возрастанию id пользователя (в колонке из левой таблицы).

--Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date

--После того как решите задачу, обратите внимание на колонки с user_id. Нет ли в какой-то из них пропущенных значений?

SELECT t1.user_id user_id_left,
       t2.user_id user_id_right,
       t1.order_id,
       t1.time,
       t1.action,
       t2.sex,
       t2.birth_date
FROM user_actions t1
    LEFT JOIN users t2
    ON t1.user_id = t2.user_id
ORDER BY t1.user_id
