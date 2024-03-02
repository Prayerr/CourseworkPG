import pool from "./pool.js";

class DataInserter {
  async insertData(restaurantData) {
    const client = await pool.connect();

    try {
      await client.query("BEGIN");

      for (const restaurant of restaurantData) {
        await this.insertRestaurant(client, restaurant);
        await this.insertTables(client, restaurant);
        await this.insertAddress(client, restaurant);
      }

      await client.query("COMMIT");
      console.log("Соединение с базой данных успешно");
    } catch (error) {
      await client.query("ROLLBACK");
      console.error("Возникли ошибки с базой данных", error);
    } finally {
      client.release();
      console.log("Соединение с базой данных закончено");
    }
  }

  async insertRestaurant(client, restaurant) {
    const { id, name, workingHours, restaurantPhone } = restaurant;
    await client.query(
      "INSERT INTO restaurant (id_restaurant, name, working_hours, restaurant_phone) VALUES ($1, $2, $3, $4)",
      [id, name, workingHours, restaurantPhone]
    );
  }

  async insertTables(client, restaurant) {
    for (const table of restaurant.tables) {
      await client.query(
        'INSERT INTO "table" (id_table, id_restaurant, capacity, is_available) VALUES ($1, $2, $3, $4)',
        [table.id_table, restaurant.id, table.capacity, table.isAvailable]
      );
    }
  }

  async insertAddress(client, restaurant) {
    const { id, address } = restaurant;
    await client.query(
      "INSERT INTO restaurant_address (id_restaurant, country, state, city, street) VALUES ($1, $2, $3, $4, $5)",
      [id, address.country, address.state, address.city, address.street]
    );
  }
}

export default DataInserter;
