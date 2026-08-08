--1. вывести всех пользователей и количество их заказов, включая пользователей
SELECT
    u.id as user_id,
    u.name as user_name,
    COUNT(o.id)
FROM users AS u
LEFT JOIN orders AS o ON o.user_id = u.id
GROUP BY u.id
ORDER BY u.id;

--2. найти заказы, по которым еще не было платежа
SELECT
    o.id AS order_id,
    o.status AS "статус заказа",
    o.created_at AS "время создания заказа"
FROM orders AS o
LEFT JOIN payments AS p ON o.id = p.order_id
WHERE p.order_id IS NULL;

--3. вывести товары, которые встречались хотя бы в одном заказе, и рядом показать,
-- сколько раз они встречались в order_items.
SELECT
    p.id AS product_id,
    p.name AS product_name,
    COUNT(oi.id) AS "количество строк заказа, где товар встречался"
 FROM products AS p
 JOIN order_items AS oi ON p.id = oi.product_id
 GROUP BY p.id, p.name;

--4. вывести все роли и количество пользователей, которым назначена каждая роль
SELECT
	r.code AS role_code,
	COUNT (ur.user_id) AS user_count
FROM roles r
LEFT JOIN user_roles ur ON r.id = ur.role_id
GROUP BY r.id
ORDER BY r.code;

--5. найти пользователей, которым не назначена ни одна роль
SELECT
    u.id,
    u.name,
    u.email,
    u.phone
FROM users AS u
LEFT JOIN user_roles AS ur ON u.id = ur.user_id
WHERE ur.user_id IS NULL;

--6. сделать сверочный запрос по ролям и назначениям ролей так,
-- чтобы в результате были видны:
--   роли, назначенные пользователям
--   роли без пользователей
--   все пары role ↔ user, которые существуют
SELECT
    r.code,
    ur.user_id
FROM roles AS r
FULL JOIN user_roles AS ur ON ur.role_id = r.id
ORDER BY r.code;

--7. построить все комбинации “роль × окружение”
SELECT
    r.code AS "роль",
    e.code AS "окружение"
FROM roles AS r
CROSS JOIN environments AS e;

--8. вывести все категории вместе с именем их родительской категории
--   корневые категории тоже должны попасть в результат
--   для них имя родителя будет NULL
SELECT
    c.name AS "категория",
    p.name AS "родительская категория"
FROM categories AS c
LEFT JOIN categories AS p ON c.parent_id = p.id;