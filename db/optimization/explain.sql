ANALYZE;

-- Поиск бронирований по клиенту
EXPLAIN SELECT * FROM reservations WHERE id_customer = '';
