import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/recycling_provider.dart';
import 'providers/user_progress_provider.dart';
import 'services/auth_service.dart';
import 'services/chatbot_service.dart';
import 'services/demo_classifier_service.dart';
import 'services/local_keyword_chatbot_service.dart';
import 'services/storage_service.dart';

/// Raíz de la aplicación EcoPacha.
/// Registra los providers globales y construye el router una sola vez.
class EcoPachaApp extends StatefulWidget {
  final StorageService storage;
  final AuthService authService;
  final AuthProvider authProvider;

  const EcoPachaApp({
    super.key,
    required this.storage,
    required this.authService,
    required this.authProvider,
  });

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
        // El progreso depende de la sesión: se carga al autenticar y se limpia al salir.
        ChangeNotifierProxyProvider<AuthProvider, UserProgressProvider>(
          create: (_) =>
              UserProgressProvider(widget.storage, widget.authService),
          update: (_, auth, progress) {
            (progress ??=
                    UserProgressProvider(widget.storage, widget.authService))
                .syncWithAuth(auth.user, auth.isAuthenticated);
            return progress;
          },
        ),
        ChangeNotifierProvider<RecyclingProvider>(
          create: (_) => RecyclingProvider(DemoClassifierService()),
        ),
        Provider<ChatbotService>(
          create: (_) => LocalKeywordChatbotService(),
        ),
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
