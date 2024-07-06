--Произведите замену списков с id товаров из таблицы orders на списки с наименованиями товаров.
--Наименования возьмите из таблицы products. Колонку с новыми списками наименований назовите product_names. 

--Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

--Поля в результирующей таблице: order_id, product_names

WITH 
list_of_products AS
    (
    SELECT order_id,
           UNNEST (product_ids) AS product_id
    FROM orders
    )
SELECT list_of_products.order_id,
       ARRAY_AGG(products.name) AS product_names
FROM list_of_products
    LEFT JOIN products
    USING(product_id)
GROUP BY list_of_products.order_id
LIMIT 1000;
