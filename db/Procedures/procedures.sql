-- Процедура для на обновление данных поля “additional_info” в таблице “restaurant_details” и поля “cuisine_type” в таблице “cuisine”
CREATE PROCEDURE update_cuisine_and_additional_info(
    p_id_cuisine UUID,
    p_additional_info VARCHAR(512),
    p_cuisine_type cuisine_type
) AS $$
BEGIN
    UPDATE cuisine
    SET cuisine_type = p_cuisine_type
    WHERE id_cuisine = p_id_cuisine;

    UPDATE restaurant_details
    SET additional_info = p_additional_info
    WHERE id_cuisine = p_id_cuisine;
END
$$ LANGUAGE plpgsql;

-- Процедура на обновление название ресторана и его адреса
CREATE PROCEDURE update_address_and_name_restaurant(
    p_id_address UUID,
    p_name VARCHAR(64),
    p_country VARCHAR(128),
    p_state VARCHAR(128),
    p_city VARCHAR(128),
    p_street VARCHAR(128)
) AS $$
BEGIN
    UPDATE restaurant
    SET name = p_name
    WHERE id_address = p_id_address;

    UPDATE restaurant_address
    SET country = p_country,
    state = p_state,
    city = p_city,
    street = p_street
    WHERE id_address = p_id_address;
END
$$ LANGUAGE plpgsql;

-- Процедура на обновление всей информации о ресторане
CREATE PROCEDURE update_restaurant_full_info(
    p_id_restaurant UUID,
    p_name VARCHAR(64),
    p_restaurant_phone VARCHAR(24),
    p_country VARCHAR(128),
    p_state VARCHAR(128),
    p_city VARCHAR(128),
    p_street VARCHAR(128),
    p_opening_time TIME,
    p_closing_time TIME,
    p_cuisine_type cuisine_type,
    p_additional_info VARCHAR(512)
) AS $$
BEGIN
    UPDATE restaurant
    SET name = p_name,
    restaurant_phone = p_restaurant_phone
    WHERE id_restaurant = p_id_restaurant;
    
    UPDATE restaurant_address
    SET country = p_country,
    state = p_state,
    city = p_city,
    street = p_street
    WHERE id_address = (SELECT id_address FROM restaurant WHERE id_restaurant = p_id_restaurant);
    
    UPDATE working_hours
    SET opening_time = p_opening_time,
    closing_time = p_closing_time
    WHERE id_working_hours = (SELECT id_working_hours FROM restaurant WHERE id_restaurant = p_id_restaurant);
    
    UPDATE cuisine
    SET cuisine_type = p_cuisine_type
    WHERE id_cuisine = (SELECT id_cuisine FROM restaurant_details WHERE id_details = (SELECT id_details FROM restaurant WHERE id_restaurant = p_id_restaurant));
    
    UPDATE restaurant_details
    SET additional_info = p_additional_info
    WHERE id_details = (SELECT id_details FROM restaurant WHERE id_restaurant = p_id_restaurant);
END
$$ LANGUAGE plpgsql;