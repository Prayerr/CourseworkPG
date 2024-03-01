CREATE DATABASE courseWork;

\encoding UTF8 -- Кодировка

-- CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- расширение для генерации UUID (УЖЕ НЕ НУЖНО)

CREATE TABLE restaurant(
  id_restaurant VARCHAR(64) PRIMARY KEY NOT NULL,
  name VARCHAR(64) NOT NULL,
  working_hours VARCHAR(24) NOT NULL,
  restaurant_phone VARCHAR(24) NOT NULL UNIQUE
);

CREATE TABLE "table"(
  id_table VARCHAR(10) PRIMARY KEY NOT NULL,
  id_restaurant VARCHAR(64) NOT NULL,
  capacity INTEGER NOT NULL DEFAULT 1 CHECK (capacity > 0),
  is_available boolean NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES restaurant (id_restaurant),
  CONSTRAINT id_length CHECK (length(id_table::text) = 10)
);

CREATE TABLE restaurant_address(
  id_restaurant VARCHAR(64) NOT NULL,
  country varchar(128) NOT NULL,
  state varchar(128),
  city varchar(128) NOT NULL,
  street varchar(128) NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES restaurant (id_restaurant)
);

CREATE TABLE customer(
  id_customer VARCHAR(64) PRIMARY KEY NOT NULL,
  name varchar(128) NOT NULL,
  customer_phone varchar(24) NOT NULL,
  email varchar(64) UNIQUE
  CONSTRAINT valid_phone_format CHECK (customer_phone ~ '^\d{3}-\d{3}-\d{4}$' OR customer_phone ~ '^\d{3}-\d{3}-\d{2}-\d{2}$')
);

CREATE TABLE reservation(
  id_reservation VARCHAR(64) PRIMARY KEY NOT NULL,
  id_customer VARCHAR(64) NOT NULL,
  id_table VARCHAR(10) NOT NULL,
  description varchar(512),
  start_time DATE,
  end_time DATE,
  FOREIGN KEY (id_customer) REFERENCES customer (id_customer),
  FOREIGN KEY (id_table) REFERENCES "table" (id_table)
);