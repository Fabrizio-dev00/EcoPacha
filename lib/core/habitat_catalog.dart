import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import '../models/habitat_item.dart';

/// Catálogo centralizado de objetos del EcoHábitat, uno (o más) por nivel.
class HabitatCatalog {
  HabitatCatalog._();

  static const List<HabitatItem> items = [
    HabitatItem(
      id: 'maceta',
      name: 'Maceta básica',
      requiredLevel: 1,
      description: 'Una maceta pequeña donde empieza tu jardín.',
      meaning: 'Todo gran cambio empieza con un primer paso.',
      icon: Icons.yard,
      color: AppColors.binBrown,
      defaultX: 0.50,
      defaultY: 0.80,
    ),
    HabitatItem(
      id: 'flores',
      name: 'Flores',
      requiredLevel: 2,
      description: 'Flores que dan color a tu hábitat.',
      meaning: 'Las flores atraen polinizadores que cuidan la vida.',
      icon: Icons.local_florist,
      color: Color(0xFFEC6BA6),
      defaultX: 0.27,
      defaultY: 0.78,
    ),
    HabitatItem(
      id: 'estanque',
      name: 'Estanque',
      requiredLevel: 3,
      description: 'Un pequeño estanque de agua limpia.',
      meaning: 'Cuidar el agua es cuidar toda la vida.',
      icon: Icons.water,
      color: AppColors.binBlue,
      defaultX: 0.75,
      defaultY: 0.82,
    ),
    HabitatItem(
      id: 'arbusto',
      name: 'Arbusto',
      requiredLevel: 4,
      description: 'Un arbusto frondoso y sano.',
      meaning: 'La vegetación captura CO₂ y da refugio a la fauna.',
      icon: Icons.grass,
      color: AppColors.primary,
      defaultX: 0.15,
      defaultY: 0.68,
    ),
    HabitatItem(
      id: 'arbol',
      name: 'Árbol nativo',
      requiredLevel: 5,
      description: 'Un árbol nativo que sostiene el ecosistema.',
      meaning: 'Un árbol absorbe CO₂ y produce oxígeno por décadas.',
      icon: Icons.park,
      color: AppColors.primaryDark,
      defaultX: 0.83,
      defaultY: 0.52,
      action: HabitatItemAction.impact,
    ),
    HabitatItem(
      id: 'contenedor',
      name: 'Contenedor inteligente',
      requiredLevel: 6,
      description: 'Un contenedor para clasificar residuos.',
      meaning: 'Separar bien es el corazón del reciclaje.',
      icon: Icons.recycling,
      color: AppColors.turquoise,
      defaultX: 0.50,
      defaultY: 0.60,
      action: HabitatItemAction.scan,
    ),
    HabitatItem(
      id: 'huerto',
      name: 'Huerto',
      requiredLevel: 7,
      description: 'Un huerto que produce alimentos frescos.',
      meaning: 'Cultivar en casa reduce residuos y transporte.',
      icon: Icons.agriculture,
      color: AppColors.primary,
      defaultX: 0.30,
      defaultY: 0.88,
    ),
    HabitatItem(
      id: 'panel_solar',
      name: 'Panel solar',
      requiredLevel: 8,
      description: 'Energía limpia para tu hábitat.',
      meaning: 'La energía solar evita quemar combustibles fósiles.',
      icon: Icons.solar_power,
      color: AppColors.accentYellow,
      defaultX: 0.87,
      defaultY: 0.70,
    ),
    HabitatItem(
      id: 'mariposas',
      name: 'Mariposas',
      requiredLevel: 9,
      description: 'Mariposas y pequeños animales visitan tu hábitat.',
      meaning: 'La biodiversidad es señal de un entorno sano.',
      icon: Icons.emoji_nature,
      color: Color(0xFF9B6DD6),
      defaultX: 0.38,
      defaultY: 0.34,
    ),
    HabitatItem(
      id: 'insignia_guardian',
      name: 'Guardián de la Pacha',
      requiredLevel: 10,
      description: 'La insignia máxima: eres Guardián de la Pacha.',
      meaning: 'Tu constancia protege la Pachamama. ¡Gracias!',
      icon: Icons.workspace_premium,
      color: AppColors.accentYellow,
      defaultX: 0.50,
      defaultY: 0.14,
    ),
  ];

  static List<HabitatItem> unlockedFor(int level) =>
      items.where((i) => level >= i.requiredLevel).toList();

  static List<HabitatItem> unlockedAtLevel(int level) =>
      items.where((i) => i.requiredLevel == level).toList();

  static HabitatItem? nextLockedFor(int level) {
    for (final item in items) {
      if (level < item.requiredLevel) return item;
    }
    return null;
  }
}
