import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/formatters.dart';

/// Tarjeta destacada con EcoPuntos, nivel y racha del usuario.
class EcoPointsCard extends StatelessWidget {
  final int ecoPoints;
  final int level;
  final int streakDays;
  final double levelProgress;
  final int pointsToNextLevel;

  const EcoPointsCard({
    super.key,
    required this.ecoPoints,
    required this.level,
    required this.streakDays,
    required this.levelProgress,
    required this.pointsToNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.turquoise],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
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
                    const Text(
                      'Tus ${AppStrings.ecoPoints}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.points(ecoPoints),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _Chip(icon: Icons.workspace_premium, label: 'Nivel $level'),
                  const SizedBox(height: 8),
                  _Chip(
                    icon: Icons.local_fire_department,
                    label: '$streakDays día${streakDays == 1 ? '' : 's'}',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: levelProgress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accentYellow),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Faltan $pointsToNextLevel ${AppStrings.ecoPoints} para el nivel ${level + 1}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
