/// Tipo de reto, usado para saber qué acción incrementa su progreso.
enum ChallengeType { escanear, reciclarRacha, aprender, llevarAcopio }

extension ChallengeTypeX on ChallengeType {
  String get key => name;

  static ChallengeType fromKey(String key) {
    return ChallengeType.values.firstWhere(
      (t) => t.name == key,
      orElse: () => ChallengeType.escanear,
    );
  }
}

/// Reto de gamificación.
class Challenge {
  final String id;
  final String title;
  final String description;
  final int target;
  final int progress;
  final int rewardEcoPoints;
  final bool isCompleted;
  final ChallengeType type;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    this.progress = 0,
    required this.rewardEcoPoints,
    this.isCompleted = false,
    required this.type,
  });

  /// Progreso normalizado (0.0 - 1.0).
  double get progressRatio =>
      target == 0 ? 0 : (progress / target).clamp(0.0, 1.0);

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    int? target,
    int? progress,
    int? rewardEcoPoints,
    bool? isCompleted,
    ChallengeType? type,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      rewardEcoPoints: rewardEcoPoints ?? this.rewardEcoPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
    );
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      target: (json['target'] as num).toInt(),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      rewardEcoPoints: (json['rewardEcoPoints'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      type: ChallengeTypeX.fromKey(json['type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target': target,
      'progress': progress,
      'rewardEcoPoints': rewardEcoPoints,
      'isCompleted': isCompleted,
      'type': type.key,
    };
  }
}
