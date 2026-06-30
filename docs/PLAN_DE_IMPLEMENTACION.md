# 🗺️ EcoPacha — Plan de implementación (y estado real)

Registro del plan por fases tal como se ejecutó, con entregables, estado y commits.
Documentos relacionados: [`PLAN_DE_PROMPTS.md`](PLAN_DE_PROMPTS.md) (guion de prompts),
[`GUIA_DEMO.md`](GUIA_DEMO.md) (presentación) y [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md) (Fase 8).

## Resumen
EcoPacha es una app Flutter (Android primero, compatible con iOS) para clasificar residuos
con educación, gamificación y la mascota **Lumi**. El MVP está **completo y funcional en modo
local-first** (Fases 0–7 + mascota + docs). Solo falta la Fase 8 (Firebase + IA real), que
depende de credenciales del usuario.

## Decisiones técnicas (ajustes senior aplicados)
- **Gestor de estado:** `provider` (uno solo, no mezclar con Riverpod).
- **Navegación:** `go_router` con `StatefulShellRoute.indexedStack` (estado por pestaña).
- **Fuente única de verdad del progreso:** `UserProgressProvider` (EcoPuntos, nivel, racha,
  impacto, retos, historial). Las pantallas leen de ahí; Lumi se **deriva** de él.
- **Servicios detrás de interfaces** (swap sin tocar UI): `AuthService`,
  `RecyclingClassifierService`, `ChatbotService`, `FirestoreService`.
- **Seguridad:** sin API keys en el APK; `.env` ignorado por git; secretos reales en el backend.
- **Sin crashes por assets:** Lumi se dibuja con `CustomPaint` (sin archivos externos).

## Arquitectura de carpetas (lib/)
```
core/        constants (colors, strings, impact) · theme · routes · utils
models/      app_user, recycling_result(+WasteCategory), recycling_record,
             challenge, mascot_progress, collection_point, leaderboard_user
services/    auth (interfaz+local), storage, recycling_classifier (interfaz+demo),
             chatbot (interfaz+local), impact, firestore (interfaz+mock)
providers/   auth, user_progress (fuente única), recycling, mascot, leaderboard
screens/     splash · auth (login/register) · home · scan (+result) · chatbot ·
             habitat · ranking · collection_points · profile
widgets/     bottom_navigation, eco_points_card, challenge_card, impact_card,
             lumi_message_card, lumi_avatar, recycling_result_card,
             loading_overlay, placeholder_view
mock/        challenges · collection_points · leaderboard
```

## Plan por fases y estado

| Fase | Descripción | Estado | Commit |
|------|-------------|--------|--------|
| 0 | Entorno, Flutter SDK, repo propio, proyecto base | ✅ | `4b2485b` |
| 1 | Tema M3, rutas, 7 modelos, mocks, navegación inferior | ✅ | `020034e` |
| 2 | Autenticación local + invitado, perfil, rutas protegidas | ✅ | `0a0d3ba` |
| 3 | Dashboard + gamificación (fuente única de progreso) | ✅ | `88ceb6c` |
| 4 | Escaneo + clasificación simulada (camino dorado) | ✅ | `5292734` |
| 5 | EcoBot educativo (palabras clave) | ✅ | `275107c` |
| 6 | Lumi y EcoHábitat evolutivo | ✅ | `27f8ec4` |
| 7 | Ranking + puntos de acopio (filtrable) | ✅ | `7bfb375` |
| — | Mascota Lumi animada (CustomPaint) | ✅ | `916efab` |
| 9 | Guía de demo + APK release | ✅ | `cd11967` |
| 8 | **Firebase + IA real** | ⏸️ Pendiente (requiere cuentas del usuario) | — |

### Detalle de entregables por fase
- **Fase 0 — Base del entorno:** Flutter 3.44.4 / Dart 3.12.2 instalado; repositorio git propio
  dentro de `EcoPacha`; proyecto creado (org `com.ecopacha`, android+ios); `.gitignore` y
  `.env.example`.
- **Fase 1 — Base del proyecto:** `app_colors`, `app_strings`, `impact_constants`, `app_theme`
  (Material 3), `app_router` (StatefulShell), `formatters`; 7 modelos serializables; 3 mocks;
  `bottom_navigation` + `placeholder_view`; splash y home iniciales.
- **Fase 2 — Auth y perfil local:** `StorageService`, `AuthService`+`LocalAuthService`
  (hash FNV-1a, sin texto plano), `AuthProvider` (carga/éxito/error), login con modo invitado,
  registro con validaciones, perfil con logout, `redirect` que protege rutas.
- **Fase 3 — Dashboard y gamificación:** `UserProgressProvider` (fuente única) +
  `ImpactService`; home con EcoPuntos, nivel, racha, reto diario, impacto y Lumi; sistema de
  racha sin castigos; recompensas por reto.
- **Fase 4 — Escaneo:** `RecyclingClassifierService`+`DemoClassifierService` (10 muestras
  realistas); `RecyclingProvider` (idle/analyzing/success/error); pantallas de escaneo
  (cámara/galería) y resultado; confirmar reciclaje actualiza el progreso; permisos iOS.
- **Fase 5 — EcoBot:** `ChatbotService`+`LocalKeywordChatbotService` (9 reglas + fallback);
  chat con sugerencias; aprender avanza el reto correspondiente.
- **Fase 6 — Lumi y EcoHábitat:** `MascotProvider` deriva el estado de Lumi del progreso;
  hábitat que evoluciona maceta→jardín→árbol; energía, racha, objetos, próxima mejora.
- **Fase 7 — Ranking y acopio:** `FirestoreService`+`MockFirestoreService`;
  `LeaderboardProvider`; ranking con podio top 3; puntos de acopio filtrables por residuo.
- **Mascota Lumi:** colibrí animado con `CustomPaint` (flotación + aleteo) en splash, inicio,
  hábitat y EcoBot.

## Estado de calidad (verificado)
- `flutter analyze` → **0 issues**.
- `flutter test` → **23/23** (modelos, auth, progreso, clasificador, EcoBot, Lumi, ranking).
- **Android** compila en debug y release; **APK release** generado (48.5 MB).
- Ejecutado en **emulador Pixel 6**: instala, lanza y corre sin crashes.

## Cómo continuar (Fase 8 — opcional para la demo)
Seguir [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md): crear proyecto Firebase, `flutterfire configure`,
activar Auth/Firestore/Storage y backend de IA; luego reemplazar las implementaciones locales
por las reales en `lib/app.dart` y `lib/main.dart` (swap detrás de interfaces, sin tocar la UI).
