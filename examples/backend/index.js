import express from "express";
import morgan from "morgan";
import pjson from "../package.json" with { type: "json" };
import { PORT } from "./config.js";
import userRoutes from "./routes/users.routes.js";
import portfolioRoutes from "./routes/portfolio.routes.js";
import strategyRoutes from "./routes/strategy.routes.js";
import dealRoutes from "./routes/deal.routes.js";

console.log("*****************************");
console.log(`${pjson.name} V ${pjson.version}`);
console.log("*****************************");

const app = express();

// Middleware
app.use(morgan("dev"));
app.use(express.json());
app.use(userRoutes);
app.use(portfolioRoutes);
app.use(strategyRoutes);
app.use(dealRoutes);

// Iniciar servidor
app.listen(PORT, () => {
  console.log(
    `Servidor escuchando en https://portfolio-manager-8l8s.onrender.com\n\n`
  );
});
