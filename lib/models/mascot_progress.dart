/// Etapas visuales del EcoHábitat de Lumi.
enum HabitatStage { maceta, jardin, arbol }

extension HabitatStageX on HabitatStage {
  String get label {
    switch (this) {
      case HabitatStage.maceta:
        return 'Maceta pequeña';
      case HabitatStage.jardin:
        return 'Jardín';
      case HabitatStage.arbol:
        return 'Árbol y huerto';
    }
  }

  String get key => name;

  static HabitatStage fromKey(String key) {
    return HabitatStage.values.firstWhere(
      (s) => s.name == key,
      orElse: () => HabitatStage.maceta,
    );
  }
}

/// Progreso de la mascota Lumi y su EcoHábitat.
class MascotProgress {
  final int level;
  final double energy; // 0.0 - 1.0
  final int streakDays;
  final List<String> unlockedItems;
  final HabitatStage currentHabitatStage;
  final double nextUpgradeProgress; // 0.0 - 1.0

  const MascotProgress({
    this.level = 1,
    this.energy = 0.0,
    this.streakDays = 0,
    this.unlockedItems = const [],
    this.currentHabitatStage = HabitatStage.maceta,
    this.nextUpgradeProgress = 0.0,
  });

  MascotProgress copyWith({
    int? level,
    double? energy,
    int? streakDays,
    List<String>? unlockedItems,
    HabitatStage? currentHabitatStage,
    double? nextUpgradeProgress,
  }) {
    return MascotProgress(
      level: level ?? this.level,
      energy: energy ?? this.energy,
      streakDays: streakDays ?? this.streakDays,
      unlockedItems: unlockedItems ?? this.unlockedItems,
      currentHabitatStage: currentHabitatStage ?? this.currentHabitatStage,
      nextUpgradeProgress: nextUpgradeProgress ?? this.nextUpgradeProgress,
    );
  }

  factory MascotProgress.fromJson(Map<String, dynamic> json) {
    return MascotProgress(
      level: (json['level'] as num?)?.toInt() ?? 1,
      energy: (json['energy'] as num?)?.toDouble() ?? 0.0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      unlockedItems:
          (json['unlockedItems'] as List<dynamic>?)?.cast<String>() ?? const [],
      currentHabitatStage:
          HabitatStageX.fromKey(json['currentHabitatStage'] as String? ?? ''),
      nextUpgradeProgress:
          (json['nextUpgradeProgress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'energy': energy,
      'streakDays': streakDays,
      'unlockedItems': unlockedItems,
      'currentHabitatStage': currentHabitatStage.key,
      'nextUpgradeProgress': nextUpgradeProgress,
    };
  }
}
