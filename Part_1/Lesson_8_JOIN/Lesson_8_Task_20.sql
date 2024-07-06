--Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте заказы с наибольшим числом товаров.

--Выведите id заказа, id пользователя и id курьера. Также в отдельных колонках укажите возраст пользователя и возраст курьера.
--Возраст измерьте числом полных лет, как мы делали в прошлых уроках.
--Считайте его относительно последней даты в таблице user_actions — как для пользователей, так и для курьеров.
--Колонки с возрастом назовите user_age и courier_age. Результат отсортируйте по возрастанию id заказа.

--Поля в результирующей таблице: order_id, user_id, user_age, courier_id, courier_age

WITH 
max_date AS (
    SELECT MAX(time)
    FROM user_actions
    ),
canceled_orders AS 
    (
    SELECT order_id
    FROM   user_actions
    WHERE  action = 'cancel_order'
    ),
max_size_order AS 
    (
    SELECT MAX(ARRAY_LENGTH(product_ids, 1)) AS max_number_of_products
    FROM orders
    ),
not_canceled_max_orders AS
    (
    SELECT order_id
    FROM orders
    WHERE order_id NOT IN (SELECT *
                           FROM canceled_orders)
        AND ARRAY_LENGTH(product_ids, 1) = (SELECT *
                                            FROM max_size_order)
    )
SELECT DISTINCT not_canceled_max_orders.order_id,
       user_actions.user_id,
       EXTRACT(YEAR FROM (AGE((SELECT *
                    FROM max_date), users.birth_date))) ::int AS user_age,
       courier_actions.courier_id,
       EXTRACT(YEAR FROM (AGE((SELECT *
                    FROM max_date), couriers.birth_date)))::int AS courier_age
FROM not_canceled_max_orders
    LEFT JOIN user_actions
    USING (order_id)
    LEFT JOIN courier_actions
    USING (order_id)
    LEFT JOIN couriers
    USING (courier_id)
    LEFT JOIN users
    USING (user_id)
ORDER BY not_canceled_max_orders.order_id;
