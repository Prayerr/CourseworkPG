import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

class TableGenerator {
  constructor() {
    this.id_table = this.generateTableUUID();
    this.capacity = this.generateCapacity();
    this.isAvailable = this.generateIsAvailable();
  }

  generateTableUUID() {
    return uuid().slice(0, 10);
  }

  generateCapacity() {
    return faker.number.int({ min: 1, max: 12 });
  }

  generateIsAvailable() {
    return faker.datatype.boolean();
  }
}

export default TableGenerator;
