import pg from "pg";
import { DATABASE_URL, SSL } from "./config.js";

// Forzar que todos los BIGINT (OID 20) se conviertan a Number
pg.types.setTypeParser(20, (val) => {
  return val === null ? null : parseInt(val);
});

export const pool = new pg.Pool({
  connectionString: DATABASE_URL,
  ssl: SSL,
});

// pool
//   .query("SELECT NOW()")
//   .then((res) => {
//     console.log("Conexión a la base de datos exitosa:", res.rows[0].now);
//   })
//   .catch((err) => {
//     console.log("Error en conexión a la base de datos:", err);
//   });
