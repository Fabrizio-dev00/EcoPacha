import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/constants/impact_constants.dart';
import '../models/recycling_result.dart';
import 'recycling_classifier_service.dart';

/// Clasificador con IA real: envía la imagen al proxy seguro (que llama a Gemini)
/// y construye el [RecyclingResult]. Los EcoPuntos e impacto salen de las
/// constantes de la app (economía controlada); la IA aporta el reconocimiento y
/// el texto educativo. Ante cualquier fallo, usa el [fallback] (demo).
class AiClassifierService implements RecyclingClassifierService {
  AiClassifierService({
    required this.endpoint,
    this.fallback,
    this.timeout = const Duration(seconds: 20),
  });

  final String endpoint;
  final RecyclingClassifierService? fallback;
  final Duration timeout;

  @override
  Future<RecyclingResult> classify(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'imageBase64': base64Encode(bytes),
              'mimeType': _mimeFor(imagePath),
            }),
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Proxy respondió ${response.statusCode}');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['error'] != null) throw Exception(json['error']);
      return _toResult(json);
    } catch (_) {
      if (fallback != null) return fallback!.classify(imagePath);
      rethrow;
    }
  }

  RecyclingResult _toResult(Map<String, dynamic> json) {
    final category =
        WasteCategoryX.fromKey(json['category'] as String? ?? 'noReciclable');
    final reference = ImpactConstants.byCategory[category]!;
    final confidence =
        ((json['confidence'] as num?)?.toDouble() ?? 0.8).clamp(0.0, 1.0);

    String orDefault(String? value, String fallbackText) =>
        (value != null && value.trim().isNotEmpty) ? value.trim() : fallbackText;

    return RecyclingResult(
      material: orDefault(json['material'] as String?, category.label),
      category: category,
      confidence: confidence,
      binColor: category.binColorName,
      instructions: orDefault(
        json['instructions'] as String?,
        'Sepáralo según su tipo y deposítalo en el contenedor correcto.',
      ),
      tip: orDefault(json['tip'] as String?, 'Reduce, reutiliza y recicla.'),
      ecoPointsAwarded: reference.ecoPoints,
      co2Saved: reference.co2SavedKg,
      waterSaved: reference.waterSavedLiters,
      estimatedWeightKg: reference.weightKg,
    );
  }

  String _mimeFor(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
