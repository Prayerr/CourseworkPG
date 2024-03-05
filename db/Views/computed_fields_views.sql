----------- Создание представлений с использованием расчетных полей для моей базы данных: -----------

-- Представление показывает общее количество мест в каждом ресторане
CREATE VIEW restaurant_seating_capacity_view AS
SELECT id_restaurant, COUNT(*) AS total_seats
FROM seating
GROUP BY id_restaurant;
-- Представление показывает среднюю оценку ресторана на основе отзывов
CREATE VIEW average_review_rating_view AS
SELECT id_restaurant, AVG(rating) AS avg_rating
FROM customer_reviews
GROUP BY id_restaurant;