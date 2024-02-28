----------- Представления с использованием оконных функций: -----------


----------- Представление для вычисления средней продолжительности аренды по каждому клиенту: -----------
CREATE VIEW avg_reservation_duration_per_customer AS
SELECT id_customer, 
       AVG(end_time - start_time) OVER (PARTITION BY id_customer) AS avg_duration
FROM reservation;
----------- Представление для отображения ранжирования ресторанов по количеству бронирований: -----------
CREATE VIEW restaurant_reservation_ranking AS
SELECT id_restaurant, name,
       RANK() OVER (ORDER BY reservation_count DESC) AS reservation_rank
FROM (
    SELECT t.id_restaurant, ri.name, COUNT(r.id_reservation) AS reservation_count
    FROM "table" t
    JOIN reservation r ON t.id_table = r.id_table
    JOIN restaurant_info ri ON t.id_restaurant = ri.id_restaurant
    GROUP BY t.id_restaurant, ri.name
) AS restaurant_reservation_counts;