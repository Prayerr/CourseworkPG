import { faker } from "@faker-js/faker";
import fs from "fs";

function generateRandomPhoneNumber() {
  let phoneNumber = "+7";
  for (let i = 0; i <= 9; i++) {
    phoneNumber += Math.floor(Math.random() * 10);
  }
  return phoneNumber;
}

function generateRandomName() {
  return faker.person.fullName();
}

function generateRandomEmail() {
  return faker.internet.email();
}

const rows = [];
for (let i = 0; i <= 15; i++) {
  const email = generateRandomEmail();
  const phoneNumber = generateRandomPhoneNumber();
  const maleName = generateRandomName({ sex: "male" });
  const femaleName = generateRandomName({ sex: "female" });

  const maleEmail = `${maleName.replace(/\s+/g, ".")}@example.com`;
  const femaleEmail = `${femaleName.replace(/\s+/g, ".")}@example.com`;

  rows.push(`${maleName},${phoneNumber},${maleEmail}`);
  rows.push(`${femaleName},${phoneNumber},${femaleEmail}`);
}

const csvContent = rows.join("\n");

fs.writeFileSync("customers.csv", csvContent, "utf8");
