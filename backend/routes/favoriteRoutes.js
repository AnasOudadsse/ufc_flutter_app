const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/favoriteController');

router.get('/', ctrl.getFavorites);
router.post('/', ctrl.createFavorite);
router.delete('/:fighterId', ctrl.deleteFavorite);

module.exports = router;