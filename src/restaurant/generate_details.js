import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";

export default class RestaurantDetailsGenerator {
  constructor(cuisineId) {
    this.idDetails = uuid();
    this.idCuisine = cuisineId;
    this.links = this.generateSocialMediaLinks();
    this.linksJSON = JSON.stringify(this.links);
    this.info = this.generateInfoRestaurantDetails();
  }

  generateInfoRestaurantDetails() {
    return faker.lorem.lines({ min: 1, max: 2 });
  }

  generateSocialMediaLinks() {
    const socialMediaLinks = {};
    const links = faker.number.int({ min: 1, max: 3 });

    for (let i = 0; i < links; i++) {
      socialMediaLinks[`media${i + 1}`] = faker.internet.url();
    }

    return socialMediaLinks;
  }
}
