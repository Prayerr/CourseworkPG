import { generateRestaurantData } from "./src/restaurant/generate_restaurant.js";
import { insertData } from "./src/insert.js";

const restaurantData = generateRestaurantData();

insertData(restaurantData);
