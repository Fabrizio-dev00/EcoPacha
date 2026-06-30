# 🔥 EcoPacha — Guía para conectar Firebase + IA real (Fase 8)

> El MVP funciona 100% local. Esta guía conecta servicios reales **sin reescribir la app**:
> solo se reemplazan implementaciones detrás de interfaces ya existentes.
>
> **applicationId del proyecto:** `com.ecopacha.ecopacha`

---

## Antes de empezar
- Cuenta de Google y acceso a [console.firebase.google.com](https://console.firebase.google.com).
- Node.js instalado (para la CLI de Firebase).
- Flutter ya configurado (este repo).

---

## Paso 1 · Crear el proyecto en Firebase
1. Entra a la consola de Firebase → **Agregar proyecto** → nómbralo `EcoPacha`.
2. (Opcional) Desactiva Google Analytics para simplificar.

## Paso 2 · Conectar Flutter con FlutterFire
```bash
# 1. Instala las CLIs (una sola vez)
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# 2. Inicia sesión
firebase login

# 3. Desde la carpeta del proyecto, vincula tu app:
flutterfire configure
#   - Elige el proyecto EcoPacha
#   - Selecciona plataformas: Android (y iOS si lo usarás)
#   - Genera lib/firebase_options.dart automáticamente
```

## Paso 3 · Añadir dependencias
```bash
flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage
flutter pub add http   # para llamar al backend de IA
```

## Paso 4 · Inicializar Firebase en `lib/main.dart`
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ...
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ...resto igual...
}
```

## Paso 5 · Activar servicios en la consola
- **Authentication** → Sign-in method → habilita **Correo/contraseña** y **Anónimo** (modo invitado).
- **Firestore Database** → Crear base de datos (modo de prueba para empezar).
- **Storage** → Crear (para las fotos de residuos).

Reglas mínimas de Firestore para arrancar (endurecer antes de producción):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == uid;
    }
    match /collection_points/{id} { allow read: if true; allow write: if false; }
  }
}
```

---

## Paso 6 · Hacer el *swap* en el código
La app ya está hecha para esto. Solo creas las implementaciones reales y las inyectas en
`lib/app.dart` (cambias el `create:` de cada provider). **No tocas la UI.**

| Interfaz (ya existe) | Implementación local actual | Nueva implementación a crear |
|---|---|---|
| `AuthService` | `LocalAuthService` | `FirebaseAuthService` |
| `FirestoreService` | `MockFirestoreService` | `FirebaseFirestoreService` |
| `RecyclingClassifierService` | `DemoClassifierService` | `AiClassifierService` |
| `ChatbotService` | `LocalKeywordChatbotService` | `AiChatbotService` (opcional) |

Ejemplo de swap en [lib/app.dart](../lib/app.dart):
```dart
// Antes:  Provider<FirestoreService>(create: (_) => MockFirestoreService()),
// Después: Provider<FirestoreService>(create: (_) => FirebaseFirestoreService()),
```
Y en [lib/main.dart](../lib/main.dart):
```dart
// Antes:  final authService = LocalAuthService(storage);
// Después: final authService = FirebaseAuthService(); // implementa AuthService
```

Esqueleto de `FirebaseAuthService` (mapea a tu modelo `AppUser`):
```dart
class FirebaseAuthService implements AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  // register -> createUserWithEmailAndPassword + guardar AppUser en /users/{uid}
  // signIn -> signInWithEmailAndPassword + leer /users/{uid}
  // signInAsGuest -> signInAnonymously
  // restoreSession -> _auth.currentUser (si existe, cargar AppUser)
  // updateUser -> _db.collection('users').doc(uid).set(user.toJson())
}
```

---

## Paso 7 · IA real (clasificación)
**Regla de oro: la API key de IA NUNCA va en el APK.** Vive en un backend o Cloud Function.

1. Crea una **Cloud Function** (o backend) que:
   - reciba la imagen (URL de Storage o multipart),
   - llame al modelo de visión con tu API key (guardada como secreto del servidor),
   - devuelva un JSON con la forma de `RecyclingResult` (`material`, `category`, `confidence`, ...).
2. Pon la URL en `.env` (ya ignorado por git):
   ```
   AI_BACKEND_URL=https://tu-region-tu-proyecto.cloudfunctions.net/classify
   USE_DEMO_SERVICES=false
   ```
3. Carga `.env` en `main.dart` (con `flutter_dotenv`) y declara `.env` como asset en `pubspec.yaml`.
4. Crea `AiClassifierService implements RecyclingClassifierService`:
```dart
class AiClassifierService implements RecyclingClassifierService {
  @override
  Future<RecyclingResult> classify(String imagePath) async {
    final url = dotenv.env['AI_BACKEND_URL']!;
    // subir imagen / enviar al backend, recibir JSON
    // return RecyclingResult.fromJson(json);  // ¡ya tienes fromJson!
  }
}
```
5. Swap en `lib/app.dart`: `RecyclingProvider(AiClassifierService())`.
   Recomendado: si el backend falla, hacer *fallback* a `DemoClassifierService` para que la demo nunca se rompa.

---

## Seguridad y git
- `google-services.json` y `GoogleService-Info.plist` **ya están en `.gitignore`** (no se suben).
- `firebase_options.dart` puede commitearse (no contiene secretos de servidor).
- El secreto real de IA vive **solo en el backend**.

## Checklist Fase 8
- [ ] `flutterfire configure` ejecutado (genera `firebase_options.dart`).
- [ ] Auth (correo + anónimo), Firestore y Storage activados en consola.
- [ ] `FirebaseAuthService` y `FirebaseFirestoreService` creados y swapeados en `app.dart`/`main.dart`.
- [ ] Cloud Function de IA desplegada; `AI_BACKEND_URL` en `.env`.
- [ ] `AiClassifierService` con fallback a demo.
- [ ] `flutter analyze` y `flutter test` en verde tras el swap.
