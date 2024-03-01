import { faker } from "@faker-js/faker";

function generateRandomOrderTime(workingHours) {
  const { openingTime, closingTime } = workingHours;
  const startTimeOrder = faker.number.int({
    min: openingTime,
    max: closingTime,
  });
  const endTimeOrder = faker.number.int({ min: openingTime, max: closingTime });
  return orderTime;
}
