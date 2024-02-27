----------- Представление с использованием групповых операций   -----------

----------- Представление для вычисления средней вместимости столиков в каждом ресторана: -----------
CREATE VIEW avg_table_capacity_per_restaurant AS
SELECT id_restaurant, 
       AVG(capacity) AS avg_capacity
FROM "table"
GROUP BY id_restaurant;
----------- Представление для подсчета количества ресторанов в каждом городе: -----------
CREATE VIEW restaurant_count_by_city AS
SELECT city, COUNT(id_restaurant) AS restaurant_count
FROM restaurant_address
GROUP BY city;
----------- Представление для подсчета общего количества бронирований в каждом ресторане: -----------
CREATE VIEW total_reservations_per_restaurant AS
SELECT r.id_restaurant, COUNT(res.id_reservation) AS total_reservations
FROM restaurant_info r
LEFT JOIN "table" t ON r.id_restaurant = t.id_restaurant
LEFT JOIN reservation res ON t.id_table = res.id_table
GROUP BY r.id_restaurant;
