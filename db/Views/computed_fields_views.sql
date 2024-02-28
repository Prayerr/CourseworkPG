----------- Создание представлений с использованием расчетных полей для моей базы данных: -----------

----------- Представление для расчета длительности каждого бронирования: -----------
CREATE VIEW reservation_duration AS
SELECT id_reservation, start_time, end_time, 
       end_time - start_time AS duration
FROM reservation;
----------- Представление для подсчета количества бронирований по каждому столику: -----------
CREATE VIEW table_reservation_counts AS
SELECT t.id_table, COUNT(r.id_reservation) AS reservation_count
FROM "table" t
LEFT JOIN reservation r ON t.id_table = r.id_table
GROUP BY t.id_table;