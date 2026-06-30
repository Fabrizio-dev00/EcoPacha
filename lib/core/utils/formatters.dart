import 'package:intl/intl.dart';

/// Utilidades de formato (fechas, números y unidades) en español.
class Formatters {
  Formatters._();

  static String shortDate(DateTime date) =>
      DateFormat('d MMM yyyy', 'es').format(date);

  static String dayMonth(DateTime date) =>
      DateFormat("d 'de' MMMM", 'es').format(date);

  static String points(int value) =>
      NumberFormat.decimalPattern('es').format(value);

  static String weightKg(double kg) {
    if (kg < 1) return '${(kg * 1000).round()} g';
    return '${kg.toStringAsFixed(1)} kg';
  }

  static String liters(double value) =>
      value < 10 ? '${value.toStringAsFixed(1)} L' : '${value.round()} L';

  static String co2(double kg) {
    if (kg < 1) return '${(kg * 1000).round()} g';
    return '${kg.toStringAsFixed(1)} kg';
  }
}
