--Посчитайте возраст каждого пользователя в таблице users.

--Возраст измерьте числом полных лет, как мы делали в прошлых уроках. 
--Возраст считайте относительно последней даты в таблице user_actions.

--Для тех пользователей, у которых в таблице users не указана дата рождения, 
--укажите среднее значение возраста всех остальных пользователей, округлённое до целого числа.

--Колонку с возрастом назовите age. В результат включите колонки с id пользователя и возрастом. 
--Отсортируйте полученный результат по возрастанию id пользователя.

--Поля в результирующей таблице: user_id, age

WITH 
subquery_1 AS (
    SELECT MAX(time)
    FROM user_actions
    ),
subquery_2 AS (
    SELECT ROUND(AVG(EXTRACT(YEAR FROM (AGE((SELECT *
                    FROM subquery_1), birth_date)))))
    FROM users
    )
SELECT user_id,
       COALESCE(EXTRACT(YEAR FROM (AGE((SELECT *
                    FROM subquery_1), birth_date))), (SELECT *
                                                    FROM subquery_2)) ::int AS age
FROM users
ORDER BY user_id;
