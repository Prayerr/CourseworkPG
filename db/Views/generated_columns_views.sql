----------- Представление с использованием генерируемых столбцов (сохраняемых и не сохраняемых) ---------

-- Представление которое будет выводить количество дней, оставшихся до окончания каждого специального предложения
CREATE VIEW remaining_days_until_offer_end AS
SELECT id_offer, offer_name, description, start_offer, end_offer, end_offer - CURRENT_DATE AS days_remaining
FROM restaurant_special_offers;
-- Представление показывает контактную информацию клиентов (Сохраняемое)
CREATE VIEW customer_contact_info_view AS
SELECT id_customer, CONCAT(name_customer, ' - ', customer_phone) AS contact_info
FROM customer;