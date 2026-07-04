import 'package:flutter/material.dart';

/// Acción especial al tocar un objeto del hábitat.
enum HabitatItemAction { none, scan, impact }

/// Objeto del EcoHábitat que se desbloquea por nivel.
class HabitatItem {
  final String id;
  final String name;
  final int requiredLevel;
  final String description;
  final String meaning; // qué representa ambientalmente
  final IconData icon;
  final Color color;
  final double defaultX; // posición normalizada 0.0 - 1.0
  final double defaultY; // posición normalizada 0.0 - 1.0
  final HabitatItemAction action;

  const HabitatItem({
    required this.id,
    required this.name,
    required this.requiredLevel,
    required this.description,
    required this.meaning,
    required this.icon,
    required this.color,
    required this.defaultX,
    required this.defaultY,
    this.action = HabitatItemAction.none,
  });
}
