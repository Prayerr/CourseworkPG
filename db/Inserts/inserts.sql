INSERT INTO restaurant (id_restaurant, id_working_hours, id_detail, id_address, name, restaurant_phone) VALUES ($1, $2, $3, $4, $5, $6);

INSERT INTO restaurant_address (id_address, country, state, city, street) VALUES ($1, $2, $3, $4, $5);

INSERT INTO working_hours (id_working_hours, opening_time, closing_time) VALUES ($1, $2, $3);

INSERT INTO cuisine (id_cuisine, cuisine_type) VALUES ($1, $2);

INSERT INTO restaurant_details (id_details, id_cuisine, social_media_links, additional_info) VALUES ($1, $2, $3, $4);

INSERT INTO seating (id_seating, id_restaurant, seating_status, capacity) VALUES ($1, $2, $3, $4);



