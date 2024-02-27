const { name_restaurant, working_hours } = require("./restaurant_info");

function generateRandomPhoneNumberRestaurant() {
  let phoneNumberRestaurant = "+7";
  for (let i = 0; i <= 6; i++) {
    phoneNumberRestaurant += Math.floor(Math.random() * 10);
  }
  return phoneNumberRestaurant;
}

const getRandomWorkingHours = () =>
  working_hours[Math.floor(Math.random() * working_hours.length)];

const restaurant = name_restaurant.map((name) => ({
  name,
  working_hours: getRandomWorkingHours(),
  restaurant_phone: generateRandomPhoneNumberRestaurant(),
}));

restaurant.forEach((restaurant) => {
  const { name, working_hours, restaurant_phone } = restaurant;
  console.log(
    `INSERT INTO restaurant_info (name, opening_hours, restaurant_phone) VALUES ('${name}','${working_hours}','${restaurant_phone}');`
  );
});
