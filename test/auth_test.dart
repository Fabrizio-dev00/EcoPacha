import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecopacha/services/auth_service.dart';
import 'package:ecopacha/services/local_auth_service.dart';
import 'package:ecopacha/services/storage_service.dart';

Future<LocalAuthService> _buildAuth() async {
  final storage = await StorageService.create();
  return LocalAuthService(storage);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('register crea el usuario, normaliza el correo y persiste la sesión',
      () async {
    final auth = await _buildAuth();
    final user = await auth.register(
      name: 'Ana',
      email: 'Ana@Mail.com',
      password: 'secret1',
    );

    expect(user.email, 'ana@mail.com');
    expect(auth.currentUser, isNotNull);

    final restored = await auth.restoreSession();
    expect(restored?.email, 'ana@mail.com');
  });

  test('register con correo duplicado lanza AuthException', () async {
    final auth = await _buildAuth();
    await auth.register(name: 'Ana', email: 'ana@mail.com', password: 'secret1');

    await expectLater(
      auth.register(name: 'Ana 2', email: 'ana@mail.com', password: 'otra123'),
      throwsA(isA<AuthException>()),
    );
  });

  test('signIn falla con contraseña incorrecta y funciona con la correcta',
      () async {
    final auth = await _buildAuth();
    await auth.register(name: 'Ana', email: 'ana@mail.com', password: 'secret1');

    await expectLater(
      auth.signIn(email: 'ana@mail.com', password: 'incorrecta'),
      throwsA(isA<AuthException>()),
    );

    final user = await auth.signIn(email: 'ana@mail.com', password: 'secret1');
    expect(user.email, 'ana@mail.com');
  });

  test('signInAsGuest devuelve un usuario invitado', () async {
    final auth = await _buildAuth();
    final guest = await auth.signInAsGuest();
    expect(guest.isGuest, true);
  });

  test('signOut limpia la sesión persistida', () async {
    final auth = await _buildAuth();
    await auth.register(name: 'Ana', email: 'ana@mail.com', password: 'secret1');
    await auth.signOut();
    expect(auth.currentUser, isNull);
    expect(await auth.restoreSession(), isNull);
  });
}
