/// Categorías de residuos soportadas por EcoPacha.
enum WasteCategory {
  plasticoPet,
  papelCarton,
  vidrio,
  metal,
  organico,
  pilas,
  electronicos,
  noReciclable,
}

extension WasteCategoryX on WasteCategory {
  /// Nombre legible en español.
  String get label {
    switch (this) {
      case WasteCategory.plasticoPet:
        return 'Plástico PET';
      case WasteCategory.papelCarton:
        return 'Papel y cartón';
      case WasteCategory.vidrio:
        return 'Vidrio';
      case WasteCategory.metal:
        return 'Metal';
      case WasteCategory.organico:
        return 'Residuos orgánicos';
      case WasteCategory.pilas:
        return 'Pilas';
      case WasteCategory.electronicos:
        return 'Residuos electrónicos';
      case WasteCategory.noReciclable:
        return 'No reciclable';
    }
  }

  /// Color de contenedor recomendado (nombre en español).
  String get binColorName {
    switch (this) {
      case WasteCategory.plasticoPet:
      case WasteCategory.metal:
        return 'Amarillo';
      case WasteCategory.papelCarton:
        return 'Azul';
      case WasteCategory.vidrio:
        return 'Verde';
      case WasteCategory.organico:
        return 'Marrón';
      case WasteCategory.pilas:
      case WasteCategory.electronicos:
        return 'Rojo';
      case WasteCategory.noReciclable:
        return 'Gris';
    }
  }

  /// Clave estable para (de)serializar.
  String get key => name;

  /// Reconstruye la categoría desde su clave. Si no existe, devuelve [noReciclable].
  static WasteCategory fromKey(String key) {
    return WasteCategory.values.firstWhere(
      (c) => c.name == key,
      orElse: () => WasteCategory.noReciclable,
    );
  }
}

/// Resultado de la clasificación de un residuo.
class RecyclingResult {
  final String material;
  final WasteCategory category;
  final double confidence; // 0.0 - 1.0
  final String binColor;
  final String instructions;
  final String tip;
  final int ecoPointsAwarded;
  final double co2Saved; // kg de CO2 evitado
  final double waterSaved; // litros de agua ahorrados
  final double estimatedWeightKg;

  const RecyclingResult({
    required this.material,
    required this.category,
    required this.confidence,
    required this.binColor,
    required this.instructions,
    required this.tip,
    required this.ecoPointsAwarded,
    required this.co2Saved,
    required this.waterSaved,
    required this.estimatedWeightKg,
  });

  /// Confianza expresada en porcentaje (0-100).
  int get confidencePercent => (confidence * 100).round();

  RecyclingResult copyWith({
    String? material,
    WasteCategory? category,
    double? confidence,
    String? binColor,
    String? instructions,
    String? tip,
    int? ecoPointsAwarded,
    double? co2Saved,
    double? waterSaved,
    double? estimatedWeightKg,
  }) {
    return RecyclingResult(
      material: material ?? this.material,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      binColor: binColor ?? this.binColor,
      instructions: instructions ?? this.instructions,
      tip: tip ?? this.tip,
      ecoPointsAwarded: ecoPointsAwarded ?? this.ecoPointsAwarded,
      co2Saved: co2Saved ?? this.co2Saved,
      waterSaved: waterSaved ?? this.waterSaved,
      estimatedWeightKg: estimatedWeightKg ?? this.estimatedWeightKg,
    );
  }

  factory RecyclingResult.fromJson(Map<String, dynamic> json) {
    return RecyclingResult(
      material: json['material'] as String,
      category: WasteCategoryX.fromKey(json['category'] as String),
      confidence: (json['confidence'] as num).toDouble(),
      binColor: json['binColor'] as String,
      instructions: json['instructions'] as String,
      tip: json['tip'] as String,
      ecoPointsAwarded: (json['ecoPointsAwarded'] as num).toInt(),
      co2Saved: (json['co2Saved'] as num).toDouble(),
      waterSaved: (json['waterSaved'] as num).toDouble(),
      estimatedWeightKg: (json['estimatedWeightKg'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material': material,
      'category': category.key,
      'confidence': confidence,
      'binColor': binColor,
      'instructions': instructions,
      'tip': tip,
      'ecoPointsAwarded': ecoPointsAwarded,
      'co2Saved': co2Saved,
      'waterSaved': waterSaved,
      'estimatedWeightKg': estimatedWeightKg,
    };
  }
}
