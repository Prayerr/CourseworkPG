import nameRestaurant from "./src/restaurant/restaurant_names.js";
import Restaurant from "./src/restaurant/generate_restaurant.js";
import DataInserter from "./src/insert.js";

const restaurantData = nameRestaurant.map((nameRestaurant) => {
  const restaurant = new Restaurant(nameRestaurant);
  restaurant.generateData();
  return restaurant;
});

const dataInserter = new DataInserter();
dataInserter.insertData(restaurantData);
