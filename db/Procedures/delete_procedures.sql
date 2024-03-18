-- Удаление всей информации о ресторане (Отлов на наличие бронирований сделал)
CREATE PROCEDURE delete_restaurant(
    p_restaurant_id UUID
) AS $$
DECLARE
    reservation_count INT;
BEGIN
    SELECT COUNT(*) INTO reservation_count
    FROM reservations
    WHERE id_seating IN (SELECT id_seating FROM seating WHERE id_restaurant = p_restaurant_id);

    IF reservation_count > 0 THEN
        RAISE EXCEPTION 'Невозможно удалить данный ресторан, пока имеются бронирования в нём';
    ELSE
        DELETE FROM reservations WHERE id_seating IN (SELECT id_seating FROM seating WHERE id_restaurant = p_restaurant_id);
        DELETE FROM seating WHERE id_restaurant = p_restaurant_id;
        DELETE FROM restaurant_staff WHERE id_restaurant = p_restaurant_id;
        DELETE FROM restaurant_special_offers WHERE id_restaurant = p_restaurant_id;
        DELETE FROM customer_reviews WHERE id_restaurant = p_restaurant_id;
        DELETE FROM restaurant WHERE id_restaurant = p_restaurant_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Удаление отзыва с бронированием (клиент не удаляется)
CREATE PROCEDURE delete_review_and_reservation(
    p_id_review UUID
) AS $$
BEGIN
    DELETE FROM reservations WHERE id_customer IN (SELECT id_customer FROM customer_reviews WHERE id_review = p_id_review);
    DELETE FROM customer_reviews WHERE id_review = p_id_review;
END;
$$ LANGUAGE plpgsql;

-- Удаление всей информации о клиенте (бронирование и отзыв тоже)
CREATE PROCEDURE delete_customer(
    p_customer_id UUID
) AS $$
BEGIN
    DELETE FROM reservations WHERE id_customer = p_customer_id;
    DELETE FROM customer_reviews WHERE id_customer = p_customer_id;
    DELETE FROM customer WHERE id_customer = p_customer_id;
END;
$$ LANGUAGE plpgsql;