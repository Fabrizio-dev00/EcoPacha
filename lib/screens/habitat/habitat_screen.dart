import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/habitat_catalog.dart';
import '../../models/habitat_item.dart';
import '../../providers/user_progress_provider.dart';
import '../../widgets/habitat_info_bottom_sheet.dart';
import '../../widgets/habitat_item_widget.dart';
import '../../widgets/habitat_scene.dart';
import '../../widgets/lumi_message_card.dart';

/// Pantalla de Lumi y su EcoHábitat interactivo y evolutivo.
class HabitatScreen extends StatelessWidget {
  const HabitatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<UserProgressProvider>();
    final theme = Theme.of(context);
    final level = progress.level;

    return Scaffold(
      appBar:
          AppBar(title: const Text('${AppStrings.mascotName} y su EcoHábitat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HabitatScene(),
          const SizedBox(height: 8),
          Text(
            'Toca a Lumi o mantén y arrastra los objetos para acomodar tu hábitat.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _LevelCard(progress: progress),
          const SizedBox(height: 20),
          _SectionTitle('Objetos del hábitat'),
          const SizedBox(height: 10),
          _ItemsGrid(level: level, progress: progress),
          const SizedBox(height: 20),
          _SectionTitle('Próxima mejora'),
          const SizedBox(height: 8),
          _NextUpgradeCard(next: progress.nextLockedItem, progress: progress),
          const SizedBox(height: 20),
          LumiMessageCard(message: progress.lumiMessage),
        ],
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

class _LevelCard extends StatelessWidget {
  final UserProgressProvider progress;

  const _LevelCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxed = progress.isMaxLevel;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nivel ${progress.level}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.warning, size: 18),
                    const SizedBox(width: 4),
                    Text(
                        '${progress.streakDays} día${progress.streakDays == 1 ? '' : 's'}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _bar(context, 'XP', progress.levelProgress, AppColors.primary),
            const SizedBox(height: 4),
            Text(
              maxed
                  ? '¡Nivel máximo alcanzado! 🌳'
                  : '${progress.xp} / ${progress.nextLevelXp} XP  ·  faltan ${progress.pointsToNextLevel}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            _bar(context, 'Energía ecológica', progress.levelProgress,
                AppColors.turquoise),
          ],
        ),
      ),
    );
  }

  Widget _bar(BuildContext context, String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _ItemsGrid extends StatelessWidget {
  final int level;
  final UserProgressProvider progress;

  const _ItemsGrid({required this.level, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 14,
      children: [
        for (final item in HabitatCatalog.items)
          _ItemTile(
            item: item,
            unlocked: level >= item.requiredLevel,
            progress: progress,
          ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  final HabitatItem item;
  final bool unlocked;
  final UserProgressProvider progress;

  const _ItemTile({
    required this.item,
    required this.unlocked,
    required this.progress,
  });

  void _onTap(BuildContext context) {
    if (!unlocked) {
      showHabitatLocked(context, item, progress.levelProgress);
    } else if (item.action == HabitatItemAction.scan) {
      context.go('/scan');
    } else if (item.action == HabitatItemAction.impact) {
      showHabitatImpact(context, progress.totalImpact);
    } else {
      showHabitatItemInfo(context, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: SizedBox(
        width: 74,
        child: Column(
          children: [
            HabitatItemWidget(item: item, size: 52, locked: !unlocked),
            const SizedBox(height: 4),
            Text(
              unlocked ? item.name : 'Nivel ${item.requiredLevel}',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11,
                color:
                    unlocked ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextUpgradeCard extends StatelessWidget {
  final HabitatItem? next;
  final UserProgressProvider progress;

  const _NextUpgradeCard({required this.next, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (next == null) {
      return const Card(
        color: AppColors.surfaceMuted,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.accentYellow),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                    '¡Desbloqueaste todo el EcoHábitat! Eres Guardián de la Pacha. 🌳'),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      color: AppColors.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            HabitatItemWidget(item: next!, size: 44, locked: true),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(next!.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Se desbloquea en el nivel ${next!.requiredLevel}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
