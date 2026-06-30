import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Formato de fechas en español.
  Intl.defaultLocale = 'es';
  await initializeDateFormatting('es', null);

  runApp(const EcoPachaApp());
}
