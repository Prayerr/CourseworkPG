----------- Представление с использованием генерируемых столбцов (сохраняемых и не сохраняемых) ---------

-- Представление показывает длительность каждого бронирования в минутах
CREATE VIEW reservation_duration_view AS
SELECT id_reservation, 
       TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duration_minutes
FROM reservations;
-- Представление показывает контактную информацию клиентов
CREATE VIEW customer_contact_info_view AS
SELECT id_customer, CONCAT(name, ' - ', customer_phone) AS contact_info
FROM customer;