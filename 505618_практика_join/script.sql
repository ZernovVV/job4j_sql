--1. вывести кузова, которые не используются ни в одной машине
SELECT
    cb.id,
    cb.name AS "название кузова"
FROM car_bodies AS cb
LEFT JOIN cars AS c
    ON cb.id = c.body_id
WHERE c.body_id IS NULL;

--2. вывести двигатели, которые не используются ни в одной машине
SELECT
    e.id,
    e.name AS "название двигателя"
FROM car_engines AS e
LEFT JOIN cars AS c
    ON e.id = c.engine_id
WHERE c.engine_id IS NULL;

--3. вывести коробки передач, которые не используются ни в одной машине
SELECT
    t.id,
    t.name AS "название коробки передач"
FROM car_transmissions AS t
LEFT JOIN cars AS c
    ON t.id = c.transmission_id
WHERE c.transmission_id IS NULL;

--4. вывести список всех машин и название кузова, если оно указано
SELECT
    c.id,
    c.name AS car_name,
    cb.name AS body_name
FROM cars AS c
LEFT JOIN car_bodies AS cb
    ON c.body_id = cb.id;

--5. вывести только те машины, у которых одновременно указаны
--кузов;
--двигатель;
--коробка передач
SELECT
    c.id,
    c.name AS car_name,
    cb.name AS body_name,
    e.name AS engine_name,
    t.name AS transmission_name
FROM cars AS c
JOIN car_bodies AS cb
    ON c.body_id = cb.id
JOIN car_engines AS e
    ON c.engine_id = e.id
JOIN car_transmissions AS t
    ON c.transmission_id = t.id;

--6. вывести машины, у которых есть двигатель, но нет кузова
SELECT
    c.id,
    c.name AS car_name,
    cb.name AS body_name,
    e.name AS engine_name
FROM cars AS c
JOIN car_engines AS e
    ON c.engine_id = e.id
LEFT JOIN car_bodies AS cb
    ON c.body_id = cb.id
WHERE c.body_id IS NULL;

--7. вывести все кузова и машины, которые их используют
SELECT
    cb.id AS body_id,
    cb.name AS body_name,
    c.id AS car_id,
    c.name AS car_name
FROM car_bodies AS cb
LEFT JOIN cars AS c
    ON cb.id = c.body_id
ORDER BY cb.id;

--8. вывести неиспользуемые двигатели
SELECT
    e.id,
    e.name AS engine_name
FROM car_engines AS e
LEFT JOIN cars AS c
    ON e.id = c.engine_id
WHERE c.engine_id IS NULL;

--9. вывести машины и все их детали, но только для машин с автоматической коробкой передач
SELECT
    c.id,
    c.name AS car_name,
    cb.name AS body_name,
    e.name AS engine_name,
    t.name AS transmission_name
FROM cars AS c
LEFT JOIN car_bodies AS cb
    ON c.body_id = cb.id
LEFT JOIN car_engines AS e
    ON c.engine_id = e.id
JOIN car_transmissions AS t
    ON c.transmission_id = t.id
WHERE t.name ILIKE 'automatic%';

--10. вывести машины, у которых отсутствует хотя бы одна деталь
SELECT
    c.id,
    c.name AS car_name,
    cb.name AS body_name,
    e.name AS engine_name,
    t.name AS transmission_name
FROM  cars AS c
LEFT JOIN car_bodies AS cb
    ON c.body_id = cb.id
LEFT JOIN car_engines AS e
    ON c.engine_id = e.id
LEFT JOIN car_transmissions AS t
    ON c.transmission_id = t.id
WHERE c.body_id IS NULL OR c.engine_id IS NULL OR c.transmission_id IS NULL;

--11. вывести все машины с двигателями, но коробку передач подключить так, чтобы машины без коробки тоже попали в результат
SELECT
    c.id,
    c.name AS car_name,
    e.name AS engine_name,
    t.name AS transmission_name
FROM cars AS c
JOIN car_engines AS e
    ON c.engine_id = e.id
LEFT JOIN car_transmissions AS t
    ON c.transmission_id = t.id;

--12. вывести все неиспользуемые детали в едином формате
SELECT
    'body' AS detail_type,
    cb.id AS detail_id,
    cb.name AS detail_name
FROM car_bodies AS cb
LEFT JOIN cars AS c
    ON cb.id = c.body_id
WHERE c.body_id IS NULL
UNION ALL
SELECT
    'engine' AS detail_type,
    e.id AS detail_id,
    e.name AS detail_name
FROM car_engines AS e
LEFT JOIN cars AS c
    ON e.id = c.engine_id
WHERE c.engine_id IS NULL
UNION ALL
SELECT
    'transmission' AS detail_type,
    t.id AS detail_id,
    t.name AS detail_name
FROM car_transmissions AS t
LEFT JOIN cars AS c
    ON t.id = c.transmission_id
WHERE c.transmission_id IS NULL;

--13. вывести машины и детали только для кузовов определенных типов
SELECT
    c.id,
    c.name AS car_name,
    cb.name AS body_name,
    e.name AS engine_name,
    t.name AS transmission_name
FROM  cars AS c
LEFT JOIN car_bodies AS cb
    ON c.body_id = cb.id
LEFT JOIN car_engines AS e
    ON c.engine_id = e.id
LEFT JOIN car_transmissions AS t
    ON c.transmission_id = t.id
WHERE cb.name IN ('sedan', 'hatchback', 'suv');