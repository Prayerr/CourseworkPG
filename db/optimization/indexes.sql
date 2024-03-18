-- Индекс на поиск бронирований по айди клиента
CREATE INDEX idx_reservations_customer ON reservations (id_customer);

-- Индекс на поиск бронирований по айди ресторана
CREATE INDEX idx_reservations_restaurant ON reservations (id_restaurant);

-- Индекс на поиск бронирований по айди столика
CREATE INDEX idx_reservations_seating ON reservations (id_seating);
