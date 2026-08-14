--2. Реализуйте триггер, который автоматически обновляет поле updated_at
--   при изменении записи
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER employees_updated_at_trigger
BEFORE UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

--3. orders и order_status_history.
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    status VARCHAR(100) NOT NULL
);

CREATE TABLE order_status_history (
    id SERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    old_status VARCHAR(100) NOT NULL,
    new_status VARCHAR(100) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION save_order_status_history()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO order_status_history (
        order_id,
        old_status,
        new_status,
        changed_at
    )
    VALUES (
        OLD.id,
        OLD.status,
        NEW.status,
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER order_status_history_trigger
AFTER UPDATE OF status
ON orders
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION save_order_status_history();

--4. запретить сохранение сотрудников с отрицательной заработной платой
CREATE OR REPLACE FUNCTION check_employee_salary()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'Зарплата не может быть отрицательной';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER employee_salary_check_trigger
BEFORE INSERT OR UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION check_employee_salary();

--5. триггер, который автоматически удаляет пробелы в начале и конце
CREATE OR REPLACE FUNCTION trim_product_name()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.name = TRIM(NEW.name);

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER product_name_trim_trigger
BEFORE INSERT OR UPDATE OF name
ON products
FOR EACH ROW
EXECUTE FUNCTION trim_product_name();

--6. журнал когда цена действительно изменилась
CREATE TABLE product_price_history (
    id SERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    old_price NUMERIC(10, 2) NOT NULL,
    new_price NUMERIC(10, 2) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION save_price_history()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO product_price_history (
        product_id,
        old_price,
        new_price,
        changed_at
    )
    VALUES (
        OLD.id,
        OLD.price,
        NEW.price,
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_price_history_trigger
AFTER UPDATE OF price
ON products
FOR EACH ROW
WHEN (OLD.price IS DISTINCT FROM NEW.price)
EXECUTE FUNCTION save_price_history();