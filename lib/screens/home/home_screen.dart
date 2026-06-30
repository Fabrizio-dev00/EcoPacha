import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../widgets/challenge_card.dart';
import '../../widgets/eco_points_card.dart';
import '../../widgets/impact_card.dart';
import '../../widgets/lumi_message_card.dart';

/// Pantalla de Inicio (dashboard). Lee el progreso vivo de [UserProgressProvider].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = context.watch<UserProgressProvider>();
    final auth = context.watch<AuthProvider>();
    final firstName = _firstName(auth.user?.name);
    final daily = progress.dailyChallenge;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: 'Ranking',
            onPressed: () => context.push('/ranking'),
            icon: const Icon(Icons.emoji_events_outlined),
          ),
          IconButton(
            tooltip: 'Puntos de acopio',
            onPressed: () => context.push('/collection-points'),
            icon: const Icon(Icons.location_on_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            '¡Hola, $firstName! 👋',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Pequeñas acciones, gran impacto.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          EcoPointsCard(
            ecoPoints: progress.ecoPoints,
            level: progress.level,
            streakDays: progress.streakDays,
            levelProgress: progress.levelProgress,
            pointsToNextLevel: progress.pointsToNextLevel,
          ),
          const SizedBox(height: 16),
          const _QuickScanButton(),
          const SizedBox(height: 20),
          const _SectionTitle('Reto diario'),
          const SizedBox(height: 8),
          if (daily != null)
            ChallengeCard(challenge: daily)
          else
            Text(
              '¡Estás al día con tus retos! 🎉',
              style: theme.textTheme.bodyMedium,
            ),
          const SizedBox(height: 20),
          const _SectionTitle('Tu impacto esta semana'),
          const SizedBox(height: 8),
          ImpactCard(impact: progress.weeklyImpact),
          const SizedBox(height: 20),
          LumiMessageCard(message: progress.lumiMessage),
        ],
      ),
    );
  }

  String _firstName(String? name) {
    if (name == null || name.trim().isEmpty) return 'Eco';
    return name.trim().split(RegExp(r'\s+')).first;
  }
}

class _QuickScanButton extends StatelessWidget {
  const _QuickScanButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => context.go('/scan'),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escanear un residuo'),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
