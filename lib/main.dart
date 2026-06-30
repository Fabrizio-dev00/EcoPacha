import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'services/local_auth_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Formato de fechas en español.
  Intl.defaultLocale = 'es';
  await initializeDateFormatting('es', null);

  // Capa de datos local y autenticación (se reemplazará por Firebase en Fase 8).
  final storage = await StorageService.create();
  final authService = LocalAuthService(storage);
  final authProvider = AuthProvider(authService);
  await authProvider.init();

  runApp(EcoPachaApp(
    storage: storage,
    authService: authService,
    authProvider: authProvider,
  ));
}
