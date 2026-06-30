import '../models/collection_point.dart';
import '../models/leaderboard_user.dart';

/// Contrato de acceso a datos remotos (ranking, puntos de acopio, etc.).
///
/// El MVP usa [MockFirestoreService]. En la Fase 8 se implementa con Cloud
/// Firestore sin cambiar la UI ni los providers.
abstract class FirestoreService {
  Future<List<LeaderboardUser>> fetchWeeklyLeaderboard();
  Future<List<CollectionPoint>> fetchCollectionPoints();
}
