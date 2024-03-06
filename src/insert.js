import pool from "./pool.js";

export default async function insertRestaurant(restaurant) {
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
  } catch (e) {
    await client.query("ROLLBACK");
    throw e;
  } finally {
    client.release();
  }
}
