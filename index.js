import Restaurant from "./src/restaurant/generate_restaurant.js";
import {
  insertRestaurant,
  insertCustomers,
  fetchCustomerId,
  fetchSeatingsId,
  insertReviews,
  insertReservation,
} from "./src/insert.js";

async function insertData() {
  const maxRestaurants = 3;
  const reservationsPerRestaurant = 5;

  try {
    await insertCustomers();
    const customers = await fetchCustomerId();

    const restaurants = Array.from({ length: maxRestaurants }, () =>
      Restaurant.generateRandomRestaurant()
    );

    await Promise.all(
      restaurants.map(async (restaurant) => {
        await insertRestaurant(restaurant);
        console.log(`Ресторан ${restaurant.name} занесен в базу данных.`);

        const seatings = await fetchSeatingsId();

        await Promise.all(
          Array.from({ length: reservationsPerRestaurant }, async () => {
            await insertReservation(seatings, customers);
            console.log(
              `Добавлено бронирование для ресторана ${restaurant.name}.`
            );
          })
        );

        await insertReviews(restaurant, customers);
        console.log(`Добавлены отзывы для ресторана ${restaurant.name}.`);
      })
    );
  } catch (error) {
    console.error("Возникла ошибка", error);
  }
}

insertData();
