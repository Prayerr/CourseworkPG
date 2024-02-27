----------- Представление на выборку данных из нескольких таблиц с использованием условий отбора по нескольким полям -----------

----------- Представление для отображения информации о ресторане и его адресе: -----------
CREATE VIEW restaurant_info_with_address AS
SELECT r.id_restaurant, r.name, r.opening_hours, r.restaurant_phone,
       ra.country, ra.state, ra.city, ra.street
FROM restaurant_info r
JOIN restaurant_address ra ON r.id_restaurant = ra.id_restaurant;
-----------     Представление для отображения информации о клиентах и их бронировании: -----------
CREATE VIEW customer_reservations AS
SELECT c.id_customer, c.name, c.customer_phone, c.email,
       r.id_reservation, r.start_time, r.end_time
FROM customer c
JOIN reservation r ON c.id_customer = r.id_customer;
----------- Представление для отображения информации о столиках ресторана и его названии: -----------
CREATE VIEW table_info_with_restaurant_name AS
SELECT t.id_table, t.capacity, t.is_available,
       r.name AS restaurant_name
FROM "table" t
JOIN restaurant_info r ON t.id_restaurant = r.id_restaurant;
----------- Представление для отображения информации о аренде с подробностями о ресторане: -----------
CREATE VIEW reservation_details_with_restaurant AS
SELECT r.id_reservation, r.description, r.start_time, r.end_time,
       t.id_table, t.capacity, t.is_available,
       ri.name AS restaurant_name, ri.opening_hours
FROM reservation r
JOIN "table" t ON r.id_table = t.id_table
JOIN restaurant_info ri ON t.id_restaurant = ri.id_restaurant;