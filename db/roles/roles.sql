-- Админ ресторана, имеет полный доступ CRUD к таблице с сотрудниками ресторана и спец. предложениям
CREATE USER restaurant_admin WITH PASSWORD 'adminnn';
GRANT SELECT, INSERT, UPDATE, DELETE ON restaurant_staff TO restaurant_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON restaurant_special_offers TO restaurant_admin;

-- Менеджер ресторана, имеет привилегии на чтение и обновление данных о ресторане его деталях и времени работы
CREATE USER restaurant_manager WITH PASSWORD 'managerrr';
GRANT SELECT, UPDATE ON restaurant TO restaurant_manager;
GRANT SELECT, UPDATE ON restaurant_details TO restaurant_manager;
GRANT SELECT, UPDATE ON working_hours TO restaurant_manager;

-- Клиент ресторана имеет доступ к CRUD к бронированию, чтение полной информации о ресторане, и CR к отзывам:
CREATE USER restaurant_client WITH PASSWORD 'clienttt';
GRANT SELECT ON restaurant TO restaurant_client;
GRANT SELECT ON restaurant_address TO restaurant_client;
GRANT SELECT ON restaurant_special_offers TO restaurant_client;
GRANT SELECT ON seating TO restaurant_client;
GRANT SELECT, INSERT, UPDATE, DELETE ON reservations TO restaurant_client;
GRANT SELECT, INSERT ON customer_reviews TO restaurant_client;