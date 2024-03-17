-- Процедура для на обновление данных поля “additional_info” в таблице “restaurant_details” и поля “cuisine_type” в таблице “cuisine”
CALL update_cuisine_and_additional_info('', 'Derivative', 'LOREM IPSUM');

-- Процедура на обновление название ресторана и его адреса
CALL update_address_and_name_restaurant('', 'NAMERESTAURANT', 'RANDOMCOUNTRY', 'RANDOMSTATE', 'RANDOMCITY', 'RANDOMSTREET');

SELECT r.name AS restaurant_name, ra.country, ra.state, ra.city, ra.street, r.id_address AS address_id FROM restaurant r
INNER JOIN restaurant_address ra ON r.id_address = ra.id_address;

-- Процедура на обновление всей информации о ресторане
CALL update_restaurant_full_info('', 'TESTNAME', '79999999999', 'TESTCOUNTRY', 'TESTSTATE','TESTCITY', 'TESTSTREET', '09:00:00', '18:00:00', 'American', 'LOREM IPSUM');

SELECT 
    r.id_restaurant,
    r.name AS restaurant_name,
    r.restaurant_phone,
    ra.country,
    ra.state,
    ra.city,
    ra.street,
    wh.opening_time,
    wh.closing_time,
    c.cuisine_type,
    rd.additional_info
FROM restaurant AS r
JOIN restaurant_address AS ra ON r.id_address = ra.id_address
JOIN working_hours AS wh ON r.id_working_hours = wh.id_working_hours
JOIN restaurant_details AS rd ON r.id_details = rd.id_details
JOIN cuisine AS c ON rd.id_cuisine = c.id_cuisine
WHERE r.id_restaurant = 'b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1';