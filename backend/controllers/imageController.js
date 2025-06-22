// controllers/imageController.js
const fetch = require('node-fetch');

async function proxyImage(req, res) {
  const url = req.query.url;
  if (!url) {
    return res.status(400).send('Error: Missing ?url= parameter');
  }
  const upstream = await fetch(url);
  if (!upstream.ok) {
    return res.status(upstream.status).send('Upstream error');
  }
  // Add CORS header so browser will allow it
  res.set('Access-Control-Allow-Origin', '*');
  // Forward correct MIME type
  res.set('Content-Type', upstream.headers.get('content-type') || 'application/octet-stream');
  upstream.body.pipe(res);
}

module.exports = { proxyImage };
