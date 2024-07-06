--Для каждого дня недели в таблице user_actions посчитайте:

--Общее количество оформленных заказов.
--Общее количество отменённых заказов.
--Общее количество неотменённых заказов (т.е. доставленных).
--Долю неотменённых заказов в общем числе заказов (success rate).
--Новые колонки назовите соответственно created_orders, canceled_orders, actual_orders и success_rate. Колонку с 
--долей неотменённых заказов округлите до трёх знаков после запятой.

--Все расчёты проводите за период с 24 августа по 6 сентября 2022 года включительно, чтобы во временной интервал 
--попало равное количество разных дней недели.

--Группы сформируйте следующим образом: выделите день недели из даты с помощью функции to_char с параметром 'Dy', --также выделите порядковый номер дня недели с помощью функции DATE_PART с параметром 'isodow'. Далее сгруппируйте --данные по двум полям и проведите все необходимые расчёты.

--В результате должна получиться группировка по двум колонкам: с порядковым номером дней недели и их сокращёнными --наименованиями.

--Результат отсортируйте по возрастанию порядкового номера дня недели.

--Поля в результирующей таблице: weekday_number, weekday, created_orders, canceled_orders, actual_orders, 
--success_rate

SELECT EXTRACT(ISODOW FROM time) ::INT AS weekday_number, 
       TO_CHAR(time, 'Dy') AS weekday, 
       SUM(CASE
       	   WHEN action = 'create_order' 
       	   THEN 1 
       	   ELSE 0 
       	   END) AS created_orders, 
       SUM(CASE 
       	   WHEN action = 'cancel_order' 
       	   THEN 1 
       	   ELSE 0 
       	   END) AS canceled_orders, 
       SUM(CASE
       	   WHEN action = 'create_order' 
       	   THEN 1 
       	   ELSE 0 
       	   END) - SUM(CASE
       	   	      WHEN action = 'cancel_order' 
       	   	      THEN 1 
       	   	      ELSE 0 
       	   	      END) AS actual_orders, 
       ROUND(1 - SUM(CASE 
       		     WHEN action = 'cancel_order' 
       		     THEN 1 
       		     ELSE 0 
       		     END) / SUM(CASE
       		     	        WHEN action = 'create_order' 
       		     	        THEN 1 
       		     	        ELSE 0 
       		     	        END) ::NUMERIC, 3) AS success_rate
FROM   user_actions
WHERE  time BETWEEN '2022-08-24' AND '2022-09-07'
GROUP BY EXTRACT(ISODOW FROM time), TO_CHAR(time, 'Dy')
ORDER BY EXTRACT(ISODOW FROM time);
