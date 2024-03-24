-- Админ ресторана, имеет полный доступ CRUD к таблице с сотрудниками ресторана и спец. предложениям
CREATE ROLE restaurant_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON restaurant_staff TO restaurant_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON restaurant_special_offers TO restaurant_admin;

-- Менеджер ресторана, имеет привилегии на чтение и обновление данных о ресторане его деталях и времени работы
CREATE ROLE restaurant_manager;
GRANT SELECT, UPDATE ON restaurant TO restaurant_manager;
GRANT SELECT, UPDATE ON restaurant_details TO restaurant_manager;
GRANT SELECT, UPDATE ON working_hours TO restaurant_manager;

-- Клиент ресторана имеет доступ к CRUD к бронированию, чтение полной информации о ресторане, и CR к отзывам:
CREATE ROLE restaurant_client;
GRANT SELECT ON restaurant TO restaurant_client;
GRANT SELECT ON restaurant_address TO restaurant_client;
GRANT SELECT ON restaurant_special_offers TO restaurant_client;
GRANT SELECT ON seating TO restaurant_client;
GRANT SELECT ON working_hours TO restaurant_client;
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO restaurant_client;
GRANT SELECT, INSERT, UPDATE, DELETE ON customer_reviews TO restaurant_client;
GRANT SELECT, INSERT, UPDATE, DELETE ON reservations TO restaurant_client;

-- Создание юзеров 
CREATE USER admin1 WITH PASSWORD 'admin';
GRANT restaurant_admin TO admin1;

CREATE USER manager1 WITH PASSWORD 'manager';
GRANT restaurant_manager TO manager1;

CREATE USER client1 WITH PASSWORD 'client';
GRANT restaurant_client TO client1;