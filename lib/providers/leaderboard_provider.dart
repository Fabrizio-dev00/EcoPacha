import 'package:flutter/foundation.dart';

import '../models/leaderboard_user.dart';
import '../services/firestore_service.dart';

enum LoadStatus { idle, loading, success, error }

/// Carga el ranking semanal desde [FirestoreService].
class LeaderboardProvider extends ChangeNotifier {
  LeaderboardProvider(this._firestore);

  final FirestoreService _firestore;

  LoadStatus _status = LoadStatus.idle;
  List<LeaderboardUser> _users = [];
  String? _error;

  LoadStatus get status => _status;
  List<LeaderboardUser> get users => List.unmodifiable(_users);
  String? get error => _error;

  Future<void> load() async {
    _status = LoadStatus.loading;
    notifyListeners();
    try {
      _users = await _firestore.fetchWeeklyLeaderboard();
      _status = LoadStatus.success;
    } catch (_) {
      _error = 'No se pudo cargar el ranking. Inténtalo de nuevo.';
      _status = LoadStatus.error;
    }
    notifyListeners();
  }
}
