import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../models/habitat_item.dart';
import '../providers/user_progress_provider.dart';
import 'habitat_info_bottom_sheet.dart';
import 'habitat_item_widget.dart';
import 'lumi_widget.dart';

/// Área interactiva del EcoHábitat: fondo que evoluciona por nivel, objetos
/// desbloqueados (tocables y arrastrables) y Lumi al centro.
class HabitatScene extends StatefulWidget {
  const HabitatScene({super.key});

  @override
  State<HabitatScene> createState() => _HabitatSceneState();
}

class _HabitatSceneState extends State<HabitatScene> {
  static const double _itemSize = 46;
  String? _dragId;
  double _dragX = 0;
  double _dragY = 0;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<UserProgressProvider>();
    final level = progress.level;
    final items = progress.unlockedHabitatItems;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 300,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: _sky(level)),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: h * 0.30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: _ground(level)),
                  ),
                ),
                for (final item in items) _item(context, item, w, h, progress),
                Align(
                  alignment: const Alignment(0, -0.1),
                  child: LumiWidget(level: level, size: 150),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _item(BuildContext context, HabitatItem item, double w, double h,
      UserProgressProvider progress) {
    final dragging = _dragId == item.id;
    final pos = dragging ? [_dragX, _dragY] : progress.positionFor(item);
    final left = (pos[0] * w).clamp(0.0, w - _itemSize);
    final top = (pos[1] * h).clamp(0.0, h - _itemSize);
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => _handleTap(context, item, progress),
        onPanStart: (_) {
          final p = progress.positionFor(item);
          setState(() {
            _dragId = item.id;
            _dragX = p[0];
            _dragY = p[1];
          });
        },
        onPanUpdate: (d) {
          setState(() {
            _dragX = (_dragX + d.delta.dx / w).clamp(0.0, 1.0);
            _dragY = (_dragY + d.delta.dy / h).clamp(0.0, 1.0);
          });
        },
        onPanEnd: (_) {
          progress.setItemPosition(item.id, _dragX, _dragY);
          setState(() => _dragId = null);
        },
        child: HabitatItemWidget(item: item, size: _itemSize),
      ),
    );
  }

  void _handleTap(
      BuildContext context, HabitatItem item, UserProgressProvider progress) {
    if (item.action == HabitatItemAction.scan) {
      context.go('/scan');
    } else if (item.action == HabitatItemAction.impact) {
      showHabitatImpact(context, progress.totalImpact);
    } else {
      showHabitatItemInfo(context, item);
    }
  }

  LinearGradient _sky(int level) {
    if (level >= 7) {
      return const LinearGradient(
        colors: [Color(0xFF8FD3FF), Color(0xFFD9F5E4)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (level >= 4) {
      return const LinearGradient(
        colors: [Color(0xFFBFE9FF), Color(0xFFEAF7EF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFDDEFF7), AppColors.surfaceMuted],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  LinearGradient _ground(int level) {
    if (level >= 5) {
      return const LinearGradient(
        colors: [Color(0xFF7ECB8F), Color(0xFF4FA96A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFCDE9D3), Color(0xFF9FD3AE)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
