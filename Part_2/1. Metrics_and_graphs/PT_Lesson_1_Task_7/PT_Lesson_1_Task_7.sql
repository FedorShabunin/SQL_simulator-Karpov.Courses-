--На основе данных в таблице courier_actions для каждого дня рассчитайте, за сколько минут в среднем курьеры доставляли свои заказы.

--Колонку с показателем назовите minutes_to_deliver. Колонку с датами назовите date.
--При расчёте среднего времени доставки округляйте количество минут до целых значений.
--Учитывайте только доставленные заказы, отменённые заказы не учитывайте.

--Результирующая таблица должна быть отсортирована по возрастанию даты.

--Поля в результирующей таблице: date, minutes_to_deliver

WITH
canceled_orders AS
    (
    SELECT order_id
    FROM user_actions
    WHERE action = 'cancel_order'
    ),
time_between_orders AS
    (
    SELECT courier_id,
           order_id,
           time,
           EXTRACT(EPOCH FROM AGE(time, LAG(time, 1) OVER (PARTITION BY courier_id, order_id ORDER BY time))) AS diff_time
    
    FROM courier_actions
    WHERE order_id NOT IN (SELECT order_id
                           FROM canceled_orders)
    )
SELECT time ::DATE AS date,
       ROUND(AVG(diff_time) / 60) ::INT AS minutes_to_deliver
FROM time_between_orders

GROUP BY time ::DATE
ORDER BY time ::DATE;
