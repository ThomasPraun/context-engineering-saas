import { Router } from "express";
import { DEBUG } from "../config.js";
import {
  getUsers,
  getUser,
  createUser,
  deleteUser,
  updateUser,
} from "../controllers/users.controllers.js";

const router = Router();

if (DEBUG) router.get("/users", getUsers);

router.get("/user", getUser);

router.post("/user", createUser);

router.put("/user", updateUser);

router.delete("/user", deleteUser);

export default router;
