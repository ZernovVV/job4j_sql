--1. для каждого статуса заказа вывести количество заказов
SELECT
    status,
    COUNT(*) AS orders_count
FROM orders
GROUP BY status;

--2. для каждого пользователя вывести общую сумму всех его заказов
SELECT
    u.id AS user_id,
    u.name AS user_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM users AS u
JOIN orders AS o
    ON o.user_id = u.id
JOIN order_items AS oi
    ON oi.order_id = o.id
GROUP BY u.id, u.name;

--3. для каждого товара вывести:
    --сколько раз этот товар встретился в строках заказа;
    --сколько единиц товара было продано суммарно
SELECT
    p.id AS product_id,
    p.name AS product_name,
    COUNT(oi.id) AS order_items_count,
    COALESCE(SUM(oi.quantity), 2) AS total_quantity
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.id = oi.product_id
GROUP BY p.id, p.name;

--4. для каждого заказа вывести:
    --order_id
    --количество строк в заказе;
    --итоговую сумму заказа
SELECT
    o.id AS order_id,
    COUNT(oi.id) AS items_count,
    COALESCE(SUM(oi.quantity), 2) AS order_total
FROM orders AS o
LEFT JOIN order_items AS oi
    ON o.id = oi.order_id
GROUP BY o.id;

--5. для каждого пользователя и для каждого статуса его заказов вывести количество таких заказов
SELECT
    u.id AS user_id,
    u.name AS user_name,
    o.status,
    COUNT(o.id) AS orders_count
FROM users AS u
LEFT JOIN orders AS o
    ON u.id = o.user_id
GROUP BY u.id,u.name, o.status
ORDER BY u.name;

--6. вывести минимальную, максимальную и среднюю цену продажи по каждому товару на основании order_items
SELECT
    product_id,
    p.name AS product_name,
    MIN(oi.unit_price) min_unit_price,
    MAX(oi.unit_price) max_unit_price,
    AVG(oi.unit_price) avg_unit_price
FROM order_items AS oi
JOIN products AS p
    ON p.id = oi.product_id
GROUP BY oi.product_id, p.name;

--7. вывести пользователей и количество их заказов, включая пользователей, у которых заказов нет
SELECT
    u.id AS user_id,
    u.name AS user_name,
    COUNT(o.id) AS orders_count
FROM users AS u
LEFT JOIN orders AS o
    ON u.id = o.user_id
GROUP BY u.id, u.name;