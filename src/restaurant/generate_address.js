import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";

export default function generateRandomAddress() {
  const idAddress = uuid();
  const street = faker.location.street();
  const city = faker.location.city();
  const country = faker.location.country();
  const state =
    faker.number.int({ min: 0, max: 1 }) < 0.5 ? faker.location.state() : "";

  return { idAddress, street, city, country, state };
}
