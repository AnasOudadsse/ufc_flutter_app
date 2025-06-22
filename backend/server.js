const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const favoriteRoutes = require("./routes/favoriteRoutes");
const { initDb } = require("./db");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors()); // Enable CORS
app.use(bodyParser.json()); // Parse JSON

initDb(); // Initialize SQLite and create tables
app.use("/favorites", favoriteRoutes);

app.listen(PORT, () =>
  console.log(`Server running on http://localhost:${PORT}`)
);
