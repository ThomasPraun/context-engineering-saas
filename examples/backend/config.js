export const PORT = process.env.PORT || 80;
export const DATABASE_URL =
  process.env.DATABASE_URL ||
  "postgres://postgres:postgres@localhost:5432/portfolio_manager";
export const SSL = process.env.SSL || null;
export const DEBUG = process.env.DEBUG || false;
