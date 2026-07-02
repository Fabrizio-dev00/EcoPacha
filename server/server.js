// EcoPacha · Mini-proxy de IA (Gemini)
// -----------------------------------------------------------------------------
// Mantiene la API key de Google AI Studio EN EL SERVIDOR (nunca en el APK).
// Recibe una imagen (base64), la envía a Gemini y devuelve la clasificación.
//
// Requisitos: Node.js 18+ (usa fetch nativo). Sin dependencias npm.
// Uso:
//   1) copia server/.env.example a server/.env y pega tu GEMINI_API_KEY
//   2) node server/server.js
// -----------------------------------------------------------------------------

const http = require('http');
const fs = require('fs');
const path = require('path');

// Carga variables desde server/.env si existen (o usa las del entorno).
function loadEnv() {
  const envPath = path.join(__dirname, '.env');
  if (!fs.existsSync(envPath)) return;
  for (const line of fs.readFileSync(envPath, 'utf8').split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim();
  }
}
loadEnv();

const API_KEY = process.env.GEMINI_API_KEY;
const MODEL = process.env.GEMINI_MODEL || 'gemini-2.0-flash';
const PORT = process.env.PORT || 3000;

const PROMPT = `Eres un clasificador de residuos para reciclaje en Perú.
Observa la imagen y responde SOLO con JSON válido con esta forma exacta:
{"category": "<uno de: plasticoPet, papelCarton, vidrio, metal, organico, pilas, electronicos, noReciclable>",
 "material": "<nombre corto en español>",
 "confidence": <número entre 0 y 1>,
 "instructions": "<cómo reciclarlo, 1 frase en español>",
 "tip": "<consejo breve en español>"}
No agregues texto fuera del JSON.`;

async function classify(imageBase64, mimeType) {
  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${API_KEY}`;
  const resp = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      contents: [
        {
          parts: [
            { text: PROMPT },
            { inline_data: { mime_type: mimeType || 'image/jpeg', data: imageBase64 } },
          ],
        },
      ],
      generationConfig: { responseMimeType: 'application/json', temperature: 0.2 },
    }),
  });
  const data = await resp.json();
  if (!resp.ok) {
    throw new Error('Gemini ' + resp.status + ': ' + JSON.stringify(data));
  }
  const text = data?.candidates?.[0]?.content?.parts?.[0]?.text ?? '{}';
  return JSON.parse(text);
}

const server = http.createServer((req, res) => {
  // Health check
  if (req.method === 'GET' && req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', model: MODEL, keyConfigured: !!API_KEY }));
    return;
  }

  if (req.method === 'POST' && req.url === '/classify') {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
      if (body.length > 20 * 1024 * 1024) req.destroy(); // límite 20 MB
    });
    req.on('end', async () => {
      try {
        if (!API_KEY) throw new Error('GEMINI_API_KEY no configurada en server/.env');
        const { imageBase64, mimeType } = JSON.parse(body || '{}');
        if (!imageBase64) throw new Error('Falta imageBase64');
        const result = await classify(imageBase64, mimeType);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(result));
      } catch (e) {
        console.error('Error:', e.message);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: String(e.message || e) }));
      }
    });
    return;
  }

  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'not found' }));
});

server.listen(PORT, () => {
  console.log(
    `EcoPacha AI proxy → http://localhost:${PORT}  (modelo: ${MODEL}, key: ${API_KEY ? 'OK' : 'FALTA'})`,
  );
});
