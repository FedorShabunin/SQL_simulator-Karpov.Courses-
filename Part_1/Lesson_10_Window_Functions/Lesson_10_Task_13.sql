--Для каждой записи в таблице user_actions с помощью оконных функций и предложения FILTER посчитайте, сколько заказов сделал
--и сколько отменил каждый пользователь на момент совершения нового действия.

--Иными словами, для каждого пользователя в каждый момент времени посчитайте две накопительные суммы — числа оформленных
--и числа отменённых заказов. Если пользователь оформляет заказ, то число оформленных им заказов увеличивайте на 1,
--если отменяет — увеличивайте на 1 количество отмен.

--Колонки с накопительными суммами числа оформленных и отменённых заказов назовите соответственно created_orders и
--canceled_orders. На основе этих двух колонок для каждой записи пользователя посчитайте показатель cancel_rate, т.е.
--долю отменённых заказов в общем количестве оформленных заказов. Значения показателя округлите до двух знаков после запятой.
--Колонку с ним назовите cancel_rate.

--В результате у вас должны получиться три новые колонки с динамическими показателями, которые изменяются во времени
--с каждым новым действием пользователя.

--В результирующей таблице отразите все колонки из исходной таблицы вместе с новыми колонками.
--Отсортируйте результат по колонкам user_id, order_id, time — по возрастанию значений в каждой.

--Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

--Поля в результирующей таблице:

--user_id, order_id, action, time, created_orders, canceled_orders, cancel_rate

SELECT user_id,
       order_id,
       action,
       time,
       SUM(CASE 
           WHEN action = 'create_order'  THEN 1
           ELSE 0
           END) OVER (PARTITION BY user_id ORDER BY time) AS created_orders,
       SUM(CASE 
           WHEN action = 'cancel_order'  THEN 1
           ELSE 0
           END) OVER (PARTITION BY user_id ORDER BY time) AS canceled_orders,
       ROUND(SUM(CASE 
                 WHEN action = 'cancel_order'  THEN 1
                 ELSE 0
                 END) OVER (PARTITION BY user_id ORDER BY time) ::numeric / SUM(CASE 
                                                                      WHEN action = 'create_order'  THEN 1
                                                                      ELSE 0
                                                                      END) OVER (PARTITION BY user_id ORDER BY time), 2) AS cancel_rate
FROM user_actions
ORDER BY user_id, order_id, time
LIMIT 1000;
