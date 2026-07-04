import 'package:flutter/material.dart';

/// Insignia / logro del usuario.
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });
}

/// Calcula las insignias a partir del progreso del usuario (fuente única).
class Achievements {
  Achievements._();

  static List<Achievement> forProgress({
    required int totalRecycledItems,
    required int streakDays,
    required int level,
    required int ecoPoints,
  }) {
    return [
      Achievement(
        id: 'first',
        title: 'Primer paso',
        description: 'Recicla tu primer residuo',
        icon: Icons.recycling,
        unlocked: totalRecycledItems >= 1,
      ),
      Achievement(
        id: 'five',
        title: 'En marcha',
        description: 'Recicla 5 residuos',
        icon: Icons.eco,
        unlocked: totalRecycledItems >= 5,
      ),
      Achievement(
        id: 'ten',
        title: 'Reciclador',
        description: 'Recicla 10 residuos',
        icon: Icons.workspace_premium,
        unlocked: totalRecycledItems >= 10,
      ),
      Achievement(
        id: 'streak3',
        title: 'Constante',
        description: 'Racha de 3 días activo',
        icon: Icons.local_fire_department,
        unlocked: streakDays >= 3,
      ),
      Achievement(
        id: 'level3',
        title: 'Nivel 3',
        description: 'Alcanza el nivel 3',
        icon: Icons.military_tech,
        unlocked: level >= 3,
      ),
      Achievement(
        id: 'points100',
        title: 'Centenario',
        description: 'Gana 100 EcoPuntos',
        icon: Icons.stars,
        unlocked: ecoPoints >= 100,
      ),
    ];
  }
}
