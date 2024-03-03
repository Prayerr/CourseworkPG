import pool from "./pool.js";

class DataInserter {
  async fetchId() {
    const client = await pool.connect();
    try {
      const result = await client.query(`
            SELECT id_table FROM "table";
            SELECT id_customer FROM customer;
        `);

      const tableId = result[0].rows.map((row) => row.id_table);
      const customerId = result[1].rows.map((row) => row.id_customer);

      return { tableId, customerId };
    } finally {
      client.release();
    }
  }

  async insertData(restaurantData) {
    const client = await pool.connect();

    const customerCsvPath = "E:/Projects/coursework/customers.csv";
    const customerCopyQuery = `COPY customer(id_customer, name, email, customer_phone) FROM '${customerCsvPath}' DELIMITER ',' CSV HEADER`;

    await client.query(customerCopyQuery);

    try {
      await client.query("BEGIN");

      for (const restaurant of restaurantData) {
        await this.insertRestaurant(client, restaurant);
        await this.insertTables(client, restaurant);
        await this.insertAddress(client, restaurant);
      }

      await client.query("COMMIT");
      console.log("Данные о ресторанах вставлены в базу данных");

      const { tableId, customerId } = await this.fetchId();

      for (const restaurant of restaurantData) {
        await this.insertReservations(client, restaurant, {
          tableId,
          customerId,
        });
      }

      await client.query("COMMIT");
      console.log("Данные о бронированиях вставлены в базу данных");
    } catch (error) {
      await client.query("ROLLBACK");
      console.error("Возникли ошибки с базой данных", error);
    } finally {
      client.release();
      console.log("Соединение с базой данных закрыто");
    }
  }

  async insertRestaurant(client, restaurant) {
    const { id, name, workingHours, restaurantPhone } = restaurant;
    await client.query(
      "INSERT INTO restaurant (id_restaurant, name, working_hours, restaurant_phone) VALUES ($1::UUID, $2, $3, $4)",
      [id, name, workingHours, restaurantPhone]
    );
  }

  async insertTables(client, restaurant) {
    for (const table of restaurant.tables) {
      await client.query(
        'INSERT INTO "table" (id_table, id_restaurant, capacity, is_available) VALUES ($1, $2::UUID, $3, $4)',
        [table.id_table, restaurant.id, table.capacity, table.isAvailable]
      );
    }
  }

  async insertAddress(client, restaurant) {
    const { id, address } = restaurant;
    await client.query(
      "INSERT INTO restaurant_address (id_restaurant, country, state, city, street) VALUES ($1::UUID, $2, $3, $4, $5)",
      [id, address.country, address.state, address.city, address.street]
    );
  }

  async insertReservations(client, restaurant, { tableId, customerId }) {
    for (const reservation of restaurant.reservations) {
      const id_customer =
        customerId[Math.floor(Math.random() * customerId.length)];
      const id_table = tableId[Math.floor(Math.random() * tableId.length)];

      await client.query(
        "INSERT INTO reservation (id_reservation, id_customer, id_table, description, reservation_date, start_time, end_time) VALUES ($1::UUID, $2::UUID, $3::UUID, $4, $5, $6, $7)",
        [
          reservation.id_reservation,
          id_customer,
          id_table,
          reservation.description,
          reservation.reservationDate,
          reservation.start_time,
          reservation.end_time,
        ]
      );
    }
  }
}

export default DataInserter;
