import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";
import specialOffersName from "./special_offers.js";

export default class RestaurantSpecialOffers {
  constructor(idRestaurant) {
    this.idOffer = uuid();
    this.idRestaurant = idRestaurant;
    this.offerName = generateRandomOffer();
    this.description = faker.lorem.lines({ min: 1, max: 2 });
    this.startOffer = generateRandomStartOffer();
    this.endOffer = generateRandomEndOffer();
  }
  generateRandomOffer() {
    return faker.helpers.arrayElement(specialOffersName);
  }

  generateRandomStartOffer() {
    const startOffer = new Date();
    const randomOffset = faker.number.int({ min: 1, max: 7 });
    startOffer.setDate(startOffer.getDate() - randomOffset);
    return startOffer.toISOString().split("T")[0];
  }

  generateRandomEndOffer() {
    const endOffer = new Date();
    const randomOffset = faker.number.int({ min: 2, max: 30 });
    endOffer.setDate(endOffer.getDate() + randomOffset);
    return endOffer.toISOString().split("T")[0];
  }
}
