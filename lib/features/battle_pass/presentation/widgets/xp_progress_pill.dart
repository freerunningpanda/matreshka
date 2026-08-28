import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Индикатор уровня — "BP_Level" из макета (node 1:1312): кольцевой прогресс
/// (сплошной трек 10% + дуга прогресса 60%, толщина 8) с номером уровня по
/// центру и подписью XP под кольцом. Позиция x:346 y:37 — из Figma.
class XpProgressPill extends StatelessWidget {
  const XpProgressPill({
    required this.currentLevel,
    required this.maxLevel,
    required this.currentXp,
    required this.xpToNextLevel,
    super.key,
  });

  final int currentLevel;
  final int maxLevel;
  final int currentXp;
  final int xpToNextLevel;

  @override
  Widget build(BuildContext context) {
    final isMaxLevel = currentLevel >= maxLevel;
    final progress = isMaxLevel || xpToNextLevel == 0
        ? 1.0
        : (currentXp / xpToNextLevel).clamp(0.0, 1.0);
    return Positioned(
      left: 346,
      top: 37,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stack даёт non-positioned детям только loose constraints,
                // а CircularProgressIndicator без tight constraints рисуется
                // в своём дефолтном размере (~36px) — поэтому обязателен
                // собственный SizedBox 100x100 вокруг самого индикатора.
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: AppColors.progressRingTrack,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.progressRingFill,
                    ),
                  ),
                ),
                Text(
                  '$currentLevel',
                  style: const TextStyle(
                    fontFamily: 'Geologica',
                    fontWeight: FontWeight.w600,
                    fontSize: 42,
                    height: 1.3,
                    letterSpacing: -0.42,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isMaxLevel ? 'Максимальный уровень' : '$currentXp / $xpToNextLevel',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontWeight: FontWeight.w500,
              fontSize: 22,
              height: 1.2,
              letterSpacing: -0.22,
              color: AppColors.progressRingFill,
            ),
          ),
        ],
      ),
    );
  }
}
