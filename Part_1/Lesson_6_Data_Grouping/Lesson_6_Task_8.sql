--Разбейте пользователей из таблицы users на группы по возрасту (возраст по-прежнему измеряем числом полных лет) и --посчитайте количество пользователей каждого возраста.

--Колонку с возрастом назовите age, а колонку с числом пользователей — users_count. Преобразуйте значения в колонке --с возрастом в формат INTEGER, чтобы возраст был выражен целым числом.

--Результат отсортируйте по колонке с возрастом по возрастанию.

--Поля в результирующей таблице: age, users_count

SELECT EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT AS age, 
       COUNT(user_id) AS users_count
FROM   users
GROUP BY EXTRACT(YEAR FROM AGE(current_date, birth_date))
ORDER BY EXTRACT(YEAR FROM AGE(current_date, birth_date));
