import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";

export default class CuisineGenerator {
  static cuisineData = [
    "Italian",
    "French",
    "Japanese",
    "Russian",
    "American",
    "Derivative",
  ];

  constructor() {
    this.idCuisine = uuid();
  }

  generateRandomCuisine() {
    const cuisine = faker.helpers.arrayElement(CuisineGenerator.cuisineData);

    return { idCuisine: this.idCuisine, cuisine };
  }
}
