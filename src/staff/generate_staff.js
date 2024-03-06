import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

export default class StaffGenerator {
  static generateRandomStaff(id) {
    const staff = [];
    const staffCapacity = faker.number.int({ min: 30, max: 50 });

    for (let i = 0; i < staffCapacity; i += 1) {
      const staffId = uuid();
      const staffName = faker.person.fullName();
      const staffPosition = faker.person.jobType();
      const contactNumber = faker.phone.number();

      staff.push({
        staffId,
        id,
        staffPosition,
        staffName,
        contactNumber,
      });
    }
    return staff;
  }
}
