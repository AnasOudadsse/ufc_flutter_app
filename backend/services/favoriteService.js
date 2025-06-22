const { getDb } = require('../db');
const Favorite = require('../models/favorite');

async function getAllFavorites() {
  const db = getDb();
  return new Promise((res, rej) => {
    db.all('SELECT fighterId, name FROM favorites', (e, rows) => {
      if (e) rej(e);
      else res(rows.map(r => new Favorite(r.fighterId, r.name)));
    });
  });
}

async function addFavorite(fighterId, name) {
  const db = getDb();
  return new Promise((res, rej) => {
    db.run(
      'INSERT OR IGNORE INTO favorites (fighterId, name) VALUES (?, ?)',
      [fighterId, name],
      err => err ? rej(err) : res()
    );
  });
}

async function removeFavorite(fighterId) {
  const db = getDb();
  return new Promise((res, rej) => {
    db.run(
      'DELETE FROM favorites WHERE fighterId = ?',
      [fighterId],
      function(err) {
        if (err) rej(err);
        else res(this.changes);
      }
    );
  });
}

module.exports = { getAllFavorites, addFavorite, removeFavorite };