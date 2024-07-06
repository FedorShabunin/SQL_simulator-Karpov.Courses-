--Отберите из таблицы users пользователей мужского пола, которые старше всех пользователей женского пола.

--Выведите две колонки: id пользователя и дату рождения. Результат отсортируйте по возрастанию id пользователя.

--Поля в результирующей таблице: user_id, birth_date

WITH subquery_1 AS (
    SELECT MIN(birth_date)
    FROM users
    WHERE sex = 'female')
SELECT user_id,
       birth_date
FROM users
WHERE sex = 'male'
    AND birth_date < (SELECT *
                      FROM subquery_1)
ORDER BY user_id;
