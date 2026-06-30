import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Gestiona el estado de autenticación y expone estados de carga/éxito/error.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  AppUser? get user => _authService.currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => user?.isGuest ?? false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Restaura la sesión guardada al arrancar la app.
  Future<void> init() async {
    final restored = await _authService.restoreSession();
    _status = restored != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(() => _authService.register(
          name: name,
          email: email,
          password: password,
        ));
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) {
    return _run(() => _authService.signIn(email: email, password: password));
  }

  Future<bool> signInAsGuest() => _run(_authService.signInAsGuest);

  Future<void> signOut() async {
    await _authService.signOut();
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> _run(Future<AppUser> Function() action) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await action();
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Ocurrió un error inesperado. Inténtalo de nuevo.';
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
