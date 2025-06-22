const sqlite3 = require('sqlite3').verbose();
const path = require('path');
let db;

function initDb() {
  const dbFile = path.resolve(__dirname, '..', 'data', 'favorites.db');
  db = new sqlite3.Database(dbFile, err => {
    if (err) console.error('DB Connection Error', err);
    else console.log('Connected to SQLite DB');
  });
  db.run(`CREATE TABLE IF NOT EXISTS favorites (
    fighterId TEXT PRIMARY KEY,
    name TEXT NOT NULL
  )`);
}

function getDb() {
  if (!db) initDb();
  return db;
}

module.exports = { initDb, getDb };