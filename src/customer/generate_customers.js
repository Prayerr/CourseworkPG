import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";
import fs from "fs";

class CustomerGenerator {
  static paymentType = ["credit_card", "paypal", "cash"];

  static generateRandomPhoneNumber() {
    let customerPhone = "+7";
    for (let i = 0; i < 10; i++) {
      customerPhone += Math.floor(Math.random() * 10);
    }
    return customerPhone;
  }

  static generateRandomCustomer() {
    const idCustomer = uuid();
    const customerPhone = this.generateRandomPhoneNumber();
    const paymentType = faker.helpers.arrayElement(this.paymentType);

    const firstNameCustomer = faker.person.firstName();
    const lastNameCustomer = faker.person.lastName();
    const fullNameCustomer = `${firstNameCustomer} ${lastNameCustomer}`;

    const customerEmail = faker.internet.email({
      firstName: firstNameCustomer,
      lastName: lastNameCustomer,
    });

    return {
      idCustomer,
      fullNameCustomer,
      customerEmail,
      customerPhone,
      paymentType,
    };
  }
}

const rows = [];

for (let i = 0; i < 40; i++) {
  const customer = CustomerGenerator.generateRandomCustomer();
  rows.push(
    `${customer.idCustomer},${customer.fullNameCustomer},${customer.customerEmail},${customer.customerPhone},${customer.paymentType}`
  );
}

const csvContent =
  "id_customer,name_customer,email,customer_phone,payment_type\n" +
  rows.join("\n");

fs.writeFileSync("customers.csv", csvContent, "utf8");
