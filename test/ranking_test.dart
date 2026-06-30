import 'package:flutter_test/flutter_test.dart';

import 'package:ecopacha/mock/mock_collection_points.dart';
import 'package:ecopacha/models/recycling_result.dart';
import 'package:ecopacha/providers/leaderboard_provider.dart';
import 'package:ecopacha/services/mock_firestore_service.dart';

void main() {
  test('LeaderboardProvider carga el ranking ordenado', () async {
    final provider =
        LeaderboardProvider(MockFirestoreService(delay: Duration.zero));
    await provider.load();

    expect(provider.status, LoadStatus.success);
    expect(provider.users, isNotEmpty);
    expect(provider.users.first.position, 1);
  });

  test('los puntos de acopio se filtran por material', () {
    final aceptanPilas = mockCollectionPoints
        .where((p) => p.accepts(WasteCategory.pilas))
        .toList();
    expect(aceptanPilas, isNotEmpty);

    for (final point in aceptanPilas) {
      expect(point.acceptedMaterials, contains(WasteCategory.pilas));
    }
  });
}
