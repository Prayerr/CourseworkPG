import Restaurant from "./src/restaurant/generate_restaurant.js";
import insertRestaurant from "./src/insert.js";

async function generateAndInsertRestaurants() {
  const maxRestaurants = 3;

  try {
    for (let i = 0; i < maxRestaurants; i++) {
      const restaurant = Restaurant.generateRandomRestaurant();
      await insertRestaurant(restaurant);
      console.log(`Ресторан ${restaurant.name} занесен в базу данных.`);
    }
  } catch (error) {
    console.error("Возникла ошибка", error);
  }
}

generateAndInsertRestaurants();
