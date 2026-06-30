import '../models/mascot_progress.dart';
import 'user_progress_provider.dart';

/// Deriva el progreso de la mascota Lumi a partir del progreso del usuario.
/// No guarda estado propio: Lumi refleja lo que ya vive en [UserProgressProvider]
/// (fuente única), evitando que los números se desincronicen.
class MascotProvider {
  const MascotProvider._();

  static MascotProgress fromUserProgress(UserProgressProvider progress) {
    final level = progress.level;
    final energy = progress.levelProgress; // avance 0..1 hacia el siguiente nivel
    return MascotProgress(
      level: level,
      energy: energy,
      streakDays: progress.streakDays,
      unlockedItems: unlockedItems(level),
      currentHabitatStage: stageForLevel(level),
      nextUpgradeProgress: energy,
    );
  }

  static HabitatStage stageForLevel(int level) {
    if (level >= 5) return HabitatStage.arbol;
    if (level >= 3) return HabitatStage.jardin;
    return HabitatStage.maceta;
  }

  static List<String> unlockedItems(int level) {
    final items = <String>['Maceta'];
    if (level >= 2) items.add('Regadera');
    if (level >= 3) items.add('Jardín');
    if (level >= 4) items.add('Mariposas');
    if (level >= 5) items.add('Árbol');
    if (level >= 6) items.add('Panel solar');
    return items;
  }
}
