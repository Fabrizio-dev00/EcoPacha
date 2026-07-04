import '../../models/recycling_result.dart';
import '../level_service.dart';

/// Valores de referencia (simulados) del impacto ambiental por categoría.
/// Centralizados para ajustarlos fácilmente. NO son cifras oficiales.
class ImpactReference {
  final int ecoPoints;
  final double co2SavedKg; // kg de CO2 evitado por acción
  final double waterSavedLiters; // litros de agua ahorrados por acción
  final double weightKg; // peso promedio recuperado por item

  const ImpactReference({
    required this.ecoPoints,
    required this.co2SavedKg,
    required this.waterSavedLiters,
    required this.weightKg,
  });
}

/// Constantes de impacto y de la curva de niveles.
class ImpactConstants {
  ImpactConstants._();

  /// Referencia por categoría de residuo.
  static const Map<WasteCategory, ImpactReference> byCategory = {
    WasteCategory.plasticoPet: ImpactReference(
        ecoPoints: 20, co2SavedKg: 0.05, waterSavedLiters: 2.0, weightKg: 0.03),
    WasteCategory.papelCarton: ImpactReference(
        ecoPoints: 15, co2SavedKg: 0.04, waterSavedLiters: 3.5, weightKg: 0.08),
    WasteCategory.vidrio: ImpactReference(
        ecoPoints: 18, co2SavedKg: 0.06, waterSavedLiters: 1.0, weightKg: 0.20),
    WasteCategory.metal: ImpactReference(
        ecoPoints: 22, co2SavedKg: 0.10, waterSavedLiters: 4.0, weightKg: 0.02),
    WasteCategory.organico: ImpactReference(
        ecoPoints: 10, co2SavedKg: 0.02, waterSavedLiters: 0.5, weightKg: 0.15),
    WasteCategory.pilas: ImpactReference(
        ecoPoints: 30, co2SavedKg: 0.01, waterSavedLiters: 8.0, weightKg: 0.02),
    WasteCategory.electronicos: ImpactReference(
        ecoPoints: 35, co2SavedKg: 0.15, waterSavedLiters: 10.0, weightKg: 0.30),
    WasteCategory.noReciclable: ImpactReference(
        ecoPoints: 5, co2SavedKg: 0.0, waterSavedLiters: 0.0, weightKg: 0.0),
  };

  /// Nivel y progreso delegados a [LevelService] (curva de XP única).
  static int levelForPoints(int points) => LevelService.levelForXp(points);

  static double levelProgress(int points) =>
      LevelService.progressInLevel(points);
}
