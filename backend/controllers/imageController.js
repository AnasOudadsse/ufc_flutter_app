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
    // Mirror the content type (e.g. image/png)
    res.set('Content-Type', upstream.headers.get('content-type') || 'application/octet-stream');
    // Pipe the image bytes directly to the response
    upstream.body.pipe(res);
  } catch (err) {
    console.error('Proxy error:', err);
    res.status(500).send('Proxy fetch failed');
  }
}

module.exports = { proxyImage };
