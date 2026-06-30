import 'dart:math';

import '../core/constants/impact_constants.dart';
import '../models/recycling_result.dart';
import 'recycling_classifier_service.dart';

/// Ejemplo de residuo usado para simular la clasificación.
class _Sample {
  final String material;
  final WasteCategory category;
  final String instructions;
  final String tip;

  const _Sample(this.material, this.category, this.instructions, this.tip);
}

/// Implementación simulada del clasificador.
/// Devuelve un resultado realista (sin IA real) tras un breve "análisis".
class DemoClassifierService implements RecyclingClassifierService {
  DemoClassifierService({
    Random? random,
    this.delay = const Duration(milliseconds: 1500),
  }) : _random = random ?? Random();

  final Random _random;
  final Duration delay;

  static const List<_Sample> _samples = [
    _Sample(
      'Botella de plástico PET',
      WasteCategory.plasticoPet,
      'Vacía, enjuaga y aplasta la botella antes de reciclarla.',
      'Quita la tapa y deposítala por separado.',
    ),
    _Sample(
      'Vaso de plástico',
      WasteCategory.plasticoPet,
      'Enjuágalo y deséchalo en el contenedor amarillo.',
      'Evita los plásticos de un solo uso.',
    ),
    _Sample(
      'Caja de cartón',
      WasteCategory.papelCarton,
      'Aplánala y mantenla seca y limpia.',
      'El cartón manchado de grasa no se recicla.',
    ),
    _Sample(
      'Hoja de papel',
      WasteCategory.papelCarton,
      'Deposítala en el contenedor azul.',
      'Aprovecha ambas caras antes de reciclar.',
    ),
    _Sample(
      'Botella de vidrio',
      WasteCategory.vidrio,
      'Enjuágala y retira tapas o corchos.',
      'No la mezcles con vidrios de ventana o espejos.',
    ),
    _Sample(
      'Lata de aluminio',
      WasteCategory.metal,
      'Enjuágala y apláshala para ahorrar espacio.',
      'El aluminio se recicla infinitas veces.',
    ),
    _Sample(
      'Restos de comida',
      WasteCategory.organico,
      'Sepáralos para compostaje.',
      'Evita carnes y lácteos en el compost casero.',
    ),
    _Sample(
      'Pila usada',
      WasteCategory.pilas,
      'No la mezcles con la basura común; llévala a un punto de acopio.',
      'Una sola pila puede contaminar miles de litros de agua.',
    ),
    _Sample(
      'Cargador o cable',
      WasteCategory.electronicos,
      'Llévalo a un punto de acopio de electrónicos (RAEE).',
      'No lo arrojes a la basura común.',
    ),
    _Sample(
      'Envoltorio metalizado',
      WasteCategory.noReciclable,
      'Deposítalo en el contenedor de resto.',
      'Reduce el consumo de empaques de un solo uso.',
    ),
  ];

  @override
  Future<RecyclingResult> classify(String imagePath) async {
    if (delay > Duration.zero) await Future.delayed(delay);

    final sample = _samples[_random.nextInt(_samples.length)];
    final reference = ImpactConstants.byCategory[sample.category]!;
    final confidence = double.parse(
      (0.78 + _random.nextDouble() * 0.19).toStringAsFixed(2),
    );

    return RecyclingResult(
      material: sample.material,
      category: sample.category,
      confidence: confidence,
      binColor: sample.category.binColorName,
      instructions: sample.instructions,
      tip: sample.tip,
      ecoPointsAwarded: reference.ecoPoints,
      co2Saved: reference.co2SavedKg,
      waterSaved: reference.waterSavedLiters,
      estimatedWeightKg: reference.weightKg,
    );
  }
}
