import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/habitat_catalog.dart';
import '../providers/user_progress_provider.dart';
import 'level_up_dialog.dart';

/// Scaffold principal con barra de navegación inferior (Material 3).
/// Usa el [StatefulNavigationShell] de go_router para conservar el estado de
/// cada pestaña. También muestra la celebración cuando el usuario sube de nivel.
class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool _showingLevelUp = false;

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _maybeShowLevelUp(UserProgressProvider progress) {
    final pending = progress.pendingLevelUp;
    if (pending == null || _showingLevelUp) return;
    _showingLevelUp = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      progress.consumeLevelUp();
      await showLevelUpDialog(
        context,
        level: pending,
        unlocked: HabitatCatalog.unlockedAtLevel(pending),
      );
      if (mounted) _showingLevelUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _maybeShowLevelUp(context.watch<UserProgressProvider>());

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: AppStrings.navScan,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: AppStrings.navEcoBot,
          ),
          NavigationDestination(
            icon: Icon(Icons.park_outlined),
            selectedIcon: Icon(Icons.park),
            label: AppStrings.navHabitat,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.navProfile,
          ),
        ],
      ),
    );
  }
}
