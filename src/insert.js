import pool from "./pool.js";
import TableGenerator from "./table/generate_tables.js";

export async function insertData(restaurantData) {
  const client = await pool.connect();
  try {
    const tableGenerator = new TableGenerator();
    await client.query("BEGIN");

    for (const restaurant of restaurantData) {
      const { id, name, working_hours, restaurant_phone } = restaurant;

      await client.query(
        "INSERT INTO restaurant_info (id_restaurant, name, opening_hours, restaurant_phone) VALUES ($1, $2, $3, $4)",
        [id, name, working_hours, restaurant_phone]
      );

      for (let i = 0; i < 10; i++) {
        await client.query(
          'INSERT INTO "table" (id_table, id_restaurant, capacity, is_available) VALUES ($1, $2, $3, $4)',
          [
            tableGenerator.id_table,
            restaurantId,
            tableGenerator.capacity,
            tableGenerator.isAvailable,
          ]
        );
      }

      await client.query("COMMIT");
    }
    console.log("Соединение с базой данных успешно и начато");
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Возникли ошибки с подключением к базе данных", error);
  } finally {
    client.release();
    console.log("Соединение с базой данных закончено");
  }
}
