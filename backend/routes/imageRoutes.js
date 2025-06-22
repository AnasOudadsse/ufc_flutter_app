// routes/imageRoutes.js
const express = require('express');
const router  = express.Router();
const { proxyImage } = require('../controllers/imageController');

router.get('/', proxyImage);

module.exports = router;
