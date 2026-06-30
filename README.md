# 🌱 EcoPacha

> Recicla, aprende y transforma.

EcoPacha es una app móvil (Flutter) que ayuda a clasificar correctamente los residuos
domésticos usando inteligencia artificial, educación ambiental, gamificación y una mascota
virtual llamada **Lumi**.

**Frase:** *“EcoPacha transforma pequeñas acciones de reciclaje en hábitos sostenibles,
aprendizaje e impacto visible.”*

## Stack
- Flutter · Dart · Material 3
- go_router (navegación) · provider (estado)
- shared_preferences (persistencia local)
- Firebase Auth/Firestore/Storage e IA real (fase futura, vía backend seguro)

## Estado del proyecto
En construcción por fases. Ver el plan de ejecución en
[`docs/PLAN_DE_PROMPTS.md`](docs/PLAN_DE_PROMPTS.md).

## Requisitos
- Flutter SDK (canal estable)
- Android Studio + Android SDK

## Cómo ejecutar (una vez creado el proyecto)
```bash
flutter pub get
flutter run
```

## Seguridad
Nunca se incluyen API keys en el código ni en el APK. La configuración no sensible se maneja
con `flutter_dotenv` (`.env`, ignorado por git); los secretos reales viven en el backend.
