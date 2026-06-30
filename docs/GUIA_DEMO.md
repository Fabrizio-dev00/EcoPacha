# 🎤 EcoPacha — Guía de presentación (hackathon)

## El "camino dorado" del demo (lo que muestras al jurado)
1. **Splash** → frase "Recicla, aprende y transforma."
2. **Login** → toca **"Entrar como invitado"** (cero fricción).
3. **Inicio** → muestra EcoPuntos, nivel, racha, reto diario, impacto y tarjeta de Lumi.
4. **Escanear** → "Tomar foto" o "Subir imagen" → indicador de análisis.
5. **Resultado** → material, contenedor, instrucciones, consejo, EcoPuntos e impacto.
6. **Confirmar reciclaje** → vuelve a Inicio y se ven **subir los EcoPuntos, el impacto y el reto**.
7. **EcoBot** → pregunta "¿Qué hago con pilas usadas?" → respuesta educativa.
8. **Hábitat** → Lumi, energía, racha y objetos; el hábitat evoluciona con el nivel.
9. **Ranking** (ícono 🏆 en Inicio) → podio top 3.
10. **Puntos de acopio** (ícono 📍 en Inicio) → filtra por "Pilas".

> Tip: repite "Confirmar reciclaje" 3 veces con plástico para **completar el reto** y ver la
> recompensa de EcoPuntos en acción.

## Cómo correr la app
```bash
flutter pub get
flutter run            # en un dispositivo/emulador Android
# APK de demo:
flutter build apk --debug
# APK de presentación (firmado con clave debug por defecto):
flutter build apk --release
```
El SDK de Flutter está en `C:\Users\USUARIO.DESKTOP-O8B05DQ\flutter` (ya en el PATH).

## Estado de funcionalidades
| Funcionalidad | Estado |
|---|---|
| Registro / login / invitado | ✅ Real (local, shared_preferences) |
| Dashboard, EcoPuntos, niveles, racha | ✅ Real (fuente única) |
| Escaneo (cámara/galería) | ✅ Real (image_picker) |
| Clasificación IA | 🟡 Simulada (DemoClassifierService) — IA real en Fase 8 |
| EcoBot | 🟡 Local por palabras clave — IA real en Fase 8 |
| Retos y recompensas | ✅ Real |
| Lumi y EcoHábitat | ✅ Real (derivado del progreso) |
| Impacto ambiental | ✅ Real (constantes simuladas, centralizadas) |
| Ranking | 🟡 Mock (listo para Firestore) |
| Puntos de acopio | 🟡 Mock filtrable (listo para Firestore/Maps) |

## Funciona sin internet
La app es **local-first**: registro, escaneo, retos, Lumi, ranking y acopio funcionan
**sin conexión**. Ideal para demos con WiFi inestable.

## Checklist antes de presentar
- [ ] `flutter analyze` sin issues y `flutter test` en verde.
- [ ] Probar el camino dorado completo en el dispositivo de la demo.
- [ ] Tener el APK instalado y abierto antes de subir al escenario.
- [ ] Cargar 1–2 fotos de residuos en la galería para "Subir imagen".
- [ ] Brillo del teléfono alto; modo "no molestar".

## Lo que falta (Fase 8, requiere tus credenciales)
- **Firebase** (Auth, Firestore, Storage): crear proyecto y `flutterfire configure`.
- **IA real**: backend/Cloud Function que reciba la imagen y devuelva la clasificación;
  la API key vive en el servidor, nunca en el APK.
- El swap es de bajo riesgo: las interfaces (`AuthService`, `RecyclingClassifierService`,
  `ChatbotService`, `FirestoreService`) ya están listas para reemplazar la implementación local.
