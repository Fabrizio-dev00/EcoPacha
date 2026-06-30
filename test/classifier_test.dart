import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:ecopacha/models/recycling_result.dart';
import 'package:ecopacha/services/demo_classifier_service.dart';

void main() {
  test('DemoClassifierService devuelve un resultado coherente', () async {
    final demo = DemoClassifierService(random: Random(7), delay: Duration.zero);
    final result = await demo.classify('cualquier/ruta.jpg');

    expect(result.confidence, inInclusiveRange(0.78, 0.97));
    expect(result.ecoPointsAwarded, greaterThan(0));
    expect(result.binColor, result.category.binColorName);
    expect(result.material, isNotEmpty);
    expect(result.instructions, isNotEmpty);
  });

  test('todas las clasificaciones tienen impacto no negativo', () async {
    final demo = DemoClassifierService(random: Random(1), delay: Duration.zero);
    for (var i = 0; i < 30; i++) {
      final result = await demo.classify('x.jpg');
      expect(result.estimatedWeightKg, greaterThanOrEqualTo(0));
      expect(result.co2Saved, greaterThanOrEqualTo(0));
      expect(result.waterSaved, greaterThanOrEqualTo(0));
    }
  });
}
