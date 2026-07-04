import 'package:flutter_test/flutter_test.dart';

import 'package:ecopacha/core/level_service.dart';

void main() {
  test('levelForXp sigue la curva de XP', () {
    expect(LevelService.levelForXp(0), 1);
    expect(LevelService.levelForXp(99), 1);
    expect(LevelService.levelForXp(100), 2);
    expect(LevelService.levelForXp(250), 3);
    expect(LevelService.levelForXp(449), 3);
    expect(LevelService.levelForXp(450), 4);
    expect(LevelService.levelForXp(3200), 10);
    expect(LevelService.levelForXp(999999), 10);
  });

  test('xpToNextLevel calcula lo que falta', () {
    expect(LevelService.xpToNextLevel(0), 100);
    expect(LevelService.xpToNextLevel(100), 150);
    expect(LevelService.xpToNextLevel(3200), 0);
  });

  test('progressInLevel entre 0 y 1', () {
    expect(LevelService.progressInLevel(0), 0.0);
    expect(LevelService.progressInLevel(50), 0.5);
    expect(LevelService.progressInLevel(175), closeTo(0.5, 1e-9));
    expect(LevelService.progressInLevel(3200), 1.0);
  });
}
