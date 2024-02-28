import { name_restaurant } from "./restaurant_info.js";
import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

function generateRandomPhoneNumberRestaurant() {
  let phoneNumberRestaurant = "+7";
  for (let i = 0; i <= 6; i++) {
    phoneNumberRestaurant += Math.floor(Math.random() * 10);
  }
  return phoneNumberRestaurant;
}

function generateRandomWorkingHours() {
  const startHour = faker.number.int({ min: 6, max: 10 });
  const endHour = faker.number.int({ min: 18, max: 24 });
  return `${startHour}:00 - ${endHour}:00`;
}

export function generateRestaurantData() {
  return name_restaurant.map((name) => ({
    name,
    id: uuid(),
    working_hours: generateRandomWorkingHours(),
    restaurant_phone: generateRandomPhoneNumberRestaurant(),
  }));
}
