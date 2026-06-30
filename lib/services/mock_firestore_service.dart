import '../mock/mock_collection_points.dart';
import '../mock/mock_leaderboard.dart';
import '../models/collection_point.dart';
import '../models/leaderboard_user.dart';
import 'firestore_service.dart';

/// Implementación simulada de [FirestoreService] con datos mock.
/// Simula latencia de red para parecerse al comportamiento real.
class MockFirestoreService implements FirestoreService {
  MockFirestoreService({this.delay = const Duration(milliseconds: 400)});

  final Duration delay;

  @override
  Future<List<LeaderboardUser>> fetchWeeklyLeaderboard() async {
    if (delay > Duration.zero) await Future.delayed(delay);
    return List<LeaderboardUser>.from(mockLeaderboard);
  }

  @override
  Future<List<CollectionPoint>> fetchCollectionPoints() async {
    if (delay > Duration.zero) await Future.delayed(delay);
    return List<CollectionPoint>.from(mockCollectionPoints);
  }
}
