-- Функция которая делает проверку доступа к записям таблицы "бронирования" на основе UUID клиента
CREATE FUNCTION allow_reservation_access(uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (current_setting('auth.id_customer', TRUE)::UUID = uuid);
END;
$$ LANGUAGE plpgsql;

-- Функция которая делает проверку доступа к записям таблицы "отзывы" на основе UUID клиента
CREATE FUNCTION allow_review_access()
RETURNS BOOLEAN AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        RETURN TRUE;

    ELSIF TG_OP = 'UPDATE' THEN
        RETURN (current_setting('auth.id_customer', TRUE)::UUID = (SELECT id_customer FROM customer_reviews WHERE id = NEW.id));
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Функция которая делает проверку доступа к записям таблицы "клиенты" на основе UUID клиента
CREATE FUNCTION allow_customer_access(uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (current_setting('auth.id_customer', TRUE)::UUID = uuid);
END;
$$ LANGUAGE plpgsql;

-- Политка на таблицу с бронированиями
CREATE POLICY reservation_policy
ON reservations
FOR ALL
USING (allow_reservation_access(id_customer));

-- Политка на таблицу с отзывами
CREATE POLICY review_policy
ON customer_reviews
FOR ALL
USING (allow_review_access());

-- Политка на таблицу с клиентами
CREATE POLICY customer_policy
ON customer
FOR ALL
USING (allow_customer_access(id_customer));

-- Включение политки с бронированиями
ALTER TABLE reservations
ENABLE ROW LEVEL SECURITY;

-- Включение политки с отзывами
ALTER TABLE customer_reviews
ENABLE ROW LEVEL SECURITY;

-- Включение политки с клиентами
ALTER TABLE customer
ENABLE ROW LEVEL SECURITY;

-- Ставлю UUID по умолчанию
ALTER ROLE client1 SET auth.id_customer TO '47a59dfd-9d2d-4d68-ae18-3d853c99294f';

-- Ставлю UUID для тек. сессии
SET auth.id_customer TO '47a59dfd-9d2d-4d68-ae18-3d853c99294f';