import '../models/app_user.dart';
import 'auth_service.dart';
import 'storage_service.dart';

/// Implementación de [AuthService] con persistencia local (shared_preferences).
///
/// Pensada para el MVP y las demos sin conexión. NO es autenticación segura:
/// en la Fase 8, Firebase Auth la reemplaza para el manejo real de credenciales.
class LocalAuthService implements AuthService {
  LocalAuthService(this._storage);

  final StorageService _storage;

  static const String _usersKey = 'auth_users';
  static const String _currentUserKey = 'auth_current_user';

  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser?> restoreSession() async {
    final json = _storage.getJson(_currentUserKey);
    if (json == null) return null;
    _currentUser = AppUser.fromJson(json);
    return _currentUser;
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = _readUsers();
    if (users.containsKey(normalizedEmail)) {
      throw AuthException('Ya existe una cuenta con ese correo.');
    }

    final user = AppUser(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      createdAt: DateTime.now(),
    );

    users[normalizedEmail] = {
      'passwordHash': _hashPassword(password),
      'user': user.toJson(),
    };
    await _storage.setJson(_usersKey, users);
    await _setSession(user);
    return user;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final entry = _readUsers()[normalizedEmail];
    if (entry == null) {
      throw AuthException('No encontramos una cuenta con ese correo.');
    }
    final map = Map<String, dynamic>.from(entry as Map);
    if (map['passwordHash'] != _hashPassword(password)) {
      throw AuthException('La contraseña es incorrecta.');
    }
    final user = AppUser.fromJson(Map<String, dynamic>.from(map['user'] as Map));
    await _setSession(user);
    return user;
  }

  @override
  Future<AppUser> signInAsGuest() async {
    final user = AppUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Invitado',
      email: '',
      isGuest: true,
      createdAt: DateTime.now(),
    );
    await _setSession(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    await _storage.remove(_currentUserKey);
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await _setSession(user);
    // Mantén sincronizada la "tabla" de usuarios para futuros inicios de sesión.
    if (!user.isGuest && user.email.isNotEmpty) {
      final users = _readUsers();
      final entry = users[user.email];
      if (entry != null) {
        final map = Map<String, dynamic>.from(entry as Map);
        map['user'] = user.toJson();
        users[user.email] = map;
        await _storage.setJson(_usersKey, users);
      }
    }
  }

  Map<String, dynamic> _readUsers() =>
      Map<String, dynamic>.from(_storage.getJson(_usersKey) ?? {});

  Future<void> _setSession(AppUser user) async {
    _currentUser = user;
    await _storage.setJson(_currentUserKey, user.toJson());
  }

  /// Hash NO criptográfico (FNV-1a), solo para el modo local de demo.
  /// Evita guardar la contraseña en texto plano. La seguridad real la aporta
  /// Firebase Auth en la Fase 8.
  String _hashPassword(String password) {
    var hash = 0x811c9dc5;
    for (final unit in password.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }
}
