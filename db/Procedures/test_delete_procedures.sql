-- Тест на процедуру которая удаляет всю информацию о ресторане
CALL delete_restaurant('');

-- Тест на процедуру которая удаляет отзыв с бронированием (SELECT для выведения списка отзывов где есть бронирования)
SELECT cr.id_review, cr.id_customer, cr.id_restaurant, cr.review_text,
       r.id_reservation, r.id_customer AS reservation_customer_id, r.id_seating, r.reservation_status
FROM customer_reviews cr
LEFT JOIN reservations r ON cr.id_customer = r.id_customer
WHERE cr.id_review = '';

SELECT DISTINCT cr.id_review
FROM customer_reviews cr
INNER JOIN reservations r ON cr.id_customer = r.id_customer;

-- Тест на процедуру которая удаляет всю информацию о клиенте
SELECT cr.id_review, cr.id_customer,
       c.name_customer,
       r.id_reservation
FROM customer_reviews cr
JOIN customer c ON cr.id_customer = c.id_customer
JOIN reservations r ON cr.id_customer = r.id_customer;