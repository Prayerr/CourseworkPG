import { v4 as uuid } from "uuid";
import { faker, th } from "@faker-js/faker";
import generateRandomAddress from "./generate_address.js";
import generateRandomWorkingHours from "./generate_working_hours.js";
import nameRestaurant from "./restaurant_names.js";
import SeatingGenerator from "./generate_seatings.js";
import RestaurantDetailsGenerator from "./generate_details.js";

export default class Restaurant {
  constructor() {
    const idWorkingHours = generateRandomWorkingHours().idWorkingHours;
    const idDetails = new RestaurantDetailsGenerator().idDetails;
    const idAddress = generateRandomAddress().idAddress;

    this.idRestaurant = uuid();
    this.idWorkingHours = idWorkingHours;
    this.idDetails = idDetails;
    this.idAddress = idAddress;
    this.name = this.generateRandomRestaurantName();
    this.restaurantPhone = this.generateRandomPhoneNumber();
    this.seating = SeatingGenerator.generateSeatingsForRestaurant(
      this.idRestaurant
    );
    this.address = generateRandomAddress();
  }

  generateRandomRestaurantName() {
    return faker.helpers.arrayElement(nameRestaurant);
  }

  generateRandomPhoneNumber() {
    let phoneNumber = "+7";
    for (let i = 0; i <= 6; i++) {
      phoneNumber += Math.floor(Math.random() * 10);
    }
    return phoneNumber;
  }
}

const restaurant = new Restaurant();

console.log(restaurant);
