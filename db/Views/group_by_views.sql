----------- Представление с использованием групповых операций   -----------

-- Представление показывает количество бронирований, сделанных в каждый день
CREATE VIEW daily_reservation_count_view AS
SELECT reservation_date, COUNT(*) AS reservations_count
FROM reservations
GROUP BY reservation_date;
-- Представление показывает популярность типов кухонь среди ресторанов
CREATE VIEW cuisine_popularity_view AS
SELECT c.cuisine_type, COUNT(*) AS restaurant_count
FROM cuisine c
JOIN restaurant_details rd ON c.id_cuisine = rd.id_cuisine
GROUP BY c.cuisine_type;
-- Представление показывает количество сотрудников в каждом ресторане
CREATE VIEW staff_count_per_restaurant_view AS
SELECT id_restaurant, COUNT(*) AS staff_count
FROM restaurant_staff
GROUP BY id_restaurant;