import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

/// Raíz de la aplicación EcoPacha.
/// En la Fase 2 se envolverá con MultiProvider para el estado global.
class EcoPachaApp extends StatelessWidget {
  const EcoPachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
