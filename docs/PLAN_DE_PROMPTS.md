# EcoPacha — Documento Maestro de Prompts de Ejecución

> **Propósito:** secuencia de prompts ordenada, autocontenida y con criterios de aceptación
> para construir EcoPacha de principio a fin **sin errores**, con disciplina de líder técnico
> y gestor de proyectos. Cada fase es un "ticket": no se avanza a la siguiente hasta cumplir
> su **Definición de Hecho (DoD)**.

- **App:** EcoPacha — clasificación de residuos con IA, educación, gamificación y mascota (Lumi).
- **Stack:** Flutter (estable) · Dart · Material 3 · go_router · provider · shared_preferences.
- **Plataforma:** Android primero, estructura compatible con iOS.
- **Idioma:** UI 100 % en español · código en inglés consistente · comentarios mínimos en español.

---

## 0. Cómo usar este documento

1. Ejecutamos **una fase a la vez**, en orden.
2. Antes de empezar cada fase, yo confirmo dependencias cumplidas.
3. Al terminar, corro la **verificación obligatoria** y te muestro el resultado.
4. **No avanzo a la siguiente fase sin tu confirmación.**
5. Si una fase no pasa su DoD, no se da por cerrada: se corrige primero.

### Leyenda de estado del tablero
`⬜ Pendiente` · `🟦 En curso` · `✅ Hecho (DoD cumplido)` · `⛔ Bloqueado`

| Fase | Módulo | Estado | Depende de |
|------|--------|--------|-----------|
| 0 | Preparación del entorno | ⬜ | — |
| 1 | Base del proyecto (tema, rutas, navegación, modelos, mocks) | ⬜ | 0 |
| 2 | Autenticación y perfil local | ⬜ | 1 |
| 3 | Dashboard y gamificación (fuente única de progreso) | ⬜ | 2 |
| 4 | Escaneo y clasificación simulada | ⬜ | 3 |
| 5 | EcoBot educativo | ⬜ | 3 |
| 6 | Lumi y EcoHábitat | ⬜ | 3 |
| 7 | Ranking y puntos de acopio | ⬜ | 1 |
| 8 | Firebase e IA real (post-MVP) | ⬜ | 2,4,7 |
| 9 | Pruebas, demo y APK release | ⬜ | 3-7 |

---

## 1. Convenciones globales (válidas para TODOS los prompts)

> Este bloque es el "contrato" permanente. Aplica a cada fase aunque no se repita.

**Arquitectura y estilo**
- Arquitectura por capas: `models/` · `services/` · `providers/` · `screens/` · `widgets/` · `core/` · `mock/`.
- Gestión de estado: **provider** (un solo gestor en todo el proyecto, sin mezclar con Riverpod).
- Navegación: **go_router** con `StatefulShellRoute.indexedStack` para la barra inferior (conserva el estado de cada pestaña).
- **Una sola fuente de verdad** para el progreso del usuario (EcoPuntos, racha, impacto, energía de Lumi, retos): vive en `UserProgressProvider`. Las pantallas **leen** de ahí; no recalculan por su cuenta.
- Servicios definidos como **interfaz abstracta + implementación local primero** (`AuthService` → `LocalAuthService`, `RecyclingClassifierService` → `DemoClassifierService`, etc.), para que el cambio a Firebase/IA sea un swap trivial.
- Widgets **pequeños y reutilizables**; nada de pantallas monolíticas de 500 líneas.
- Comentarios solo donde aporten; nombres autoexplicativos.

**Reglas de calidad (innegociables)**
- Null-safety estricto. Sin `dynamic` salvo en bordes de (de)serialización.
- Todo modelo: `fromJson` / `toJson` + `copyWith` + `==`/`hashCode` cuando aplique.
- Manejo explícito de estados: **carga · éxito · error · vacío**.
- **Cero API keys en el código ni en el APK.** Config no sensible vía `.env` (con `flutter_dotenv`), y el `.env` va en `.gitignore`. Aviso importante: `flutter_dotenv` **no es una frontera de seguridad** (el `.env` se puede extraer del APK); los secretos reales viven en backend/Cloud Function.
- **Fallbacks de assets:** si falta una animación Lottie o imagen, la UI muestra un placeholder (Icon/imagen) y nunca rompe el build.
- Textos de UI centralizados en `core/constants/app_strings.dart`.
- Valores de impacto ambiental centralizados en `core/constants/impact_constants.dart`.

**Definición de Hecho (DoD) — se aplica al cierre de CADA fase**
1. `flutter analyze` → **0 errores y 0 warnings**.
2. `flutter test` → **verde** (cuando la fase incluya tests).
3. La app **compila y corre en Android** sin excepciones en consola en el flujo de la fase.
4. Sin `TODO` que rompa funcionalidad ni código muerto.
5. Sin keys ni secretos hardcodeados.
6. Commit con mensaje claro: `feat(faseN): <resumen>`.

---

## FASE 0 — Preparación del entorno

**Objetivo:** dejar el entorno y el repositorio listos y sanos antes de escribir una sola línea de la app.

**Contexto detectado (a resolver aquí):**
- El repo git tiene su raíz en la carpeta de usuario (`C:\Users\USUARIO.DESKTOP-O8B05DQ`), no en `EcoPacha`. Hay que crear un repositorio propio dentro de `EcoPacha`.
- Flutter/Dart no están en el PATH de la terminal: verificar instalación.

### Prompt 0
```
Prepara el entorno de EcoPacha:
1. Verifica que Flutter y Dart estén instalados y en el PATH; si no, dame los pasos exactos
   para instalarlos en Windows (Flutter SDK + Android Studio + aceptar licencias android).
2. Crea un repositorio git PROPIO dentro de la carpeta EcoPacha (sin tocar ni borrar el git
   de mi carpeta de usuario).
3. Crea el proyecto Flutter en esta carpeta con organización com.ecopacha.app,
   plataformas android e ios.
4. Genera el .gitignore correcto para Flutter y añade .env a la lista.
5. Crea un .env.example con las claves que se usarán a futuro (sin valores reales).
6. Haz el primer commit: "chore(fase0): inicializa proyecto EcoPacha".
```

**Entregables**
- Proyecto Flutter creado y ejecutable (pantalla por defecto corre en Android).
- `.gitignore`, `.env.example`, repositorio git inicializado dentro de `EcoPacha`.

**DoD específico**
- `flutter doctor` sin problemas bloqueantes para Android.
- `flutter run` levanta la app de ejemplo en emulador/dispositivo.
- `git status` confirma que la raíz del repo ahora es `EcoPacha`.

---

## FASE 1 — Base del proyecto

**Objetivo:** estructura, tema, navegación, modelos y mocks. La app corre y se puede navegar entre las pantallas (aún vacías) mediante la barra inferior.

### Prompt 1
```
Implementa la Fase 1 (base) de EcoPacha siguiendo las convenciones globales:
1. Estructura de carpetas completa según la arquitectura por capas.
2. core/constants: app_colors.dart (verde, turquesa, blanco, amarillo), app_strings.dart,
   impact_constants.dart (valores de referencia de CO2, agua, peso por categoría).
3. core/theme/app_theme.dart con Material 3 (light), tipografía y componentes.
4. core/routes/app_router.dart con go_router + StatefulShellRoute.indexedStack para las
   5 pestañas: Inicio, Escanear, EcoBot, Hábitat, Perfil. Más rutas hijas (login, registro,
   resultado de escaneo, ranking, puntos de acopio).
5. widgets/bottom_navigation.dart (shell de navegación inferior).
6. Modelos serializables completos: AppUser, RecyclingResult, RecyclingRecord, Challenge,
   MascotProgress, CollectionPoint, LeaderboardUser (fromJson/toJson/copyWith).
7. Datos mock: mock_challenges.dart, mock_collection_points.dart, mock_leaderboard.dart.
8. Pantallas placeholder mínimas para que la navegación funcione.
9. main.dart y app.dart conectando tema + router + MultiProvider (vacío por ahora).
Entrega el código completo de cada archivo y al final corre flutter analyze.
```

**Entregables clave:** `pubspec.yaml`, `main.dart`, `app.dart`, tema, colores, strings, constantes de impacto, router con shell, bottom nav, 7 modelos, 3 mocks, placeholders.

**DoD específico:** navegación inferior funcional entre las 5 pestañas, estado de pestaña preservado, `flutter analyze` limpio.

---

## FASE 2 — Autenticación y perfil local

**Objetivo:** login, registro y modo invitado funcionando contra una capa de auth local (sin Firebase aún), con persistencia en `shared_preferences`.

### Prompt 2
```
Implementa la Fase 2 (auth y perfil local):
1. services/auth_service.dart como INTERFAZ abstracta (signIn, register, signInAsGuest,
   signOut, currentUser stream/getter).
2. LocalAuthService (implementación con shared_preferences) que persiste el usuario.
3. services/storage_service.dart: wrapper tipado sobre shared_preferences (get/set JSON).
4. providers/auth_provider.dart con estados carga/éxito/error.
5. screens/auth/login_screen.dart y register_screen.dart con validaciones claras en español
   (correo válido, contraseña mínima, campos requeridos) y botón visible de "Entrar como invitado".
6. screens/splash/splash_screen.dart: muestra logo + "Recicla, aprende y transforma." y decide
   ruta inicial según si hay sesión.
7. screens/profile/profile_screen.dart: foto opcional, nombre, nivel, EcoPuntos, racha y
   botón cerrar sesión.
8. Conecta el AuthProvider en el MultiProvider y protege rutas con redirect en go_router.
Corre flutter analyze al final.
```

**DoD específico:** registro → guarda usuario; reinicio de app mantiene sesión; invitado entra sin credenciales; logout limpia sesión y redirige a login.

---

## FASE 3 — Dashboard y gamificación (fuente única de progreso)

**Objetivo:** el corazón del MVP. `UserProgressProvider` como única fuente de verdad; home que lo refleja; retos con progreso y racha.

### Prompt 3
```
Implementa la Fase 3 (dashboard y gamificación):
1. providers/user_progress_provider.dart: FUENTE ÚNICA de EcoPuntos, nivel, racha, impacto
   (residuos, CO2, agua) y progreso de retos. Métodos: addRecyclingResult(result),
   completeChallengeStep(type), registerDailyActivity(). Persiste con storage_service.
2. services/impact_service.dart: calcula nivel a partir de puntos y agrega métricas de impacto
   usando impact_constants.
3. providers/challenge_provider.dart (o lógica dentro de user_progress): retos diarios desde
   mock con progreso real y recompensas.
4. screens/home/home_screen.dart: saludo personalizado, EcoPuntos, nivel, racha, reto diario
   con progreso, resumen de impacto semanal y tarjeta de Lumi con mensaje motivador.
5. widgets: eco_points_card.dart, challenge_card.dart, impact_card.dart, lumi_message_card.dart,
   loading_overlay.dart.
6. Lógica de racha: días activos consecutivos, sin castigos.
Corre flutter analyze y añade un test unitario de la lógica de puntos/nivel.
```

**DoD específico:** sumar puntos desde un método actualiza home, impacto, nivel y racha de forma consistente (un solo lugar de cálculo); test unitario de puntos→nivel en verde.

---

## FASE 4 — Escaneo y clasificación simulada

**Objetivo:** tomar/subir foto, clasificar (simulado realista) y, al confirmar, integrar con la fuente única de progreso.

### Prompt 4
```
Implementa la Fase 4 (escaneo y clasificación simulada):
1. services/recycling_classifier_service.dart: INTERFAZ abstracta classify(image) -> RecyclingResult.
2. services/demo_classifier_service.dart: resultados simulados REALISTAS para las 8 categorías
   (PET, papel/cartón, vidrio, metal, orgánico, pilas, electrónicos, no reciclable) con
   confianza, color de contenedor, instrucciones, consejo, EcoPuntos e impacto desde constantes.
3. providers/recycling_provider.dart con estados: idle/loading/success/error.
4. screens/scan/scan_screen.dart: botones grandes "Tomar foto" y "Subir imagen" (image_picker),
   vista previa e indicador de análisis.
5. screens/scan/scan_result_screen.dart: imagen, material, categoría, confianza, contenedor,
   instrucción, consejo, EcoPuntos, impacto y botón "Confirmar reciclaje".
6. widgets/recycling_result_card.dart.
7. Al confirmar: crear RecyclingRecord y llamar a UserProgressProvider.addRecyclingResult()
   para actualizar puntos, impacto, racha, retos y energía de Lumi.
Maneja permisos de cámara/galería y errores. Corre flutter analyze.
```

**DoD específico:** flujo completo escanear → resultado → confirmar suma puntos y actualiza impacto/retos sin duplicar lógica; manejo de permiso denegado y de "imagen no seleccionada".

---

## FASE 5 — EcoBot educativo

**Objetivo:** chatbot por palabras clave, con interfaz lista para conectar IA real después.

### Prompt 5
```
Implementa la Fase 5 (EcoBot):
1. services/chatbot_service.dart: INTERFAZ abstracta ask(question) -> ChatResponse.
2. LocalKeywordChatbotService: respuestas educativas por palabras clave para las FAQ
   (botella de aceite, papel con grasa, pilas usadas, botella PET, vidrio, electrónicos...).
3. screens/chatbot/ecobot_screen.dart: interfaz tipo chat con burbujas, sugerencias rápidas
   (chips) y respuestas cortas.
4. Sumar progreso del reto "Aprende 3 consejos con EcoBot" vía UserProgressProvider.
Deja documentado el punto de extensión para AiChatbotService (backend). Corre flutter analyze.
```

**DoD específico:** preguntas de ejemplo devuelven respuestas correctas; las sugerencias rápidas funcionan; aprender suma al reto correspondiente.

---

## FASE 6 — Lumi y EcoHábitat

**Objetivo:** pantalla de mascota que evoluciona según el progreso (derivado, no duplicado).

### Prompt 6
```
Implementa la Fase 6 (Lumi y EcoHábitat):
1. providers/mascot_provider.dart: deriva MascotProgress de UserProgressProvider
   (nivel, energía, racha, objetos desbloqueados, etapa de hábitat, próxima mejora).
2. screens/habitat/habitat_screen.dart: Lumi (animación Lottie con FALLBACK a imagen/icon),
   nivel, barra de energía, racha, objetos desbloqueados, próxima mejora y hábitat que
   evoluciona: maceta -> jardín -> árbol/huerto/panel solar.
3. Mensajes motivadores; nunca castigos ni "muerte" de la mascota.
Corre flutter analyze.
```

**DoD específico:** al reciclar en Fase 4, la energía/nivel de Lumi sube en esta pantalla sin recalcular nada; el hábitat cambia de etapa al alcanzar umbrales; sin assets, usa fallback.

---

## FASE 7 — Ranking y puntos de acopio

**Objetivo:** ranking con mocks y lista filtrable de puntos de acopio; servicios listos para Firebase.

### Prompt 7
```
Implementa la Fase 7 (ranking y puntos de acopio):
1. providers/leaderboard_provider.dart con datos mock (top 3 destacado visualmente).
2. screens/ranking/ranking_screen.dart: nombre, avatar, EcoPuntos, posición; podio para top 3.
3. screens/collection_points/collection_points_screen.dart: lista filtrable por tipo de residuo,
   tarjetas con nombre, distrito, horario y materiales aceptados (desde mock_collection_points).
4. services/firestore_service.dart: INTERFAZ abstracta (con implementación mock por ahora)
   lista para conectar Firestore en Fase 8.
Corre flutter analyze.
```

**DoD específico:** filtro por residuo funciona; top 3 resaltado; las pantallas leen de providers, no de mocks directos en la UI.

---

## FASE 8 — Firebase e IA real (post-MVP, opcional para la demo)

**Objetivo:** sustituir implementaciones locales por reales mediante swap de interfaces. **No bloquea la demo** si no se completa.

### Prompt 8
```
Implementa la Fase 8 (Firebase e IA real):
1. Configura Firebase (Auth, Firestore, Storage) con flutterfire; NO subas archivos de config
   con secretos al repo.
2. FirebaseAuthService implementando AuthService; swap por inyección de dependencias.
3. FirestoreService real para usuarios, puntos, ranking y retos.
4. Subida de imágenes a Firebase Storage.
5. AiClassifierService implementando RecyclingClassifierService, consumiendo un BACKEND/Cloud
   Function seguro (la API key vive en el servidor, nunca en Flutter).
6. flutter_dotenv solo para endpoints/config no sensible.
Mantén DemoClassifierService como fallback si el backend no responde. Corre flutter analyze.
```

**DoD específico:** la app funciona con Firebase real; si falla la red, hace fallback a las implementaciones locales; ningún secreto en el repo ni en el APK.

---

## FASE 9 — Pruebas, demo y APK release

**Objetivo:** dejar todo presentable y a prueba de fallos para el jurado.

### Prompt 9
```
Implementa la Fase 9 (pruebas y presentación):
1. Revisa los flujos del "camino dorado": invitado -> escanear -> resultado -> confirmar ->
   ver subir EcoPuntos/impacto + reacción de Lumi -> EcoBot.
2. Manejo de errores y estado sin internet (modo offline con datos locales).
3. Seed de datos demo realistas (usuario con progreso, retos a medio completar, ranking).
4. Pulido visual final coherente con la paleta (verde/turquesa/blanco/amarillo).
5. Genera el APK release: flutter build apk --release. Documenta el comando y la ruta del APK.
6. Checklist de demo para la presentación.
Corre flutter analyze y flutter test al final.
```

**DoD específico:** APK release generado; camino dorado sin crashes; funciona offline; checklist de demo entregado.

---

## Anexo — Reglas para mí (líder técnico) en cada ejecución

- **No mezclo fases.** Una entrega = una fase cerrada con su DoD.
- **Verifico antes de declarar "hecho":** corro `flutter analyze` y reporto el resultado real (si algo falla, lo digo y lo corrijo, no lo oculto).
- **No invento dependencias** que no estén justificadas por el plan.
- **Pregunto solo lo que sea decisión tuya;** lo demás lo decido con criterio senior y te lo informo.
- **Cada fase termina con un commit** semántico y un breve resumen de qué cambió y qué sigue.
