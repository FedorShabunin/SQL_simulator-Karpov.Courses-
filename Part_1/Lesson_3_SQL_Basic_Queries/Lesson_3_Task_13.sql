--Вновь, как и в прошлом задании, повысьте цену всех товаров на 5%, только теперь к колонке с новой ценой --примените функцию ROUND. Выведите id и наименования товаров, их старую цену, а также новую цену с 
--округлением. Новую цену округлите до одного знака после запятой, но тип данных не меняйте.

--Результат отсортируйте сначала по убыванию новой цены, затем по возрастанию id товара.

--Поля в результирующей таблице: product_id, name, old_price, new_price

SELECT product_id,
       name,
       price AS old_price,
       ROUND((price * 1.05), 1) AS new_price
FROM   products
ORDER BY new_price DESC, product_id;
