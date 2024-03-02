import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";
import descriptions from "./descriptions.js";

export default class ReservationGenerator {
  constructor(tableId, customerId) {
    this.tableId = tableId;
    this.customerId = customerId;
  }

  generateReservations(startHour, endHour) {
    const reservations = [];
    const maxReservations = 1;

    for (let i = 0; i < maxReservations; i++) {
      const description = this.generateRandomDescription();
      const startTime = this.generateRandomStartTimeReservation(
        startHour,
        endHour
      );
      const endTime = this.generateRandomEndTimeReservation(startTime);

      const reservation = {
        id_reservation: uuid(),
        id_customer: this.customerId,
        id_table: this.tableId,
        description: description,
        start_time: startTime,
        end_time: endTime,
      };

      reservations.push(reservation);
    }
    return reservations;
  }

  generateRandomStartTimeReservation() {
    const hours = faker.number.int({ min: 10, max: 18 });
    const minutes = faker.number.int({ min: 0, max: 59 });
    return `${hours.toString().padStart(2, "0")}:${minutes
      .toString()
      .padStart(2, "0")}`;
  }

  generateRandomEndTimeReservation(startTime) {
    const [hours, minutes] = startTime.split(":").map(Number);
    const durationHours = faker.number.int({ min: 1, max: 2 });
    const endHours = (hours + durationHours) % 24;
    return `${endHours.toString().padStart(2, "0")}:${minutes
      .toString()
      .padStart(2, "0")}`;
  }

  generateRandomDescription() {
    return descriptions[Math.floor(Math.random() * descriptions.length)];
  }
}
