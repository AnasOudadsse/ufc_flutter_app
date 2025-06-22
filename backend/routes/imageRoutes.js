// routes/imageRoutes.js
const express = require('express');
const router = express.Router();
const imageController = require('../controllers/imageController');

// GET /img?url=<encoded image URL>
router.get('/', imageController.proxyImage);

module.exports = router;


// controllers/imageController.js
const fetch = require('node-fetch');

/**
 * Proxy an external image URL and inject CORS headers
 */
async function proxyImage(req, res) {
  const url = req.query.url;
  if (!url) {
    return res.status(400).send('Error: Missing ?url= parameter');
  }
  try {
    const upstream = await fetch(url);
    if (!upstream.ok) {
      return res.status(upstream.status).send('Upstream error');
    }

    // Allow cross-origin access
    res.set('Access-Control-Allow-Origin', '*');
    // Mirror the content type
    res.set('Content-Type', upstream.headers.get('content-type') || 'image/png');
    // Pipe the image stream
    upstream.body.pipe(res);
  } catch (err) {
    console.error('Proxy error:', err);
    res.status(500).send('Proxy fetch failed');
  }
}

module.exports = { proxyImage };


// server.js   (excerpt showing route integration)
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const favoriteRoutes = require('./routes/favoriteRoutes');
const imageRoutes    = require('./routes/imageRoutes');
const { initDb } = require('./db');

const app = express();

app.use(cors());
app.use(bodyParser.json());
initDb();

// Mount routes
app.use('/favorites', favoriteRoutes);
app.use('/img',        imageRoutes);

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
