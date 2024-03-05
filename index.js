import Restaurant from "./src/restaurant/generate_restaurant";
import nameRestaurant from "./src/restaurant/restaurant_names";

const restaurants = nameRestaurant.map((name) => {
  const idWorkingHours = generateRandomWorkingHours();
  const idDetails = generateRestaurantDetails();
  const idAddress = generateRandomAddress();
  return new Restaurant(idWorkingHours, idDetails, idAddress, name);
});

console.log(restaurants);
