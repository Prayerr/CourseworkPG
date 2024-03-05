----------- Представления с использованием оконных функций: -----------

-- Представление показывающее кол-во отзывов у всех ресторанов
CREATE VIEW restaurant_review_count_view AS
SELECT id_restaurant, COUNT(*) AS review_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM customer_reviews
GROUP BY id_restaurant;
-- Представление показывает список недавних бронирований, отсортированных по дате бронирования в обратном порядке
CREATE VIEW recent_reservations_view AS
SELECT id_reservation, id_customer, id_seating, reservation_date,
       ROW_NUMBER() OVER (ORDER BY reservation_date DESC) AS row_num
FROM reservations;