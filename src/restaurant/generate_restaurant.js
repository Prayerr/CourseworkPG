import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";
import generateRandomAddress from "./generate_address.js";
import generateRandomPhoneNumber from "./generate_number_restaurant.js";
import generateRandomWorkingHours from "./generate_working_hours.js";
import nameRestaurant from "./restaurant_names.js";
import SeatingGenerator from "./generate_seatings.js";
import RestaurantDetailsGenerator from "./generate_details.js";
import StaffGenerator from "../staff/generate_staff.js";
import CuisineGenerator from "./generate_cuisine.js";
import RestaurantSpecialOffersGenerator from "../special_offers/generate_special_offers.js";

export default class Restaurant {
  constructor(
    id,
    name,
    phone,
    address,
    workingHours,
    seating,
    details,
    cuisine,
    specialOffers,
    staff
  ) {
    this.id = id;
    this.name = name;
    this.phone = phone;
    this.address = address;
    this.workingHours = workingHours;
    this.seating = seating;
    this.details = details;
    this.cuisine = cuisine;
    this.specialOffers = specialOffers;
    this.staff = staff;
  }

  static generateRandomRestaurant() {
    const id = uuid();
    const name = faker.helpers.arrayElement(nameRestaurant);
    const phone = generateRandomPhoneNumber();
    const address = generateRandomAddress();
    const workingHours = generateRandomWorkingHours();
    const seating = SeatingGenerator.generateSeatingsForRestaurant(id);
    const cuisineGenerator = new CuisineGenerator();
    const cuisine = cuisineGenerator.generateRandomCuisine();
    const details = new RestaurantDetailsGenerator(cuisine.idCuisine);
    const specialOffers = new RestaurantSpecialOffersGenerator(id);
    const staff = StaffGenerator.generateRandomStaff(id);

    return new Restaurant(
      id,
      name,
      phone,
      address,
      workingHours,
      seating,
      details,
      cuisine,
      specialOffers,
      staff
    );
  }
}
