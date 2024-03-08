import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

export default class ReviewGenerator {
  constructor(id, idCustomer) {
    this.idReview = uuid();
    this.idCustomer = idCustomer;
    this.id = id;
    this.rating = this.generateRandomRating();
    this.reviewText = this.generateRandomReviewText();
  }

  generateRandomRating() {
    return faker.number.int({ min: 1, max: 5 });
  }

  generateRandomReviewText() {
    return faker.lorem.lines({ min: 1, max: 4 });
  }
}
