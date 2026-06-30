import 'package:flutter/material.dart';
import '../../widgets/placeholder_view.dart';

class CollectionPointsScreen extends StatelessWidget {
  const CollectionPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Puntos de acopio',
      icon: Icons.location_on_outlined,
      subtitle: 'Puntos de acopio cercanos por tipo de residuo (Fase 7).',
    );
  }
}
