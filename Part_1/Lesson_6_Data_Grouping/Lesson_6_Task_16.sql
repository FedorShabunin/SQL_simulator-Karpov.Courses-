--Разбейте пользователей из таблицы users на 4 возрастные группы:

--от 18 до 24 лет;
--от 25 до 29 лет;
--от 30 до 35 лет;
--старше 36.
--Посчитайте число пользователей, попавших в каждую возрастную группу. Группы назовите соответственно «18-24», --«25-29», «30-35», «36+» (без кавычек).

--В расчётах не учитывайте пользователей, у которых не указана дата рождения. Как и в прошлых задачах, в качестве --возраста учитывайте число полных лет.

--Выведите наименования групп и число пользователей в них. Колонку с наименованием групп назовите group_age, а 
--колонку с числом пользователей — users_count.

--Отсортируйте полученную таблицу по колонке с наименованием групп по возрастанию.

--Поля в результирующей таблице: group_age, users_count

SELECT CASE 
       WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT > 35 
       THEN '36+' 
       WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 30 AND 36 
       THEN '30-35' 
       WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 25 AND 30 
       THEN '25-29' 
       WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 18 AND 25 
       THEN '18-24' 
       END AS group_age, 
       COUNT(user_id) AS users_count
FROM   users
WHERE  birth_date IS NOT NULL
GROUP BY CASE 
       	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT > 35 
      	 THEN '36+' 
      	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 30 AND 36 
      	 THEN '30-35' 
      	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 25 AND 30 
      	 THEN '25-29' 
      	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 18 AND 25 
      	 THEN '18-24' 
      	 END
ORDER BY CASE 
       	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT > 35 
      	 THEN '36+' 
      	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 30 AND 36 
      	 THEN '30-35' 
      	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 25 AND 30 
      	 THEN '25-29' 
      	 WHEN EXTRACT(YEAR FROM AGE(current_date, birth_date)) ::INT BETWEEN 18 AND 25 
      	 THEN '18-24' 
      	 END;
