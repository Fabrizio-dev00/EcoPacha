import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/mascot_progress.dart';
import '../../widgets/lumi_avatar.dart';

/// Pantalla de Lumi y su EcoHábitat evolutivo.
class HabitatScreen extends StatelessWidget {
  const HabitatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mascot = context.watch<MascotProgress>();

    return Scaffold(
      appBar: AppBar(title: const Text('${AppStrings.mascotName} y su EcoHábitat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HabitatScene(stage: mascot.currentHabitatStage),
          const SizedBox(height: 16),
          _StatsCard(mascot: mascot),
          const SizedBox(height: 16),
          const _SectionTitle('Objetos desbloqueados'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in mascot.unlockedItems)
                Chip(
                  avatar: const Icon(Icons.check_circle,
                      size: 18, color: AppColors.success),
                  label: Text(item),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Próxima mejora'),
          const SizedBox(height: 8),
          _NextUpgradeCard(mascot: mascot),
        ],
      ),
    );
  }
}

class _HabitatScene extends StatelessWidget {
  final HabitatStage stage;

  const _HabitatScene({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFBFE9FF), AppColors.surfaceMuted],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lumi (placeholder; sustituible por animación Lottie en assets/animations).
          Container(
            height: 92,
            width: 92,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const LumiAvatar(size: 80),
          ),
          const SizedBox(height: 8),
          Text(_sceneEmoji(stage), style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 4),
          Text(
            stage.label,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _sceneEmoji(HabitatStage stage) {
    switch (stage) {
      case HabitatStage.maceta:
        return '🪴';
      case HabitatStage.jardin:
        return '🌿🌸🦋';
      case HabitatStage.arbol:
        return '🌳🌻☀️';
    }
  }
}

class _StatsCard extends StatelessWidget {
  final MascotProgress mascot;

  const _StatsCard({required this.mascot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nivel ${mascot.level}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.warning, size: 18),
                    const SizedBox(width: 4),
                    Text('${mascot.streakDays} día${mascot.streakDays == 1 ? '' : 's'}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Energía ecológica',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: mascot.energy,
                minHeight: 10,
                backgroundColor: AppColors.surfaceMuted,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 6),
            Text('${(mascot.energy * 100).round()}% de energía',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _NextUpgradeCard extends StatelessWidget {
  final MascotProgress mascot;

  const _NextUpgradeCard({required this.mascot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMax = mascot.currentHabitatStage == HabitatStage.arbol;
    final message = isMax
        ? '¡Tu EcoHábitat está al máximo! 🌳 Sigue reciclando para mantener a Lumi feliz.'
        : 'Sube al nivel ${mascot.currentHabitatStage == HabitatStage.maceta ? 3 : 5} '
            'para evolucionar tu hábitat. ¡Sigue reciclando!';

    return Card(
      color: AppColors.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
          ],
        ),
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
