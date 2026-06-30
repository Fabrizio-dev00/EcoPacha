import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/bottom_navigation.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/scan/scan_screen.dart';
import '../../screens/scan/scan_result_screen.dart';
import '../../screens/chatbot/ecobot_screen.dart';
import '../../screens/habitat/habitat_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/ranking/ranking_screen.dart';
import '../../screens/collection_points/collection_points_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Crea el router con go_router.
///
/// - La barra inferior usa StatefulShellRoute para mantener el estado por pestaña.
/// - El [redirect] protege las rutas según el estado de [authProvider]: si no hay
///   sesión, manda al login; si ya hay sesión, no deja volver a login/registro.
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isAuthenticated;
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/splash';

      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && (location == '/login' || location == '/register')) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/ranking',
        builder: (context, state) => const RankingScreen(),
      ),
      GoRoute(
        path: '/collection-points',
        builder: (context, state) => const CollectionPointsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          // 0 · Inicio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // 1 · Escanear
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scan',
                builder: (context, state) => const ScanScreen(),
                routes: [
                  GoRoute(
                    path: 'result',
                    builder: (context, state) => const ScanResultScreen(),
                  ),
                ],
              ),
            ],
          ),
          // 2 · EcoBot
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ecobot',
                builder: (context, state) => const EcoBotScreen(),
              ),
            ],
          ),
          // 3 · Hábitat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/habitat',
                builder: (context, state) => const HabitatScreen(),
              ),
            ],
          ),
          // 4 · Perfil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
