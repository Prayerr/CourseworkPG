import pkg from "pg";
const { Pool } = pkg;

const pool = new Pool({
  user: "postgres",
  password: "root",
  host: "localhost",
  port: 5432,
  database: "coursework",
});

export default pool;
