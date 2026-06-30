import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/placeholder_view.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: AppStrings.navScan,
      icon: Icons.camera_alt_outlined,
      subtitle: 'Aquí podrás tomar o subir una foto del residuo (Fase 4).',
    );
  }
}
