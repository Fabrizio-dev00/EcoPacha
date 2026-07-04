import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/habitat_item.dart';
import '../services/impact_service.dart';

/// Info de un objeto desbloqueado: nombre, descripción, significado y nivel.
Future<void> showHabitatItemInfo(BuildContext context, HabitatItem item) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => _Sheet(
      icon: item.icon,
      color: item.color,
      title: item.name,
      children: [
        _line('Descripción', item.description),
        _line('Qué representa', item.meaning),
        _line('Desbloqueado en', 'Nivel ${item.requiredLevel}'),
      ],
    ),
  );
}

/// Mensaje para un objeto bloqueado, con el progreso hacia el nivel requerido.
Future<void> showHabitatLocked(
  BuildContext context,
  HabitatItem item,
  double levelProgress,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => _Sheet(
      icon: Icons.lock_outline,
      color: AppColors.textSecondary,
      title: item.name,
      children: [
        Text(
          'Desbloquea este objeto al llegar al nivel ${item.requiredLevel}.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: levelProgress,
            minHeight: 10,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Progreso hacia el siguiente nivel: ${(levelProgress * 100).round()}%',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    ),
  );
}

/// Estadísticas de impacto (al tocar el árbol).
Future<void> showHabitatImpact(BuildContext context, ImpactSummary impact) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => _Sheet(
      icon: Icons.park,
      color: AppColors.primaryDark,
      title: 'Tu impacto ambiental',
      children: [
        _impactRow(Icons.recycling, 'Residuos reciclados',
            '${impact.recycledItems}'),
        _impactRow(Icons.cloud_outlined, 'CO₂ evitado',
            Formatters.co2(impact.co2SavedKg)),
        _impactRow(Icons.water_drop_outlined, 'Agua ahorrada',
            Formatters.liters(impact.waterSavedLiters)),
      ],
    ),
  );
}

Widget _line(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    ),
  );
}

Widget _impactRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    ),
  );
}

class _Sheet extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<Widget> children;

  const _Sheet({
    required this.icon,
    required this.color,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
