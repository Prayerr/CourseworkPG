----------- Представление на выборку данных из нескольких таблиц с использованием условий отбора по нескольким полям -----------

-- Представление показывает информацию о ресторанах и их дополнительных данных из таблицы "restaurant_details"
CREATE VIEW restaurant_details_view AS
SELECT r.name, rd.additional_info
FROM restaurant r
JOIN restaurant_details rd ON r.id_details = rd.id_details;
-- Представление показывает отзывы о ресторанах.
CREATE VIEW restaurant_reviews_view AS
SELECT r.name, cr.rating, cr.review_text
FROM restaurant r
JOIN customer_reviews cr ON r.id_restaurant = cr.id_restaurant;
--  Представление отображает информацию о персонале ресторана
CREATE VIEW restaurant_staff_view AS
SELECT r.name, rs.name_staff, rs.position
FROM restaurant r
JOIN restaurant_staff rs ON r.id_restaurant = rs.id_restaurant;
-- Представление предоставляет информацию о местах в ресторане
CREATE VIEW restaurant_seating_view AS
SELECT r.name, s.seating_status, s.capacity
FROM restaurant r
JOIN seating s ON r.id_restaurant = s.id_restaurant;