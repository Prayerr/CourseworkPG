-- Тест для "Триггер который гарантирует что номер телефона ресторана содержит только цифры и не превышает 24 символа"
INSERT INTO restaurant (id_restaurant, restaurant_phone) VALUES('', '77777ba');

-- Тест для "Триггер будет автоматически обновлять время изменения отзыва при его обновлении."
UPDATE customer_reviews SET rating = 1 WHERE id_review = '';

-- Тест для "Триггер для проверки ограничения времени работы ресторана"
UPDATE working_hours SET closing_time = '00:00:00' WHERE id_working_hours = '';