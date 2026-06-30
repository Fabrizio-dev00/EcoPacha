import '../models/recycling_record.dart';

/// Resumen agregado del impacto ambiental.
class ImpactSummary {
  final int recycledItems;
  final double co2SavedKg;
  final double waterSavedLiters;
  final double recoveredKg;

  const ImpactSummary({
    this.recycledItems = 0,
    this.co2SavedKg = 0,
    this.waterSavedLiters = 0,
    this.recoveredKg = 0,
  });

  static const ImpactSummary empty = ImpactSummary();
}

/// Calcula métricas de impacto a partir de los registros de reciclaje.
class ImpactService {
  ImpactService._();

  static ImpactSummary summarize(Iterable<RecyclingRecord> records) {
    var items = 0;
    double co2 = 0, water = 0, kg = 0;
    for (final record in records) {
      items++;
      co2 += record.result.co2Saved;
      water += record.result.waterSaved;
      kg += record.result.estimatedWeightKg;
    }
    return ImpactSummary(
      recycledItems: items,
      co2SavedKg: co2,
      waterSavedLiters: water,
      recoveredKg: kg,
    );
  }

  static ImpactSummary summarizeSince(
    Iterable<RecyclingRecord> records,
    DateTime since,
  ) {
    return summarize(records.where((r) => r.confirmedAt.isAfter(since)));
  }
}
