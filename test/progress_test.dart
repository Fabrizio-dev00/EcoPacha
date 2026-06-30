import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecopacha/models/challenge.dart';
import 'package:ecopacha/models/recycling_result.dart';
import 'package:ecopacha/providers/user_progress_provider.dart';
import 'package:ecopacha/services/local_auth_service.dart';
import 'package:ecopacha/services/storage_service.dart';

RecyclingResult _petResult() => const RecyclingResult(
      material: 'Botella PET',
      category: WasteCategory.plasticoPet,
      confidence: 0.9,
      binColor: 'Amarillo',
      instructions: '',
      tip: '',
      ecoPointsAwarded: 20,
      co2Saved: 0.05,
      waterSaved: 2.0,
      estimatedWeightKg: 0.03,
    );

Future<UserProgressProvider> _buildProgress() async {
  final storage = await StorageService.create();
  final auth = LocalAuthService(storage);
  final user =
      await auth.register(name: 'Ana', email: 'ana@mail.com', password: 'secret1');
  final progress = UserProgressProvider(storage, auth);
  await progress.loadForUser(user);
  return progress;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('loadForUser deja el progreso listo con racha 1', () async {
    final p = await _buildProgress();
    expect(p.isReady, true);
    expect(p.streakDays, 1);
    expect(p.dailyChallenge, isNotNull);
  });

  test('addRecyclingResult suma puntos, items e impacto', () async {
    final p = await _buildProgress();
    await p.addRecyclingResult(_petResult());
    expect(p.ecoPoints, 20);
    expect(p.totalRecycledItems, 1);
    expect(p.weeklyImpact.co2SavedKg, closeTo(0.05, 1e-9));
  });

  test('completar un reto otorga su recompensa', () async {
    final p = await _buildProgress();
    // "Escanea 5 reciclables" arranca en 2/5; 3 escaneos lo completan (+50).
    await p.addRecyclingResult(_petResult());
    await p.addRecyclingResult(_petResult());
    await p.addRecyclingResult(_petResult());
    final escanear =
        p.challenges.firstWhere((c) => c.type == ChallengeType.escanear);
    expect(escanear.isCompleted, true);
    expect(p.ecoPoints, 20 * 3 + 50);
  });

  test('el progreso persiste entre cargas', () async {
    final storage = await StorageService.create();
    final auth = LocalAuthService(storage);
    final user = await auth.register(
        name: 'Ana', email: 'ana@mail.com', password: 'secret1');

    final p1 = UserProgressProvider(storage, auth);
    await p1.loadForUser(user);
    await p1.addRecyclingResult(_petResult());

    final p2 = UserProgressProvider(storage, auth);
    await p2.loadForUser(user);
    expect(p2.ecoPoints, 20);
    expect(p2.totalRecycledItems, 1);
  });
}
