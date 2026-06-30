import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/placeholder_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: AppStrings.navProfile,
      icon: Icons.person_outline,
      subtitle: 'Tu perfil, insignias e historial (Fase 2).',
    );
  }
}
