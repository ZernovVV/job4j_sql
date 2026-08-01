CREATE TABLE vacancies
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title       TEXT        NOT NULL,
    company     TEXT        NOT NULL,
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO vacancies (title, company, description)
VALUES
    ('backend developer', 'Backstart ltd', 'backend ingeneer, free beer in office'),
    ('golang developer', 'Gog & Magog', 'golang developer with strong arms'),
    ('go developer', 'ООО "Гошная №5"', 'go developer with sence of humor');

SELECT   id, name, email
FROM     users
WHERE    email ILIKE '%mail%';

SELECT   id, name, price
FROM     products
WHERE    name ILIKE '%air%';

SELECT   id, name, price
FROM     products
WHERE    name ILIKE 'i%';

SELECT   id, name, price
FROM     products
WHERE    name ILIKE '%pro';

SELECT   id, name, email
FROM     users
WHERE    name ILIKE 'A%'
   OR    name ILIKE 'I%';

SELECT   id, title, company, description
FROM     vacancies
WHERE    title ~* '(java|go|postgres)'
   OR    description ~* '(java|go|postgres)';

SELECT   id, name, price
FROM     products
WHERE    name ~* '^iphone [0-9]+';