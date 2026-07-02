/// Configuración de ejecución, inyectable con --dart-define (no son secretos).
///
/// La API key de IA NO vive aquí: está en el proxy (server/). Aquí solo guardamos
/// si usar IA y la URL del proxy.
class AppConfig {
  AppConfig._();

  /// Activa el clasificador con IA (Gemini vía proxy). Por defecto usa el demo local.
  /// Actívalo con:  --dart-define=USE_AI=true
  static const bool useAi = bool.fromEnvironment('USE_AI', defaultValue: false);

  /// URL del proxy de IA. Por defecto apunta al host del emulador Android (10.0.2.2).
  /// Cámbialo con:  --dart-define=AI_BACKEND_URL=http://TU_IP:3000/classify
  static const String aiBackendUrl = String.fromEnvironment(
    'AI_BACKEND_URL',
    defaultValue: 'http://10.0.2.2:3000/classify',
  );
}
