import '../models/app_user.dart';

/// Error de autenticación con un mensaje en español listo para mostrar.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

/// Contrato de autenticación.
///
/// La implementación local ([LocalAuthService]) se usa en el MVP. En la Fase 8
/// se sustituye por una implementación con Firebase Auth sin cambiar la UI.
abstract class AuthService {
  /// Usuario actual en memoria, o null si no hay sesión.
  AppUser? get currentUser;

  /// Restaura la sesión persistida al iniciar la app.
  Future<AppUser?> restoreSession();

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<AppUser> signInAsGuest();

  Future<void> signOut();

  /// Persiste los cambios del usuario (EcoPuntos, racha, etc.).
  Future<void> updateUser(AppUser user);
}
