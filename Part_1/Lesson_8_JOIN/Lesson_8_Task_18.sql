--По таблицам orders и courier_actions определите id десяти заказов, которые доставляли дольше всего.

--Поле в результирующей таблице: order_id

SELECT orders.order_id
FROM orders
    RIGHT JOIN (SELECT order_id,
                      time
               FROM courier_actions
               WHERE action = 'deliver_order') AS delivery_time
    USING(order_id)
ORDER BY (delivery_time.time - orders.creation_time) DESC
LIMIT 10;
