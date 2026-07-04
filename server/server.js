// EcoPacha · Mini-proxy de IA (Groq / Gemini)
// -----------------------------------------------------------------------------
// Mantiene la API key EN EL SERVIDOR (nunca en el APK). Recibe una imagen
// (base64), la envía al proveedor de IA elegido y devuelve la clasificación.
//
// Proveedor por defecto: GROQ (gratis, sin tarjeta -> https://console.groq.com)
// Alternativa: GEMINI (requiere facturacion segun region).
//
// Requisitos: Node.js 18+ (fetch nativo). Sin dependencias npm.
// Uso:
//   1) copia server/.env.example a server/.env y pega tu key (GROQ_API_KEY)
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

const PROVIDER = (process.env.PROVIDER || 'groq').toLowerCase();
const PORT = process.env.PORT || 3000;

const GROQ_API_KEY = process.env.GROQ_API_KEY;
const GROQ_MODEL =
  process.env.GROQ_MODEL || 'meta-llama/llama-4-scout-17b-16e-instruct';

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_MODEL = process.env.GEMINI_MODEL || 'gemini-2.0-flash';

const activeKey = PROVIDER === 'gemini' ? GEMINI_API_KEY : GROQ_API_KEY;
const activeModel = PROVIDER === 'gemini' ? GEMINI_MODEL : GROQ_MODEL;

const PROMPT = `Eres un clasificador de residuos para reciclaje en Perú.
Observa la imagen y responde SOLO con JSON válido con esta forma exacta:
{"category": "<uno de: plasticoPet, papelCarton, vidrio, metal, organico, pilas, electronicos, noReciclable>",
 "material": "<nombre corto en español>",
 "confidence": <número entre 0 y 1>,
 "instructions": "<cómo reciclarlo, 1 frase en español>",
 "tip": "<consejo breve en español>"}
No agregues texto fuera del JSON.`;

// Extrae un objeto JSON aunque venga con texto o ```fences``` alrededor.
function parseJson(text) {
  try {
    return JSON.parse(text);
  } catch (_) {
    const match = text.match(/\{[\s\S]*\}/);
    if (match) return JSON.parse(match[0]);
    throw new Error('La IA no devolvió JSON: ' + text.slice(0, 200));
  }
}

async function classifyGroq(imageBase64, mimeType) {
  const dataUrl = `data:${mimeType || 'image/jpeg'};base64,${imageBase64}`;
  const resp = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${GROQ_API_KEY}`,
    },
    body: JSON.stringify({
      model: GROQ_MODEL,
      temperature: 0.2,
      messages: [
        {
          role: 'user',
          content: [
            { type: 'text', text: PROMPT },
            { type: 'image_url', image_url: { url: dataUrl } },
          ],
        },
      ],
    }),
  });
  const data = await resp.json();
  if (!resp.ok) throw new Error('Groq ' + resp.status + ': ' + JSON.stringify(data));
  return parseJson(data?.choices?.[0]?.message?.content ?? '{}');
}

async function classifyGemini(imageBase64, mimeType) {
  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`;
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
  if (!resp.ok) throw new Error('Gemini ' + resp.status + ': ' + JSON.stringify(data));
  return parseJson(data?.candidates?.[0]?.content?.parts?.[0]?.text ?? '{}');
}

function classify(imageBase64, mimeType) {
  return PROVIDER === 'gemini'
    ? classifyGemini(imageBase64, mimeType)
    : classifyGroq(imageBase64, mimeType);
}

const server = http.createServer((req, res) => {
  if (req.method === 'GET' && req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      status: 'ok',
      provider: PROVIDER,
      model: activeModel,
      keyConfigured: !!activeKey,
    }));
    return;
  }

  if (req.method === 'POST' && req.url === '/classify') {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
      if (body.length > 20 * 1024 * 1024) req.destroy();
    });
    req.on('end', async () => {
      try {
        if (!activeKey) {
          throw new Error(`Falta la API key para ${PROVIDER} en server/.env`);
        }
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
    `EcoPacha AI proxy → http://localhost:${PORT}  (provider: ${PROVIDER}, model: ${activeModel}, key: ${activeKey ? 'OK' : 'FALTA'})`,
  );
});
