--С помощью FULL JOIN объедините по ключу birth_date таблицы, полученные в результате вышеуказанных запросов 
--(то есть объедините друг с другом два подзапроса). Не нужно изменять их, просто добавьте нужный JOIN.

--В результат включите две колонки с birth_date из обеих таблиц. 
--Эти две колонки назовите соответственно users_birth_date и couriers_birth_date. 
--Также включите в результат колонки с числом пользователей и курьеров — users_count и couriers_count.

--Отсортируйте получившуюся таблицу сначала по колонке users_birth_date по возрастанию, 
--затем по колонке couriers_birth_date — тоже по возрастанию.

--Поля в результирующей таблице: users_birth_date, users_count,  couriers_birth_date, couriers_count

--После того как решите задачу, изучите полученную таблицу в Redash. Обратите внимание на пропущенные значения в колонках 
--с датами рождения курьеров и пользователей. Подтвердилось ли наше предположение?

SELECT u.birth_date users_birth_date,
       u.users_count,
       c.birth_date couriers_birth_date,
       c.couriers_count
FROM (SELECT birth_date, COUNT(user_id) AS users_count
      FROM users
      WHERE birth_date IS NOT NULL
      GROUP BY birth_date) u
    FULL JOIN (SELECT birth_date, COUNT(courier_id) AS couriers_count
               FROM couriers
               WHERE birth_date IS NOT NULL
               GROUP BY birth_date) c
    USING(birth_date)
ORDER BY u.birth_date, c.birth_date;
