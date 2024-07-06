--Из таблицы orders выведите id и содержимое заказов, которые включают хотя бы один из пяти самых дорогих товаров, --доступных в нашем сервисе.

--Результат отсортируйте по возрастанию id заказа.

--Поля в результирующей таблице: order_id, product_ids

SELECT order_id,
       product_ids
FROM orders
WHERE (SELECT ARRAY(SELECT product_id
                    FROM products
                    ORDER BY price DESC
                    LIMIT 5) ) && product_ids
ORDER BY order_id;
