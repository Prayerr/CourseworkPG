import { faker } from "@faker-js/faker";

export default class AddressGenerator {
  generateRandomAddress() {
    const street = faker.location.street();
    const city = faker.location.city();
    const country = faker.location.country();
    let state = "";

    if (Math.random() < 0.5) {
      state = faker.location.state();
    }

    return { street, city, country, state };
  }

  generateAddressData() {
    const address = this.generateRandomAddress();
    return {
      state: address.state,
      city: address.city,
      street: address.street,
      country: address.country,
    };
  }
}
