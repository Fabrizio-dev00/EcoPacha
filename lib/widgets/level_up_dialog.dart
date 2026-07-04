import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../models/habitat_item.dart';
import 'lumi_avatar.dart';

/// Muestra la celebración de subida de nivel.
Future<void> showLevelUpDialog(
  BuildContext context, {
  required int level,
  required List<HabitatItem> unlocked,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _LevelUpDialog(level: level, unlocked: unlocked),
  );
}

class _LevelUpDialog extends StatelessWidget {
  final int level;
  final List<HabitatItem> unlocked;

  const _LevelUpDialog({required this.level, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LumiAvatar(size: 88),
            const SizedBox(height: 12),
            Text(
              '🎉 ¡Lumi subió al Nivel $level!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (unlocked.isNotEmpty) ...[
              Text(
                'Has desbloqueado:',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final item in unlocked)
                    Chip(
                      avatar: Icon(item.icon, size: 18, color: item.color),
                      label: Text(item.name),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            Text(
              'Tu EcoHábitat sigue creciendo gracias a tus acciones.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/habitat');
                    },
                    child: const Text('Ver mi hábitat'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
