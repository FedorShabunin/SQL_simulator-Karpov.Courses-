--По таблицам courier_actions , orders и products определите 10 самых популярных товаров, доставленных в сентябре 2022 года.

--Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. 
--Если товар встречается в одном заказе несколько раз (было куплено несколько единиц товара), 
--то при подсчёте учитываем только одну единицу товара.

--Выведите наименования товаров и сколько раз они встречались в заказах. 
--Новую колонку с количеством покупок товара назовите times_purchased. 

--Поля в результирующей таблице: name, times_purchased

WITH
september_orders AS
    (
    SELECT order_id
    FROM courier_actions
    WHERE action = 'deliver_order' 
        AND DATE_TRUNC('month', time) = '2022-09-01'
    ),
list_of_products AS
    (
    SELECT DISTINCT order_id,
                    UNNEST(product_ids) AS product_id
    FROM orders
    WHERE order_id IN (SELECT *
                       FROM september_orders)
    )
SELECT products.name,
       COUNT(list_of_products.product_id) AS times_purchased
FROM list_of_products
    LEFT JOIN products
    USING(product_id)
GROUP BY products.name
ORDER BY COUNT(list_of_products.product_id) DESC
LIMIT 10;
