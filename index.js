import nameRestaurant from "./src/restaurant/restaurant_names.js";
import Restaurant from "./src/restaurant/generate_restaurant.js";
import ReservationGenerator from "./src/reservations/generate_reservations.js";
import DataInserter from "./src/insert.js";

const dataInserter = new DataInserter();
const { tableId, customerId } = await dataInserter.fetchId();

const restaurantData = nameRestaurant.map((nameRestaurant) => {
  const restaurant = new Restaurant(nameRestaurant);
  restaurant.generateData();

  const reservationGenerator = new ReservationGenerator(
    tableId[Math.floor(Math.random() * tableId.length)],
    customerId[Math.floor(Math.random() * customerId.length)]
  );

  for (let i = 0; i < 20; i++) {
    restaurant.reservations.push(
      ...reservationGenerator.generateReservations()
    );
  }
  return restaurant;
});

dataInserter.insertData(restaurantData);
