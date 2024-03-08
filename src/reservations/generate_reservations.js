import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";
import { clarification, reservationStatus } from "./reservation_status.js";

export default class ReservationGenerator {
  constructor(idCustomer, idSeating) {
    this.idReservation = uuid();
    this.idCustomer = idCustomer;
    this.idSeating = idSeating;
    this.reservationStatus = this.generateRandomReservationStatus();
    this.clarification = this.generateRandomClarification();
    this.reservationDate = this.generateRandomReservationDate();
    this.startTime = this.generateRandomStartTimeReservation();
    this.endTime = this.generateRandomEndTimeReservation(this.startTime);
  }

  generateRandomClarification() {
    return faker.helpers.arrayElement(clarification);
  }

  generateRandomReservationStatus() {
    return faker.helpers.arrayElement(reservationStatus);
  }

  generateRandomReservationDate() {
    const currentDate = new Date();
    const randomDays = faker.number.int({ min: -7, max: 7 });
    const reservationDate = new Date(currentDate);

    reservationDate.setDate(currentDate.getDate() + randomDays);

    return reservationDate;
  }

  generateRandomStartTimeReservation() {
    const hours = faker.number.int({ min: 10, max: 17 });
    const minutes = faker.number.int({ min: 0, max: 59 });
    return `${hours.toString().padStart(2, "0")}:${minutes
      .toString()
      .padStart(2, "0")}`;
  }

  generateRandomEndTimeReservation(startTime) {
    const [startHours, startMinutes] = startTime.split(":").map(Number);
    const durationHours = faker.number.int({ min: 1, max: 2 });
    let endHours = startHours + durationHours;
    if (endHours >= 18) endHours = 18;
    const minutes = startMinutes;
    return `${endHours.toString().padStart(2, "0")}:${minutes
      .toString()
      .padStart(2, "0")}`;
  }
}
