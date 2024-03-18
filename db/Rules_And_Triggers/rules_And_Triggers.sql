-- Триггер который гарантирует что номер телефона ресторана содержит только цифры и не превышает 24 символа
CREATE FUNCTION validate_phone_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.restaurant_phone ~ '^[0-9]{1,24}$' THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Номер телефона должен содержать только цифры и не превышать 24 символа.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_phone_number_validation
BEFORE INSERT OR UPDATE OF restaurant_phone ON restaurant
FOR EACH ROW
EXECUTE FUNCTION validate_phone_number();

-- Триггер будет автоматически обновлять время изменения отзыва при его обновлении.
CREATE FUNCTION update_review()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_review_trigger
BEFORE UPDATE ON customer_reviews
FOR EACH ROW
WHEN (OLD.rating IS DISTINCT FROM NEW.rating OR OLD.review_text IS DISTINCT FROM NEW.review_text)
EXECUTE FUNCTION update_review();

-- Триггер для проверки ограничения времени работы ресторана
CREATE FUNCTION validate_working_hours()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.closing_time < NEW.opening_time THEN
        RAISE EXCEPTION 'Время закрытия работы ресторана не может быть раньше чем начало работы ресторана';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_working_hours_trigger
BEFORE INSERT OR UPDATE OF opening_time, closing_time ON working_hours
FOR EACH ROW
EXECUTE FUNCTION validate_working_hours();
