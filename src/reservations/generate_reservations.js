import pool from "../pool.js";
import { faker } from "@faker-js/faker";
import { v4 as uuid } from "uuid";

async function getPersonsFromDatabase() {
  const client = await pool.connect();
  try {
    const result = await client.query("SELECT id_customer FROM person");
    return result.rows.map((row) => row.id_customer);
  } catch (error) {
    console.error(
      "Возникла ошибка при получении идентификаторов пользователей из базы данных",
      error
    );
    throw error;
  } finally {
    client.release();
  }
}
