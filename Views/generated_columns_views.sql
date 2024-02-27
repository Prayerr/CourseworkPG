----------- Представление с использованием генерируемых столбцов (сохраняемых и не сохраняемых) ---------

--- Представления для создания (CОХРАНЯЕМЫМ ГЕНЕРИРУЕМЫМ) нового столбца full_address, который содержит полный адрес ресторана, объединяя страну, город и улицу из таблицы restaurant_address: ----
CREATE VIEW saved_generated_columns_view AS
SELECT id_restaurant, name, opening_hours, restaurant_phone,
       CONCAT(country, ', ', city, ', ', street) AS full_address
FROM restaurant_info
JOIN restaurant_address USING (id_restaurant);

--- Представления для создания (НЕ CОХРАНЯЕМЫМ ГЕНЕРИРУЕМЫМ) нового столбца reservation_status, который указывает статус каждого бронирования на основе текущего времени: ----
CREATE VIEW non_saved_generated_columns_view AS
SELECT id_reservation, id_customer, id_table, description,
       CASE
           WHEN start_time < current_time THEN 'Past Reservation'
           WHEN start_time > current_time THEN 'Future Reservation'
           ELSE 'Ongoing Reservation'
       END AS reservation_status
FROM reservation;