-- Вся информация о всех клиентах --

CREATE OR REPLACE PROCEDURE get_all_customers()
LANGUAGE SQL
AS $$
BEGIN
    SELECT * FROM customer;
END;
$$;