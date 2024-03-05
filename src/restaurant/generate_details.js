import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";

export default class RestaurantDetailsGenerator {
  constructor(cuisineId) {
    this.idDetails = uuid();
    this.idCuisine = cuisineId;
    this.links = this.generateSocialMediaLinks();
    this.info = faker.lorem.lines({ min: 0, max: 3 });
  }

  generateSocialMediaLinks() {
    const socialMediaLinks = {};
    const links = faker.number.int({ min: 0, max: 2 });

    for (let i = 0; i < links; i++) {
      socialMediaLinks[
        faker.helpers.arrayElement(["media1", "media2", "media3"])
      ] = faker.internet.url();
    }

    return socialMediaLinks;
  }
}
