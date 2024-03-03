CREATE ROLE admin WITH SUPERUSER LOGIN PASSWORD 'root';

CREATE ROLE manager WITH LOGIN PASSWORD 'qwerty';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO manager;

CREATE ROLE client WITH LOGIN PASSWORD '03032024';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO client;
