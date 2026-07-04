/// Lógica centralizada de niveles y XP (fuente única para toda la app).
/// El "XP" es el mismo valor de EcoPuntos acumulados del usuario.
class LevelService {
  LevelService._();

  /// XP acumulado necesario para el INICIO de cada nivel.
  /// Índice 0 = nivel 1, índice 9 = nivel 10.
  static const List<int> xpThresholds = [
    0, 100, 250, 450, 700, 1000, 1400, 1900, 2500, 3200,
  ];

  static int get maxLevel => xpThresholds.length; // 10

  /// Nivel (1..maxLevel) para un XP dado.
  static int levelForXp(int xp) {
    var level = 1;
    for (var i = 0; i < xpThresholds.length; i++) {
      if (xp >= xpThresholds[i]) {
        level = i + 1;
      } else {
        break;
      }
    }
    return level;
  }

  /// XP acumulado al inicio de [level].
  static int xpForLevel(int level) {
    final l = level.clamp(1, maxLevel);
    return xpThresholds[l - 1];
  }

  /// XP que falta para el siguiente nivel (0 si ya es el máximo).
  static int xpToNextLevel(int xp) {
    final level = levelForXp(xp);
    if (level >= maxLevel) return 0;
    return xpForLevel(level + 1) - xp;
  }

  /// Progreso (0.0 - 1.0) dentro del nivel actual.
  static double progressInLevel(int xp) {
    final level = levelForXp(xp);
    if (level >= maxLevel) return 1.0;
    final start = xpForLevel(level);
    final end = xpForLevel(level + 1);
    if (end == start) return 1.0;
    return ((xp - start) / (end - start)).clamp(0.0, 1.0);
  }
}
