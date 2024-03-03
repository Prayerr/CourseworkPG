import { faker } from "@faker-js/faker";

const reservationDate = faker.date
  .between({
    from: "2024-03-03",
    to: "2024-10-10",
  })
  .toLocaleDateString();

console.log(reservationDate);
