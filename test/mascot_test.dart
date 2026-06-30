import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecopacha/models/mascot_progress.dart';
import 'package:ecopacha/providers/mascot_provider.dart';
import 'package:ecopacha/providers/user_progress_provider.dart';
import 'package:ecopacha/services/local_auth_service.dart';
import 'package:ecopacha/services/storage_service.dart';

void main() {
  test('stageForLevel evoluciona el hábitat', () {
    expect(MascotProvider.stageForLevel(1), HabitatStage.maceta);
    expect(MascotProvider.stageForLevel(2), HabitatStage.maceta);
    expect(MascotProvider.stageForLevel(3), HabitatStage.jardin);
    expect(MascotProvider.stageForLevel(5), HabitatStage.arbol);
  });

  test('unlockedItems crece con el nivel', () {
    expect(MascotProvider.unlockedItems(1), ['Maceta']);
    expect(MascotProvider.unlockedItems(5), contains('Árbol'));
  });

  test('fromUserProgress refleja el progreso del usuario', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.create();
    final auth = LocalAuthService(storage);
    final user = await auth.register(
        name: 'Ana', email: 'ana@mail.com', password: 'secret1');
    final progress = UserProgressProvider(storage, auth);
    await progress.loadForUser(user);

    final mascot = MascotProvider.fromUserProgress(progress);
    expect(mascot.level, 1);
    expect(mascot.currentHabitatStage, HabitatStage.maceta);
    expect(mascot.streakDays, 1);
  });
}
