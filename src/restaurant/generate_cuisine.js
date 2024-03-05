import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";

export default class CuisineGenerator {
  generateRandomCuisine() {
    const cuisineData = [
      "Italian",
      "French",
      "Japanese",
      "Russian",
      "American",
      "Derivative",
    ];

    const idCuisine = uuid();
    const cuisine = faker.helpers.arrayElement(cuisineData);

    return { idCuisine, cuisine };
  }
}
