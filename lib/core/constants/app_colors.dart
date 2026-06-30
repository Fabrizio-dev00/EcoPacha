import 'package:flutter/material.dart';

/// Paleta de colores de EcoPacha.
/// Identidad de marca: verde, turquesa, blanco y detalles amarillos.
class AppColors {
  AppColors._();

  // --- Marca ---
  static const Color primary = Color(0xFF2E9E5B); // verde EcoPacha
  static const Color primaryDark = Color(0xFF1B6B3D);
  static const Color primaryLight = Color(0xFF8FD9AC);
  static const Color turquoise = Color(0xFF14B8A6); // turquesa
  static const Color turquoiseDark = Color(0xFF0E8C7F);
  static const Color accentYellow = Color(0xFFFFC233); // amarillo de acento

  // --- Neutros / superficies ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4FBF6); // blanco con tinte verde
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEAF5EE);

  // --- Texto ---
  static const Color textPrimary = Color(0xFF18241D);
  static const Color textSecondary = Color(0xFF5C6B62);

  // --- Estados ---
  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFE5484D);

  // --- Contenedores de reciclaje (referencia visual) ---
  static const Color binYellow = Color(0xFFFFC233); // plastico, metal, brik
  static const Color binBlue = Color(0xFF2F80ED); // papel y carton
  static const Color binGreen = Color(0xFF2E9E5B); // vidrio
  static const Color binBrown = Color(0xFF8D6E5C); // organico
  static const Color binRed = Color(0xFFE5484D); // peligrosos (pilas, electronicos)
  static const Color binGray = Color(0xFF6B7280); // no reciclable / resto
}
