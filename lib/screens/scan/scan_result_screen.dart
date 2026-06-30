import 'package:flutter/material.dart';
import '../../widgets/placeholder_view.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Resultado',
      icon: Icons.recycling,
      subtitle: 'Resultado de la clasificación del residuo (Fase 4).',
    );
  }
}
