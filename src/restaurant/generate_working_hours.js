import { v4 as uuid } from "uuid";
import { faker } from "@faker-js/faker";

export default function generateRandomWorkingHours() {
  const idWorkingHours = uuid();
  const openingHour = faker.number.int({ min: 8, max: 9 });
  const closingHour = faker.number.int({ min: 21, max: 23 });

  const openingMinutes = Math.floor(Math.random() * 12) * 5;
  const closingMinutes = Math.floor(Math.random() * 12) * 5;

  const openingTime = `${openingHour}:${openingMinutes}`;
  const closingTime = `${closingHour}:${closingMinutes}`;

  return { idWorkingHours, openingTime, closingTime };
}
