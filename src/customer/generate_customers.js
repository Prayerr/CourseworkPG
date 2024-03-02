import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";
import fs from "fs";

function generateRandomPhoneNumber() {
  let customer_phone = "+7";
  for (let i = 0; i <= 9; i++) {
    customer_phone += Math.floor(Math.random() * 10);
  }
  return customer_phone;
}

function generateRandomName() {
  return faker.person.fullName();
}

const rows = [];

for (let i = 0; i <= 30; i++) {
  const customer_phone = generateRandomPhoneNumber();
  const idFemale = uuid();
  const idMale = uuid();
  const maleName = generateRandomName({ sex: "male" });
  const femaleName = generateRandomName({ sex: "female" });

  const maleEmail = faker.internet.email({ firstName: maleName });
  const femaleEmail = faker.internet.email({ firstName: femaleName });

  rows.push(`${idMale},${maleName},${maleEmail},${customer_phone}`);
  rows.push(`${idFemale},${femaleName},${femaleEmail},${customer_phone}`);
}

const csvContent = "id_customer,name,email,customer_phone\n" + rows.join("\n");

fs.writeFileSync("customers.csv", csvContent, "utf8");
