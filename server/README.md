# EcoPacha · Proxy de IA (Gemini)

Mini-servidor que mantiene la **API key de Gemini en el servidor** (nunca en el APK).
La app le envía la foto y él devuelve la clasificación del residuo.

## Requisitos
- **Node.js 18 o superior** (usa `fetch` nativo). Sin dependencias npm.

## Pasos
1. Consigue una API key **gratis** en [Google AI Studio](https://aistudio.google.com) → **Get API key**.
2. Copia la plantilla y pega tu key:
   ```bash
   cp server/.env.example server/.env
   # edita server/.env y pon:  GEMINI_API_KEY=tu_key
   ```
3. Levanta el proxy:
   ```bash
   node server/server.js
   ```
   Verás: `EcoPacha AI proxy → http://localhost:3000 (modelo: gemini-2.0-flash, key: OK)`
4. Prueba que responde: abre <http://localhost:3000> en el navegador (debe decir `"status":"ok"`).

## Conectar la app al proxy
- **Emulador Android:** el host se alcanza en `10.0.2.2`. Corre la app así:
  ```bash
  flutter run --dart-define=USE_AI=true --dart-define=AI_BACKEND_URL=http://10.0.2.2:3000/classify
  ```
- **Teléfono físico (misma red WiFi):** usa la IP LAN de tu PC (ej. `192.168.1.20`):
  ```bash
  flutter run --dart-define=USE_AI=true --dart-define=AI_BACKEND_URL=http://192.168.1.20:3000/classify
  ```
- **Sin flags:** la app usa el clasificador local (demo). El código además hace *fallback*
  automático a demo si el proxy no responde, para que la demo nunca se rompa.

## Seguridad
- `server/.env` está en `.gitignore` (la key no se sube al repo).
- La key nunca viaja al APK: la app solo conoce la URL del proxy.
- **Producción:** despliega este `server.js` en un host **HTTPS** gratuito (Render, Railway,
  Deno Deploy, etc.) y apunta `AI_BACKEND_URL` a esa URL `https://...` (ahí no necesitas
  cleartext ni el manifest de debug).
