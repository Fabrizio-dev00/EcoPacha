import '../models/recycling_result.dart';

/// Contrato de clasificación de residuos.
///
/// El MVP usa [DemoClassifierService] (resultados simulados). En la Fase 8 se
/// añade AiClassifierService, que consume un backend/Cloud Function seguro
/// (la API key vive en el servidor, nunca en Flutter).
abstract class RecyclingClassifierService {
  /// Clasifica el residuo de la imagen ubicada en [imagePath].
  Future<RecyclingResult> classify(String imagePath);
}
