import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'lumi_avatar.dart';

/// Lumi con efectos visuales según el nivel (aura, destellos, corona) e
/// interacción: al tocarla rebota y muestra un mensaje motivador.
class LumiWidget extends StatefulWidget {
  final int level;
  final double size;

  const LumiWidget({super.key, required this.level, this.size = 150});

  @override
  State<LumiWidget> createState() => _LumiWidgetState();
}

class _LumiWidgetState extends State<LumiWidget>
    with TickerProviderStateMixin {
  late final AnimationController _ambient;
  late final AnimationController _bounce;
  String? _message;
  int _next = 0;

  static const List<String> _messages = [
    '¡Gracias por cuidar la Pachamama!',
    'Reciclar una botella hoy crea un mejor mañana.',
    '¡Tu hábitat está creciendo gracias a ti!',
    'Cada acción cuenta para la Tierra. 🌎',
    '¡Sigue así, guardián! 🌱',
  ];

  // Umbral de efectos por nivel (tier 1..5).
  static const List<double> _auraByTier = [0, 0, 0.30, 0.40, 0.50, 0.62];
  static const List<int> _sparklesByTier = [0, 0, 2, 3, 4, 6];

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _bounce.dispose();
    super.dispose();
  }

  void _tap() {
    _bounce.forward(from: 0);
    setState(() {
      _message = _messages[_next % _messages.length];
      _next++;
    });
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) setState(() => _message = null);
    });
  }

  int get _tier {
    final l = widget.level;
    if (l >= 9) return 5;
    if (l >= 7) return 4;
    if (l >= 5) return 3;
    if (l >= 3) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final tier = _tier;
    return GestureDetector(
      onTap: _tap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (tier >= 2) _buildAura(size, tier),
            if (tier >= 2) ..._buildSparkles(size, tier),
            if (tier >= 3) _buildCrown(size),
            _buildLumi(size),
            if (_message != null) _buildBubble(),
          ],
        ),
      ),
    );
  }

  Widget _buildAura(double size, int tier) {
    final gold = tier >= 3;
    return AnimatedBuilder(
      animation: _ambient,
      builder: (context, _) {
        final pulse = 0.85 + math.sin(_ambient.value * 2 * math.pi) * 0.15;
        final opacity = _auraByTier[tier] * pulse;
        return Container(
          width: size * 0.95,
          height: size * 0.95,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (gold ? AppColors.accentYellow : AppColors.turquoise)
                    .withValues(alpha: opacity),
                AppColors.primary.withValues(alpha: opacity * 0.5),
                Colors.transparent,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSparkles(double size, int tier) {
    final count = _sparklesByTier[tier];
    const positions = [
      Offset(0.08, 0.16),
      Offset(0.84, 0.20),
      Offset(0.18, 0.74),
      Offset(0.82, 0.70),
      Offset(0.50, 0.02),
      Offset(0.94, 0.46),
    ];
    return List.generate(count, (i) {
      final p = positions[i % positions.length];
      return AnimatedBuilder(
        animation: _ambient,
        builder: (context, _) {
          final phase = (_ambient.value + i / count) % 1.0;
          final opacity = math.sin(phase * 2 * math.pi) * 0.5 + 0.5;
          return Positioned(
            left: p.dx * size,
            top: p.dy * size,
            child: Opacity(
              opacity: opacity,
              child: Icon(
                Icons.auto_awesome,
                size: size * 0.10,
                color: tier >= 3 ? AppColors.accentYellow : AppColors.turquoise,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildCrown(double size) {
    return Positioned(
      top: size * 0.02,
      child: Icon(Icons.eco, size: size * 0.18, color: AppColors.primary),
    );
  }

  Widget _buildLumi(double size) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        final scale = 1 + math.sin(_bounce.value * math.pi) * 0.14;
        return Transform.scale(scale: scale, child: child);
      },
      child: LumiAvatar(size: size * 0.72),
    );
  }

  Widget _buildBubble() {
    return Positioned(
      top: 0,
      left: 6,
      right: 6,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            _message!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
