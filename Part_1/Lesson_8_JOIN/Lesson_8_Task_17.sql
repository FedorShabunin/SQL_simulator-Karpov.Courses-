--Возьмите запрос, составленный на одном из прошлых уроков, и подтяните в него из таблицы users данные о поле 
--пользователей таким образом, чтобы все пользователи из таблицы user_actions остались в результате. Затем 
--посчитайте среднее значение cancel_rate для каждого пола, округлив его до трёх знаков после запятой. Колонку с 
--посчитанным средним значением назовите avg_cancel_rate.

--Помните про отсутствие информации о поле некоторых пользователей после join, так как не все пользователи из 
--таблицы user_action есть в таблице users. Для этой группы тоже посчитайте cancel_rate и в результирующей таблице --для пустого значения в колонке с полом укажите ‘unknown’ (без кавычек). Возможно, для этого придётся вспомнить, --как работает COALESCE.

--Результат отсортируйте по колонке с полом пользователя по возрастанию.

--Поля в результирующей таблице: sex, avg_cancel_rate

WITH
rate AS 
    (
    SELECT user_id,
           SUM(CASE
               WHEN action = 'cancel_order' THEN 1
               ELSE 0
               END) / COUNT(DISTINCT order_id) ::numeric AS cancel_rate
    FROM   user_actions
    GROUP BY user_id
    )
SELECT COALESCE(users.sex, 'unknown') AS sex,
       ROUND(AVG(rate.cancel_rate), 3) AS avg_cancel_rate
FROM rate
    LEFT JOIN users
    USING(user_id)
GROUP BY users.sex
ORDER BY users.sex;
