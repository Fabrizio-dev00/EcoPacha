import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/placeholder_view.dart';

class HabitatScreen extends StatelessWidget {
  const HabitatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: AppStrings.navHabitat,
      icon: Icons.park_outlined,
      subtitle: 'Lumi y su EcoHábitat evolutivo (Fase 6).',
    );
  }
}
