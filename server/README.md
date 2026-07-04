# EcoPacha · Proxy de IA (Groq / Gemini)

Mini-servidor que mantiene la **API key en el servidor** (nunca en el APK).
La app le envía la foto y él devuelve la clasificación del residuo.

- **Proveedor por defecto: Groq** (gratis, **sin tarjeta**).
- Alternativa: Gemini (requiere facturación según región).

## Requisitos
- **Node.js 18 o superior** (usa `fetch` nativo). Sin dependencias npm.

## Pasos (Groq — gratis, sin tarjeta)
1. Consigue una API key **gratis** en **[console.groq.com](https://console.groq.com)**
   (regístrate con Google/GitHub → **API Keys** → **Create API Key**). No pide tarjeta.
2. Copia la plantilla y pega tu key:
   ```bash
   cp server/.env.example server/.env
   # edita server/.env:  GROQ_API_KEY=gsk_tu_key
   ```
3. Levanta el proxy:
   ```bash
   node server/server.js
   ```
   Debe decir: `... (provider: groq, model: ..., key: OK)`
4. Prueba: abre <http://localhost:3000> (debe decir `"status":"ok"`, `"keyConfigured":true`).

> Si al clasificar sale un error de **modelo no encontrado**, cambia `GROQ_MODEL` en
> `server/.env` por otro modelo de visión (ver [modelos de Groq](https://console.groq.com/docs/models),
> p. ej. `meta-llama/llama-4-maverick-17b-128e-instruct`).

## Conectar la app al proxy
- **Emulador Android** (host = `10.0.2.2`):
  ```bash
  flutter run --dart-define=USE_AI=true --dart-define=AI_BACKEND_URL=http://10.0.2.2:3000/classify
  ```
- **Teléfono físico** (misma WiFi, IP LAN de tu PC, ej. `192.168.1.20`):
  ```bash
  flutter run --dart-define=USE_AI=true --dart-define=AI_BACKEND_URL=http://192.168.1.20:3000/classify
  ```
- **Sin flags:** la app usa el clasificador local (demo). Además hace *fallback* a demo
  automático si el proxy no responde, para que la demo nunca se rompa.

## Cambiar a Gemini (opcional)
En `server/.env`: pon `PROVIDER=gemini` y `GEMINI_API_KEY=...` (requiere facturación activa).

## Seguridad
- `server/.env` está en `.gitignore` (la key no se sube al repo).
- La key nunca viaja al APK: la app solo conoce la URL del proxy.
- **Producción:** despliega este `server.js` en un host **HTTPS** gratuito (Render, Railway,
  Deno Deploy…) y apunta `AI_BACKEND_URL` a esa URL `https://...`.
