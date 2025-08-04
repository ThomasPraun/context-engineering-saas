import { pool } from "../db.js";

export const getUsers = async (req, res) => {
  const { rows } = await pool.query("SELECT * FROM users");
  return res.json(rows);
};

export const getUser = async (req, res) => {
  const { user, pass, id } = req.body;

  const { rows } =
    id == 0
      ? await pool.query(
          'SELECT * FROM users WHERE "user" = $1 AND pass = $2',
          [user, pass]
        )
      : await pool.query("SELECT * FROM users WHERE id = $1", [id]);

  if (rows.length === 0) {
    return res.status(404).json({ error: "User not found" });
  }
  return res.status(200).json(rows);
};

export const createUser = async (req, res) => {
  const { user, pass } = req.body;
  const { rowCount } = await pool.query(
    'INSERT INTO users ("user", pass) VALUES ($1, $2) RETURNING *',
    [user, pass]
  );

  if (rowCount === 0) {
    return res.status(409).json({ error: "User not available" });
  }
  return res.sendStatus(204);
};

export const updateUser = async (req, res) => {
  const { pass, user } = req.body; //TODO chequear como prevenir de que cualquier pueda cambiar la clave
  const { rowCount } = await pool.query(
    'UPDATE users SET pass = $2 WHERE "user" = $3',
    [pass, user]
  );

  if (rowCount === 0) {
    return res.status(404).json({ error: "User not found" });
  }
  return res.json(rows);
};

export const deleteUser = async (req, res) => {
  const { user, pass } = req.body;
  const { rowCount } = await pool.query(
    'DELETE FROM users WHERE "user" = $1 AND pass = $2 RETURNING *',
    [user, pass]
  );

  if (rowCount === 0) {
    return res.status(404).json({ error: "User not found" });
  }
  return res.sendStatus(204);
};
