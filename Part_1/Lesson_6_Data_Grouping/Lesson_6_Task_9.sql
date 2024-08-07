--Вновь разбейте пользователей из таблицы users на группы по возрасту (возраст по-прежнему измеряем количеством 
--полных лет), только теперь добавьте в группировку ещё и пол пользователя. Затем посчитайте количество 
--пользователей в каждой половозрастной группе.

--Все NULL значения в колонке birth_date заранее отфильтруйте с помощью WHERE.

--Колонку с возрастом назовите age, а колонку с числом пользователей — users_count, имя колонки с полом оставьте 
--без изменений. Преобразуйте значения в колонке с возрастом в формат INTEGER, чтобы возраст был выражен целым 
--числом.

--Отсортируйте полученную таблицу сначала по колонке с возрастом по возрастанию, затем по колонке с полом — тоже по --возрастанию.

--Поля в результирующей таблице: age, sex, users_count

SELECT EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT AS age, 
       sex, 
       COUNT(DISTINCT user_id) AS users_count
FROM   users
WHERE  birth_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM AGE(current_date, birth_date)), sex
ORDER BY EXTRACT(YEAR FROM AGE(current_date, birth_date)), sex;
