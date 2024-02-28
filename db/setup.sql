CREATE DATABASE courseWork;

\encoding UTF8 -- Кодировка

-- CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- расширение для генерации UUID (УЖЕ НЕ НУЖНО)

CREATE TABLE restaurant_info(
  id_restaurant UUID NOT NULL,
  name VARCHAR(64) NOT NULL,
  opening_hours VARCHAR(24) NOT NULL,
  restaurant_phone VARCHAR(24) NOT NULL UNIQUE
);

CREATE TABLE "table"(
  id_table UUID NOT NULL,
  id_restaurant UUID NOT NULL,
  capacity INTEGER NOT NULL DEFAULT 1 CHECK (capacity > 0),
  is_available boolean NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES restaurant_info (id_restaurant),
  CONSTRAINT id_length CHECK (length(id_table::text) = 6)
);

CREATE TABLE restaurant_address(
  id_restaurant UUID NOT NULL,
  country varchar(64) NOT NULL,
  state varchar(64),
  city varchar(64) NOT NULL,
  street varchar(128) NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES restaurant_info (id_restaurant)
);

CREATE TABLE customer(
  id_customer UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name varchar(128) NOT NULL,
  customer_phone varchar(24) NOT NULL,
  email varchar(64) UNIQUE
  CONSTRAINT valid_phone_format CHECK (customer_phone ~ '^\d{3}-\d{3}-\d{4}$' OR customer_phone ~ '^\d{3}-\d{3}-\d{2}-\d{2}$')
);

CREATE TABLE reservation(
  id_reservation UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  id_customer UUID NOT NULL,
  id_table UUID NOT NULL,
  description varchar(512),
  start_time TIME,
  end_time TIME,
  FOREIGN KEY (id_customer) REFERENCES customer (id_customer),
  FOREIGN KEY (id_table) REFERENCES "table" (id_table)
);