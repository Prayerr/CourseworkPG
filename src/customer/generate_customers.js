import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";
import fs from "fs";

let customerPhone = "+7";

const paymentType = ["credit_card", "paypal", "cash"];

function generateRandomPhoneNumber() {
  for (let i = 0; i <= 9; i++) {
    customerPhone += Math.floor(Math.random() * 10);
  }
  return customerPhone;
}

function generateRandomName() {
  return faker.person.fullName();
}

const rows = [];

for (let i = 0; i < 16; i++) {
  const customerPhone = generateRandomPhoneNumber();
  const idFemale = uuid();
  const idMale = uuid();
  const maleName = generateRandomName({ sex: "male" });
  const femaleName = generateRandomName({ sex: "female" });

  const maleEmail = faker.internet.email({ firstName: maleName });
  const femaleEmail = faker.internet.email({ firstName: femaleName });

  rows.push(`${idMale},${maleName},${maleEmail},${customerPhone}`);
  rows.push(`${idFemale},${femaleName},${femaleEmail},${customerPhone}`);
}

const csvContent = "id_customer,name,email,customer_phone\n" + rows.join("\n");

fs.writeFileSync("customers.csv", csvContent, "utf8");
