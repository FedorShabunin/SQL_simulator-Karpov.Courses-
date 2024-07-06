--На основе данных в таблице user_actions рассчитайте показатель дневного Retention для всех пользователей,
--разбив их на когорты по дате первого взаимодействия с нашим приложением.
--В результат включите четыре колонки: месяц первого взаимодействия, дату первого взаимодействия, количество дней,
--прошедших с даты первого взаимодействия (порядковый номер дня начиная с 0), и само значение Retention.
--Колонки со значениями назовите соответственно start_month, start_date, day_number, retention.
--Метрику необходимо выразить в виде доли, округлив полученные значения до двух знаков после запятой.
--Месяц первого взаимодействия укажите в виде даты, округлённой до первого числа месяца.
--Результат должен быть отсортирован сначала по возрастанию даты первого взаимодействия,
--затем по возрастанию порядкового номера дня.
--Поля в результирующей таблице: start_month, start_date, day_number, retention

WITH
first_action AS
    (
    SELECT user_id,
           MIN(DATE_TRUNC('month', time) ::DATE) OVER (PARTITION BY user_id) AS start_month,
           MIN(time ::DATE) OVER (PARTITION BY user_id) AS start_date,
           time  ::DATE AS date
    FROM user_actions
    )
SELECT start_month,
       start_date,
       ROW_NUMBER() OVER (PARTITION BY start_date) - 1 AS day_number,
       ROUND(COUNT(DISTINCT user_id) ::numeric / MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY start_date), 2) AS retention
FROM first_action
GROUP BY date, start_month, start_date
ORDER BY start_date, date;
