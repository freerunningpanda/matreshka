import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Пилюля с уровнем и прогрессом опыта — переиспользует место "Info bar"
/// из макета, но показывает BP-релевантные данные (уровень/XP), а не
/// сторонний игровой ивент со скриншота (см. README, спорные места).
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
    final progress = xpToNextLevel == 0
        ? 1.0
        : (currentXp / xpToNextLevel).clamp(0.0, 1.0);
    return Positioned(
      left: 346,
      top: 37,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.accentGold,
              child: Text(
                '$currentLevel',
                style: const TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xFF2D2D31),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLevel >= maxLevel
                      ? 'Максимальный уровень'
                      : '$currentXp / $xpToNextLevel XP',
                  style: const TextStyle(
                    fontFamily: 'Geologica',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 180,
                    height: 8,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.accentGold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
