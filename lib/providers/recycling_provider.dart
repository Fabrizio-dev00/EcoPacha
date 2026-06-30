import 'package:flutter/foundation.dart';

import '../models/recycling_result.dart';
import '../services/recycling_classifier_service.dart';

enum ScanStatus { idle, analyzing, success, error }

/// Maneja el flujo de escaneo: imagen seleccionada, análisis y resultado.
class RecyclingProvider extends ChangeNotifier {
  RecyclingProvider(this._classifier);

  final RecyclingClassifierService _classifier;

  ScanStatus _status = ScanStatus.idle;
  String? _imagePath;
  RecyclingResult? _result;
  String? _error;
  bool _confirmed = false;

  ScanStatus get status => _status;
  String? get imagePath => _imagePath;
  RecyclingResult? get result => _result;
  String? get error => _error;
  bool get confirmed => _confirmed;
  bool get isAnalyzing => _status == ScanStatus.analyzing;

  Future<void> analyze(String imagePath) async {
    _imagePath = imagePath;
    _result = null;
    _error = null;
    _confirmed = false;
    _status = ScanStatus.analyzing;
    notifyListeners();

    try {
      _result = await _classifier.classify(imagePath);
      _status = ScanStatus.success;
    } catch (_) {
      _error = 'No pudimos analizar la imagen. Inténtalo de nuevo.';
      _status = ScanStatus.error;
    }
    notifyListeners();
  }

  void markConfirmed() {
    _confirmed = true;
    notifyListeners();
  }

  void reset() {
    _status = ScanStatus.idle;
    _imagePath = null;
    _result = null;
    _error = null;
    _confirmed = false;
    notifyListeners();
  }
}
