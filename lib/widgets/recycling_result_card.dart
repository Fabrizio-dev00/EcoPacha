import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/recycling_result.dart';

/// Tarjeta con el detalle de la clasificación de un residuo.
class RecyclingResultCard extends StatelessWidget {
  final RecyclingResult result;

  const RecyclingResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.material,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.category.label,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                _ConfidenceBadge(percent: result.confidencePercent),
              ],
            ),
            const SizedBox(height: 16),
            _BinRow(category: result.category, binName: result.binColor),
            const Divider(height: 28),
            _InfoBlock(
              icon: Icons.task_alt,
              title: 'Cómo reciclarlo',
              text: result.instructions,
            ),
            const SizedBox(height: 12),
            _InfoBlock(
              icon: Icons.lightbulb_outline,
              title: 'Consejo',
              text: result.tip,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _Pill(
                  icon: Icons.eco,
                  label: '+${result.ecoPointsAwarded} EcoPuntos',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _Pill(
                  icon: Icons.cloud_outlined,
                  label: '${Formatters.co2(result.co2Saved)} CO₂',
                  color: AppColors.turquoise,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Impacto estimado: recuperas ~${Formatters.weightKg(result.estimatedWeightKg)} '
              'y ahorras ${Formatters.liters(result.waterSaved)} de agua.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

Color binColorFor(WasteCategory category) {
  switch (category) {
    case WasteCategory.plasticoPet:
    case WasteCategory.metal:
      return AppColors.binYellow;
    case WasteCategory.papelCarton:
      return AppColors.binBlue;
    case WasteCategory.vidrio:
      return AppColors.binGreen;
    case WasteCategory.organico:
      return AppColors.binBrown;
    case WasteCategory.pilas:
    case WasteCategory.electronicos:
      return AppColors.binRed;
    case WasteCategory.noReciclable:
      return AppColors.binGray;
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final int percent;

  const _ConfidenceBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$percent% seguro',
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BinRow extends StatelessWidget {
  final WasteCategory category;
  final String binName;

  const _BinRow({required this.category, required this.binName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: binColorFor(category),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 10),
        Text('Contenedor: ', style: theme.textTheme.bodyMedium),
        Text(
          binName,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
