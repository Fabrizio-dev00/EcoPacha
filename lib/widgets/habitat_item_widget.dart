import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/habitat_item.dart';

/// Ícono circular de un objeto del hábitat (desbloqueado o bloqueado).
class HabitatItemWidget extends StatelessWidget {
  final HabitatItem item;
  final double size;
  final bool locked;

  const HabitatItemWidget({
    super.key,
    required this.item,
    this.size = 44,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: locked
            ? AppColors.surfaceMuted
            : item.color.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(
          color: locked ? Colors.black12 : item.color.withValues(alpha: 0.55),
          width: 2,
        ),
        boxShadow: locked
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Icon(
        locked ? Icons.lock_outline : item.icon,
        color: locked ? Colors.grey : item.color,
        size: size * 0.5,
      ),
    );
  }
}
