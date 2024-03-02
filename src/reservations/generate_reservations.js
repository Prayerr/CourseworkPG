import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

export default class ReservationGenerator {
  constructor(openingTime) {
    this.openingTime = openingTime;
  }

  generateReservations() {
    const reservations = [];
    let currentTime = this.openingTime;
    const closingTime = currentTime + 12;

    while (currentTime < closingTime && reservations.length < 3) {
      const reservationTime = faker.number.float({
        min: currentTime,
        max: closingTime,
        precision: 0.5,
      });
      const lastReservationTime =
        reservations.length > 0 ? reservations[reservations.length - 1] : 0;
      const timeDifference = reservationTime - lastReservationTime;

      if (timeDifference >= 0.5) {
        reservations.push(reservationTime);
        currentTime = reservationTime + 0.5;
      }
    }

    return reservations.map((time) => ({
      id: uuid(),
      time,
      duration: faker.number.float({ min: 1, max: 3, precision: 0.5 }),
    }));
  }
}
