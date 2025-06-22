const favoriteService = require('../services/favoriteService');

async function getFavorites(req, res) {
  try {
    const favorites = await favoriteService.getAllFavorites();
    res.json({ favorites });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function createFavorite(req, res) {
  const { fighterId, name } = req.body;
  if (!fighterId || !name) return res.status(400).json({ error: 'fighterId and name required' });
  try {
    await favoriteService.addFavorite(fighterId, name);
    res.status(201).json({ fighterId, name });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function deleteFavorite(req, res) {
  const { fighterId } = req.params;
  try {
    const changes = await favoriteService.removeFavorite(fighterId);
    if (!changes) res.status(404).json({ error: 'Not found' });
    else res.json({ deleted: fighterId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = { getFavorites, createFavorite, deleteFavorite };