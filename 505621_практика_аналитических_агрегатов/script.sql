--1. Лучшие клиенты (TOP)
SELECT
    o.customer_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY o.customer_name
ORDER BY total_revenue DESC
LIMIT 2;

--2. Фильтрация категорий (HAVING)
SELECT
    p.category,
    SUM(oi.quantity) AS total_items_sold,
    SUM(oi.quantity * p.price) AS category_revenue
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category
HAVING SUM(oi.quantity * p.price) > 30_000;

--3. Ловушка среднего (CTE + AVG)
WITH order_items_count AS (
    SELECT
    oi.order_id,
    COUNT(*) AS items_count
    FROM order_items AS oi
    JOIN orders AS o
        ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY oi.order_id
)
SELECT AVG(items_count) AS avg_items_per_order
FROM order_items_count;