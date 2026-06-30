import 'package:flutter_test/flutter_test.dart';

import 'package:ecopacha/core/constants/impact_constants.dart';
import 'package:ecopacha/models/app_user.dart';
import 'package:ecopacha/models/recycling_result.dart';

void main() {
  group('Serialización de modelos', () {
    test('AppUser round-trip JSON conserva los datos', () {
      final user = AppUser(
        id: 'u1',
        name: 'Ana',
        email: 'ana@correo.com',
        ecoPoints: 120,
        level: 2,
        streakDays: 3,
        totalRecycledItems: 8,
        createdAt: DateTime.parse('2026-06-30T10:00:00.000'),
      );

      final restored = AppUser.fromJson(user.toJson());

      expect(restored.id, user.id);
      expect(restored.name, user.name);
      expect(restored.email, user.email);
      expect(restored.ecoPoints, 120);
      expect(restored.level, 2);
      expect(restored.streakDays, 3);
      expect(restored.totalRecycledItems, 8);
      expect(restored.createdAt, user.createdAt);
    });

    test('RecyclingResult round-trip conserva la categoría', () {
      const result = RecyclingResult(
        material: 'Botella PET',
        category: WasteCategory.plasticoPet,
        confidence: 0.92,
        binColor: 'Amarillo',
        instructions: 'Vacía, enjuaga y aplasta la botella.',
        tip: 'Quita la etiqueta si puedes.',
        ecoPointsAwarded: 20,
        co2Saved: 0.05,
        waterSaved: 2.0,
        estimatedWeightKg: 0.03,
      );

      final restored = RecyclingResult.fromJson(result.toJson());

      expect(restored.category, WasteCategory.plasticoPet);
      expect(restored.confidencePercent, 92);
      expect(restored.ecoPointsAwarded, 20);
    });
  });

  group('Curva de niveles', () {
    test('levelForPoints usa 100 puntos por nivel', () {
      expect(ImpactConstants.levelForPoints(0), 1);
      expect(ImpactConstants.levelForPoints(99), 1);
      expect(ImpactConstants.levelForPoints(100), 2);
      expect(ImpactConstants.levelForPoints(250), 3);
    });

    test('levelProgress devuelve el avance dentro del nivel', () {
      expect(ImpactConstants.levelProgress(0), 0.0);
      expect(ImpactConstants.levelProgress(50), 0.5);
    });
  });
}
