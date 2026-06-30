import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Lumi, el colibrí ecológico de EcoPacha, dibujado con CustomPaint.
/// Incluye flotación y aleteo suaves, sin necesidad de assets externos.
/// Si en el futuro hay una animación Lottie/Rive, puede reemplazar a este widget.
class LumiAvatar extends StatefulWidget {
  final double size;
  final bool animate;

  const LumiAvatar({super.key, this.size = 64, this.animate = true});

  @override
  State<LumiAvatar> createState() => _LumiAvatarState();
}

class _LumiAvatarState extends State<LumiAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _LumiPainter(t: widget.animate ? _controller.value : 0),
        ),
      ),
    );
  }
}

class _LumiPainter extends CustomPainter {
  final double t; // 0..1

  _LumiPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    Offset p(double x, double y) => Offset(x * s, y * s);

    // Flotación vertical suave.
    canvas.translate(0, math.sin(t * 2 * math.pi) * s * 0.04);

    // ---- Cola ----
    final tailPaint = Paint()..color = AppColors.turquoiseDark;
    final tail = Path()
      ..moveTo(s * 0.32, s * 0.56)
      ..lineTo(s * 0.06, s * 0.52)
      ..lineTo(s * 0.12, s * 0.66)
      ..close()
      ..moveTo(s * 0.32, s * 0.62)
      ..lineTo(s * 0.08, s * 0.72)
      ..lineTo(s * 0.18, s * 0.78)
      ..close();
    canvas.drawPath(tail, tailPaint);

    // ---- Cuerpo (con gradiente verde -> turquesa) ----
    final bodyCenter = p(0.50, 0.58);
    final bodyRect = Rect.fromCenter(
        center: bodyCenter, width: s * 0.54, height: s * 0.46);
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.turquoise],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bodyRect);
    canvas.save();
    canvas.translate(bodyCenter.dx, bodyCenter.dy);
    canvas.rotate(-0.25);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: s * 0.54, height: s * 0.42),
      bodyPaint,
    );
    canvas.restore();

    // ---- Pecho (amarillo) ----
    canvas.drawOval(
      Rect.fromCenter(center: p(0.55, 0.66), width: s * 0.24, height: s * 0.20),
      Paint()..color = AppColors.accentYellow,
    );

    // ---- Cabeza ----
    final headCenter = p(0.66, 0.39);
    canvas.drawCircle(headCenter, s * 0.18, Paint()..color = AppColors.primary);

    // ---- Pico ----
    final beak = Path()
      ..moveTo(s * 0.81, s * 0.37)
      ..lineTo(s * 0.99, s * 0.32)
      ..lineTo(s * 0.82, s * 0.43)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFF3A3A3A));

    // ---- Ojo ----
    canvas.drawCircle(p(0.69, 0.37), s * 0.062, Paint()..color = Colors.white);
    canvas.drawCircle(
        p(0.70, 0.37), s * 0.034, Paint()..color = const Color(0xFF13241B));
    canvas.drawCircle(p(0.685, 0.352), s * 0.014, Paint()..color = Colors.white);

    // ---- Ala (aleteo rápido) ----
    final flap = math.sin(t * 2 * math.pi * 2) * 0.55;
    canvas.save();
    canvas.translate(p(0.47, 0.50).dx, p(0.47, 0.50).dy);
    canvas.rotate(-0.45 + flap);
    final wing = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(s * 0.04, -s * 0.24, s * 0.30, -s * 0.12)
      ..quadraticBezierTo(s * 0.12, s * 0.04, 0, 0)
      ..close();
    canvas.drawPath(
        wing, Paint()..color = AppColors.primaryLight.withValues(alpha: 0.95));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LumiPainter oldDelegate) =>
      oldDelegate.t != t;
}
