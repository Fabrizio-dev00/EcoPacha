import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/challenge.dart';

/// Tarjeta de un reto con su progreso y recompensa.
class ChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const ChallengeCard({super.key, required this.challenge});

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
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: challenge.isCompleted
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    challenge.isCompleted
                        ? Icons.check_circle
                        : Icons.flag_outlined,
                    color: challenge.isCompleted
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        challenge.description,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+${challenge.rewardEcoPoints}',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: challenge.progressRatio,
                minHeight: 8,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: AlwaysStoppedAnimation<Color>(
                  challenge.isCompleted
                      ? AppColors.success
                      : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${challenge.progress} / ${challenge.target}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
