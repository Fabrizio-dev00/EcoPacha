import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/formatters.dart';
import '../services/impact_service.dart';

/// Tarjeta con el resumen de impacto ambiental.
class ImpactCard extends StatelessWidget {
  final ImpactSummary impact;

  const ImpactCard({super.key, required this.impact});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        child: Row(
          children: [
            _Metric(
              icon: Icons.recycling,
              color: AppColors.primary,
              value: '${impact.recycledItems}',
              label: 'Reciclados',
            ),
            _Divider(),
            _Metric(
              icon: Icons.cloud_outlined,
              color: AppColors.turquoise,
              value: Formatters.co2(impact.co2SavedKg),
              label: 'CO₂ evitado',
            ),
            _Divider(),
            _Metric(
              icon: Icons.water_drop_outlined,
              color: AppColors.binBlue,
              value: Formatters.liters(impact.waterSavedLiters),
              label: 'Agua ahorrada',
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _Metric({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 1,
      color: AppColors.surfaceMuted,
    );
  }
}
