import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

export default class SeatingGenerator {
  static generateSeatingsForRestaurant(restaurantId) {
    const seatings = [];
    for (let i = 0; i < 15; i++) {
      const seating = new SeatingGenerator(restaurantId);
      seatings.push(seating);
    }
    return seatings;
  }

  constructor() {
    this.idSeating = this.generateSeatingUUID();
    this.capacity = this.generateCapacity();
    this.isAvailable = this.generateStatus();
  }

  generateSeatingUUID() {
    return uuid();
  }

  generateCapacity() {
    return faker.number.int({ min: 1, max: 10 });
  }

  generateStatus() {
    const statusOptions = ["reserved", "free", "not_available"];
    const status = faker.helpers.arrayElement(statusOptions);
    return status;
  }
}
