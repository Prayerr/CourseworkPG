CREATE DATABASE courseWorkPG;

-- Сброс
TRUNCATE restaurant, restaurant_address, customer, customer_reviews, restaurant_details CASCADE;

CREATE TABLE restaurant(
  id_restaurant UUID PRIMARY KEY NOT NULL,
  id_working_hours UUID NOT NULL,
  id_detail UUID NOT NULL,
  id_address UUID NOT NULL,
  name VARCHAR(64) NOT NULL,
  restaurant_phone VARCHAR(24) NOT NULL UNIQUE,
  FOREIGN KEY (id_working_hours) REFERENCES working_hours (id_working_hours),
  FOREIGN KEY (id_details) REFERENCES restaurant_details (id_details),
  FOREIGN KEY (id_address) REFERENCES restaurant_address (id_address)
);

CREATE TABLE restaurant_address(
  id_address UUID PRIMARY KEY NOT NULL,
  country varchar(128) NOT NULL,
  state varchar(128),
  city varchar(128) NOT NULL,
  street varchar(128) NOT NULL
);

CREATE TABLE working_hours(
  id_working_hours UUID PRIMARY KEY NOT NULL,
  opening_time TIME NOT NULL,
  closing_time TIME NOT NULL
);

CREATE TABLE cuisine (  
  id_cuisine UUID PRIMARY KEY NOT NULL,
  cuisine_type cuisine_type NOT NULL
);

CREATE TABLE restaurant_details (
  id_details UUID PRIMARY KEY NOT NULL,
  id_cuisine UUID NOT NULL,
  social_media_links JSONB,
  additional_info VARCHAR(512),
  FOREIGN KEY (id_cuisine) REFERENCES cuisine (id_cuisine)
);

CREATE TABLE restaurant_staff (
  id_staff UUID PRIMARY KEY NOT NULL,
  id_restaurant UUID NOT NULL,
  name_staff VARCHAR(128) NOT NULL,
  position VARCHAR(64),
  contact_number VARCHAR(24),
  FOREIGN KEY (id_restaurant) REFERENCES restaurant (id_restaurant)
);

CREATE TABLE restaurant_special_offers (
  id_offer UUID PRIMARY KEY NOT NULL,
  id_restaurant UUID NOT NULL,
  offer_name VARCHAR(64) NOT NULL,
  description VARCHAR(256),
  start_offer DATE NOT NULL,
  end_offer DATE NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES restaurant (id_restaurant)
);

CREATE TABLE seating(
  id_seating UUID PRIMARY KEY NOT NULL,
  id_restaurant UUID NOT NULL,
  seating_status seating_status NOT NULL,
  capacity INTEGER NOT NULL DEFAULT 1 CHECK (capacity > 0),
  FOREIGN KEY (id_restaurant) REFERENCES restaurant (id_restaurant)
);

CREATE TABLE customer(
  id_customer UUID PRIMARY KEY NOT NULL,
  name_customer varchar(128) NOT NULL,
  payment_type payment_type NOT NULL,
  customer_phone varchar(24) NOT NULL CHECK (LENGTH(customer_phone) <= 12),
  email varchar(64) UNIQUE
);

CREATE TABLE customer_reviews(
  id_review UUID PRIMARY KEY NOT NULL,
  id_customer UUID NOT NULL,
  id_restaurant UUID NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (id_customer) REFERENCES customer (id_customer),
  FOREIGN KEY (id_restaurant) REFERENCES restaurant (id_restaurant)
);

CREATE TABLE reservations(
  id_reservation UUID PRIMARY KEY NOT NULL,
  id_customer UUID NOT NULL,
  id_seating UUID NOT NULL,
  reservation_status reservation_status NOT NULL,
  clarification varchar(256),
  reservation_date DATE,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  FOREIGN KEY (id_customer) REFERENCES customer (id_customer),
  FOREIGN KEY (id_seating) REFERENCES seating (id_seating)
);