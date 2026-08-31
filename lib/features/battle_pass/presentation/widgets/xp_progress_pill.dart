import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_padding.dart';
import '../../../../core/theme/app_sized_boxes.dart';

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
    // На макс. уровне экран не присылает следующий порог (xpToNextLevel=0,
    // идти дальше некуда) — раньше здесь был текст "Максимальный уровень",
    // но он шире кольца (100px) и ломает вёрстку. Вместо него тот же формат
    // "текущее/порог", что и на обычных уровнях, просто вместо порога — уже
    // набранный опыт (кольцо и так полное).
    final xpLabelTarget = xpToNextLevel == 0 ? currentXp : xpToNextLevel;
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
                Padding(
                  // Не впритык к краям кольца — при трёхзначном уровне
                  // (100) есть куда сжаться перед тем, как FittedBox
                  // реально понадобится.
                  padding: AppPadding.horizontalPadding8,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$currentLevel',
                      maxLines: 1,
                      style: const TextStyle(
                        fontFamily: 'Geologica',
                        fontWeight: FontWeight.w600,
                        fontSize: 42,
                        height: 1.3,
                        letterSpacing: -0.42,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSizedBoxes.verticalSizedBoxH12,
          // Ширина = кольцу выше — без этого шестизначные "100000 / 100000"
          // (currentLevel=100 — см. battle_pass_mock_api.dart) растягивали
          // бы Column шире кольца и наезжали на EventTimerBanner правее.
          SizedBox(
            width: 100,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$currentXp / $xpLabelTarget',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  height: 1.2,
                  letterSpacing: -0.22,
                  color: AppColors.progressRingFill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
