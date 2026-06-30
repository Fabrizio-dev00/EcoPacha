import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';

/// Raíz de la aplicación EcoPacha.
/// Registra los providers globales y construye el router una sola vez.
class EcoPachaApp extends StatefulWidget {
  final AuthProvider authProvider;

  const EcoPachaApp({super.key, required this.authProvider});

  @override
  State<EcoPachaApp> createState() => _EcoPachaAppState();
}

class _EcoPachaAppState extends State<EcoPachaApp> {
  late final GoRouter _router = createRouter(widget.authProvider);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: widget.authProvider),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
