--По данным в таблице users посчитайте максимальный порядковый номер месяца среди всех порядковых номеров месяцев --рождения пользователей сервиса. С помощью группировки проведите расчёты отдельно в двух группах — для 
--пользователей мужского и женского пола.

--Новую колонку с максимальным номером месяца рождения в группах назовите max_month. Преобразуйте значения в новой --колонке в формат INTEGER, чтобы порядковый номер был выражен целым числом.

--Результат отсортируйте по колонке с полом пользователей.

--Поля в результирующей таблице: sex, max_month

SELECT sex,
       MAX(EXTRACT(MONTH FROM birth_date)) ::INT AS max_month
FROM   users
GROUP BY sex
ORDER BY sex;