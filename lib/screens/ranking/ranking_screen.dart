import 'package:flutter/material.dart';
import '../../widgets/placeholder_view.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Ranking',
      icon: Icons.emoji_events_outlined,
      subtitle: 'Ranking semanal entre usuarios (Fase 7).',
    );
  }
}
