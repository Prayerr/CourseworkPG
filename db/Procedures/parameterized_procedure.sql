-- Вся информация о клиенте по его UUID --

CREATE OR REPLACE PROCEDURE get_customer_info(IN customer_id UUID)
LANGUAGE SQL
AS $$
BEGIN
    SELECT * FROM customer WHERE id_customer = customer_id;
END;
$$;