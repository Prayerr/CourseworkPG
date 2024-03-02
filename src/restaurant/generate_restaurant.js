import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";
import ReservationGenerator from "../reservations/generate_reservations.js";
import TableGenerator from "./generate_tables.js";
import AddressGenerator from "./generate_address.js";

export default class Restaurant {
  constructor(name) {
    this.id = uuid();
    this.name = name;
    this.workingHours = this.generateRandomWorkingHours();
    this.restaurantPhone = this.generateRandomPhoneNumber();
    this.tables = [];
    this.address = {};
    this.reservations = [];
  }

  generateRandomPhoneNumber() {
    let phoneNumber = "+7";
    for (let i = 0; i <= 6; i++) {
      phoneNumber += Math.floor(Math.random() * 10);
    }
    return phoneNumber;
  }

  generateRandomWorkingHours() {
    const openingTime = faker.number.int({ min: 6, max: 10 });
    const closingTime = faker.number.int({ min: 18, max: 24 });
    return `${openingTime}:00 - ${closingTime}:00`;
  }

  generateData() {
    this.generateTables();
    this.generateAddress();
  }

  generateTables() {
    for (let i = 0; i < 10; i++) {
      const table = new TableGenerator();
      this.tables.push(table);
    }
  }

  generateAddress() {
    const addressGenerator = new AddressGenerator();
    this.address = addressGenerator.generateAddressData();
  }

  generateReservationData() {
    const openingTime = parseInt(this.workingHours.split(":")[0]);
    const reservationGenerator = new ReservationGenerator(openingTime);
    this.reservations = reservationGenerator.generateReservations();
    return this.reservations;
  }
}
