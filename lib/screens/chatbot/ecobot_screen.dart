import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/placeholder_view.dart';

class EcoBotScreen extends StatelessWidget {
  const EcoBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: AppStrings.navEcoBot,
      icon: Icons.chat_bubble_outline,
      subtitle: 'Tu asistente educativo de reciclaje (Fase 5).',
    );
  }
}
