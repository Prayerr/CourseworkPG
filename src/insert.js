import pool from "./pool.js";
import ReviewGenerator from "./customer/generate_reviews.js";
import ReservationGenerator from "./reservations/generate_reservations.js";
import { faker } from "@faker-js/faker";

export async function insertRestaurant(restaurant) {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    await client.query(
      "INSERT INTO working_hours (id_working_hours, opening_time, closing_time) VALUES ($1, $2, $3)",
      [
        restaurant.workingHours.idWorkingHours,
        restaurant.workingHours.openingTime,
        restaurant.workingHours.closingTime,
      ]
    );

    await client.query(
      "INSERT INTO cuisine (id_cuisine, cuisine_type) VALUES ($1, $2)",
      [restaurant.cuisine.idCuisine, restaurant.cuisine.cuisine]
    );

    await client.query(
      "INSERT INTO restaurant_address (id_address, country, state, city, street) VALUES ($1, $2, $3, $4, $5)",
      [
        restaurant.address.idAddress,
        restaurant.address.country,
        restaurant.address.state,
        restaurant.address.city,
        restaurant.address.street,
      ]
    );

    await client.query(
      "INSERT INTO restaurant_details (id_details, id_cuisine, social_media_links, additional_info) VALUES ($1, $2, $3, $4)",
      [
        restaurant.details.idDetails,
        restaurant.cuisine.idCuisine,
        restaurant.details.linksJSON,
        restaurant.details.info,
      ]
    );

    await client.query(
      "INSERT INTO restaurant (id_restaurant, id_working_hours, id_details, id_address, name, restaurant_phone) VALUES ($1, $2, $3, $4, $5, $6)",
      [
        restaurant.id,
        restaurant.workingHours.idWorkingHours,
        restaurant.details.idDetails,
        restaurant.address.idAddress,
        restaurant.name,
        restaurant.phone,
      ]
    );

    await client.query(
      "INSERT INTO restaurant_special_offers (id_offer, id_restaurant, offer_name, description, start_offer, end_offer) VALUES ($1, $2, $3, $4, $5, $6)",
      [
        restaurant.specialOffers.idOffer,
        restaurant.id,
        restaurant.specialOffers.offerName,
        restaurant.specialOffers.description,
        restaurant.specialOffers.startOffer,
        restaurant.specialOffers.endOffer,
      ]
    );

    await Promise.all(
      restaurant.staff.map(async (staffMember) => {
        await client.query(
          "INSERT INTO restaurant_staff (id_staff, id_restaurant, name_staff, position, contact_number) VALUES ($1, $2, $3, $4, $5)",
          [
            staffMember.staffId,
            restaurant.id,
            staffMember.staffName,
            staffMember.staffPosition,
            staffMember.contactNumber,
          ]
        );
      })
    );

    await Promise.all(
      restaurant.seating.map((seat) => {
        return client.query(
          "INSERT INTO seating (id_seating, id_restaurant, seating_status, capacity) VALUES ($1, $2, $3, $4)",
          [seat.idSeating, restaurant.id, seat.status, seat.capacity]
        );
      })
    );

    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}

export async function insertCustomers() {
  const client = await pool.connect();

  try {
    client.query("BEGIN");

    const path = "E:/Projects/coursework/customers.csv";
    const customerCopyQuery = `COPY customer(id_customer, name_customer, email, customer_phone, payment_type) FROM '${path}' DELIMITER ',' CSV HEADER`;

    await client.query(customerCopyQuery);
    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}

export async function fetchCustomerId() {
  const client = await pool.connect();

  try {
    const fetchIdCustomerQuery = "SELECT id_customer FROM customer;";
    const customers = await client.query(fetchIdCustomerQuery);

    const customerIds = customers.rows.map((row) => row.id_customer);
    return customerIds;
  } finally {
    client.release();
  }
}

export async function insertReviews(restaurant, customerIds) {
  const client = await pool.connect();
  const numberReviews = faker.number.int({ min: 3, max: 10 });
  try {
    client.query("BEGIN");
    for (let i = 0; i < numberReviews; i += 1) {
      const randomCustomerId =
        customerIds[Math.floor(Math.random() * customerIds.length)];

      const review = new ReviewGenerator(restaurant.id, randomCustomerId);
      await client.query(
        "INSERT INTO customer_reviews (id_review, id_customer, id_restaurant, rating, review_text) VALUES ($1, $2, $3, $4, $5);",
        [
          review.idReview,
          review.idCustomer,
          review.id,
          review.rating,
          review.reviewText,
        ]
      );
    }
    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}

export async function fetchSeatingsId() {
  const client = await pool.connect();
  try {
    const fetchSeatingsIdQuery = "SELECT id_seating FROM seating;";
    const seatings = await client.query(fetchSeatingsIdQuery);

    const seatingsIds = seatings.rows.map((row) => row.id_seating);
    return seatingsIds;
  } finally {
    client.release();
  }
}

export async function insertReservation(seatingsIds, customerIds) {
  const client = await pool.connect();
  try {
    client.query("BEGIN");

    const randomCustomerId =
      customerIds[Math.floor(Math.random() * customerIds.length)];

    const randomSeatingsIds =
      seatingsIds[Math.floor(Math.random() * seatingsIds.length)];

    const reservation = new ReservationGenerator(
      randomCustomerId,
      randomSeatingsIds
    );

    await client.query(
      "INSERT INTO reservations (id_reservation, id_customer, id_seating, reservation_status, clarification, reservation_date, start_time, end_time) VALUES ($1, $2, $3, $4, $5, $6, $7, $8);",
      [
        reservation.idReservation,
        reservation.idCustomer,
        reservation.idSeating,
        reservation.reservationStatus,
        reservation.clarification,
        reservation.reservationDate,
        reservation.startTime,
        reservation.endTime,
      ]
    );

    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}
