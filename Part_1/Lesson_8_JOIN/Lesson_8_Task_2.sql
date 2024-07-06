--А теперь попробуйте немного переписать запрос из прошлого задания и посчитать количество уникальных id в объединённой таблице. 
--То есть снова объедините таблицы, но в этот раз просто посчитайте уникальные user_id в одной из колонок с id. -
--Выведите это количество в качестве результата. Колонку с посчитанным значением назовите users_count.

--Поле в результирующей таблице: users_count

--После того как решите задачу, сравните полученное значение с количеством уникальных пользователей 
--в таблицах users и user_actions, которое мы посчитали на прошлом шаге. С каким значением оно совпадает?

SELECT COUNT(DISTINCT user_act.user_id) AS users_count
FROM user_actions AS user_act
    INNER JOIN users AS us
    USING(user_id)