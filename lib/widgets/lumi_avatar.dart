import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Lumi, la mascota colibrí de EcoPacha.
/// Muestra la imagen de la mascota con una animación suave (flotar + "respirar").
/// Si faltara la imagen, muestra un ícono de respaldo (no rompe la app).
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
      duration: const Duration(milliseconds: 2200),
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
    final Widget image = Image.asset(
      'assets/images/lumi/lumi.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.flutter_dash,
        size: widget.size * 0.82,
        color: AppColors.primary,
      ),
    );

    if (!widget.animate) {
      return SizedBox(width: widget.size, height: widget.size, child: image);
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final phase = _controller.value * 2 * math.pi;
          final dy = math.sin(phase) * widget.size * 0.045;
          final scale = 1 + math.sin(phase) * 0.02;
          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: image,
      ),
    );
  }
}
