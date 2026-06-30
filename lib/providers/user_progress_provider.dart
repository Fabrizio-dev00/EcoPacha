import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';
import '../core/constants/impact_constants.dart';
import '../mock/mock_challenges.dart';
import '../models/app_user.dart';
import '../models/challenge.dart';
import '../models/recycling_record.dart';
import '../models/recycling_result.dart';
import '../services/auth_service.dart';
import '../services/impact_service.dart';
import '../services/storage_service.dart';

/// Fuente ÚNICA de verdad del progreso del usuario: EcoPuntos, nivel, racha,
/// impacto, retos e historial de reciclaje. Las pantallas leen de aquí; no
/// recalculan nada por su cuenta.
class UserProgressProvider extends ChangeNotifier {
  UserProgressProvider(this._storage, this._authService);

  final StorageService _storage;
  final AuthService _authService;

  String? _userId;
  int _ecoPoints = 0;
  int _streakDays = 0;
  DateTime? _lastActiveDay;
  List<RecyclingRecord> _records = [];
  List<Challenge> _challenges = [];

  // ---------------- Getters ----------------
  bool get isReady => _userId != null;
  int get ecoPoints => _ecoPoints;
  int get level => ImpactConstants.levelForPoints(_ecoPoints);
  double get levelProgress => ImpactConstants.levelProgress(_ecoPoints);
  int get pointsToNextLevel =>
      ImpactConstants.pointsPerLevel -
      ImpactConstants.pointsIntoCurrentLevel(_ecoPoints);
  int get streakDays => _streakDays;
  int get totalRecycledItems => _records.length;
  List<Challenge> get challenges => List.unmodifiable(_challenges);
  List<RecyclingRecord> get records => List.unmodifiable(_records);

  ImpactSummary get totalImpact => ImpactService.summarize(_records);

  ImpactSummary get weeklyImpact => ImpactService.summarizeSince(
        _records,
        DateTime.now().subtract(const Duration(days: 7)),
      );

  /// Primer reto sin completar (o el primero si todos están completos).
  Challenge? get dailyChallenge {
    if (_challenges.isEmpty) return null;
    return _challenges.firstWhere(
      (c) => !c.isCompleted,
      orElse: () => _challenges.first,
    );
  }

  String get lumiMessage {
    if (_streakDays >= 3) {
      return '¡Racha de $_streakDays días! Lumi está orgullosa de ti. 🌟';
    }
    if (totalRecycledItems == 0) return AppStrings.lumiWelcome;
    return '¡Buen trabajo! Sigue reciclando para que Lumi gane más energía. 🐦';
  }

  // ---------------- Sincronización con la sesión ----------------
  /// Conecta el progreso con el usuario autenticado (usado por el ProxyProvider).
  void syncWithAuth(AppUser? user, bool isAuthenticated) {
    if (isAuthenticated && user != null) {
      if (user.id != _userId) {
        loadForUser(user);
      }
    } else if (_userId != null) {
      _clear();
    }
  }

  Future<void> loadForUser(AppUser user) async {
    _userId = user.id;
    final json = _storage.getJson(_progressKey(user.id));
    if (json != null) {
      _ecoPoints = (json['ecoPoints'] as num?)?.toInt() ?? 0;
      _streakDays = (json['streakDays'] as num?)?.toInt() ?? 0;
      final lastRaw = json['lastActiveDay'] as String?;
      _lastActiveDay = lastRaw != null ? DateTime.tryParse(lastRaw) : null;
      _records = ((json['records'] as List?) ?? [])
          .map((e) => RecyclingRecord.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      _challenges = ((json['challenges'] as List?) ?? [])
          .map((e) => Challenge.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      if (_challenges.isEmpty) _challenges = _seedChallenges();
    } else {
      _ecoPoints = user.ecoPoints;
      _streakDays = user.streakDays;
      _records = [];
      _challenges = _seedChallenges();
    }
    _applyDailyActivity();
    await _persist();
    notifyListeners();
  }

  // ---------------- Acciones ----------------
  /// Registra un reciclaje confirmado y actualiza puntos, impacto, retos y racha.
  Future<void> addRecyclingResult(RecyclingResult result,
      {String? imageUrl}) async {
    final record = RecyclingRecord(
      id: 'rec_${DateTime.now().microsecondsSinceEpoch}',
      userId: _userId ?? 'unknown',
      imageUrl: imageUrl,
      result: result,
      confirmedAt: DateTime.now(),
    );
    _records = [record, ..._records];
    _ecoPoints += result.ecoPointsAwarded;
    _advanceChallenges(ChallengeType.escanear);
    _applyDailyActivity();
    await _persistAndSync();
    notifyListeners();
  }

  /// Avanza un reto por su tipo (p. ej. aprender consejos con EcoBot).
  Future<void> advanceChallenge(ChallengeType type, {int amount = 1}) async {
    _advanceChallenges(type, amount: amount);
    await _persistAndSync();
    notifyListeners();
  }

  // ---------------- Lógica interna ----------------
  List<Challenge> _seedChallenges() =>
      mockDailyChallenges.map((c) => c.copyWith()).toList();

  void _advanceChallenges(ChallengeType type, {int amount = 1}) {
    _challenges = _challenges.map((challenge) {
      if (challenge.type != type || challenge.isCompleted) return challenge;
      final newProgress =
          (challenge.progress + amount).clamp(0, challenge.target);
      final completed = newProgress >= challenge.target;
      if (completed) _ecoPoints += challenge.rewardEcoPoints;
      return challenge.copyWith(progress: newProgress, isCompleted: completed);
    }).toList();
  }

  /// Sistema de racha: nunca castiga, solo suma o reinicia a 1.
  void _applyDailyActivity() {
    final today = _dateOnly(DateTime.now());
    if (_lastActiveDay == null) {
      _streakDays = 1;
    } else {
      final diff = today.difference(_dateOnly(_lastActiveDay!)).inDays;
      if (diff == 1) {
        _streakDays += 1;
      } else if (diff > 1) {
        _streakDays = 1;
      }
    }
    _lastActiveDay = today;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  String _progressKey(String userId) => 'progress_$userId';

  Future<void> _persist() async {
    if (_userId == null) return;
    await _storage.setJson(_progressKey(_userId!), {
      'ecoPoints': _ecoPoints,
      'streakDays': _streakDays,
      'lastActiveDay': _lastActiveDay?.toIso8601String(),
      'records': _records.map((r) => r.toJson()).toList(),
      'challenges': _challenges.map((c) => c.toJson()).toList(),
    });
  }

  /// Persiste y replica los totales en el AppUser (para perfil y futuro Firestore).
  Future<void> _persistAndSync() async {
    await _persist();
    final user = _authService.currentUser;
    if (user != null) {
      await _authService.updateUser(user.copyWith(
        ecoPoints: _ecoPoints,
        level: level,
        streakDays: _streakDays,
        totalRecycledItems: totalRecycledItems,
      ));
    }
  }

  void _clear() {
    _userId = null;
    _ecoPoints = 0;
    _streakDays = 0;
    _lastActiveDay = null;
    _records = [];
    _challenges = [];
    notifyListeners();
  }
}
