import 'package:flutter/material.dart';

import '../../../exports.dart';

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
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    const fullProgress = 1.0;
    const noProgress = 0.0;
    const pillLeft = 346.0;
    const pillTop = 37.0;
    const ringStrokeWidth = 8.0;

    final isMaxLevel = currentLevel >= maxLevel;
    final progress = isMaxLevel || xpToNextLevel == 0
        ? fullProgress
        : (currentXp / xpToNextLevel).clamp(noProgress, fullProgress);
    // На макс. уровне экран не присылает следующий порог (xpToNextLevel=0,
    // идти дальше некуда) — раньше здесь был текст "Максимальный уровень",
    // но он шире кольца (100px) и ломает вёрстку. Вместо него тот же формат
    // "текущее/порог", что и на обычных уровнях, просто вместо порога — уже
    // набранный опыт (кольцо и так полное).
    final xpLabelTarget = xpToNextLevel == 0 ? currentXp : xpToNextLevel;
    return Positioned(
      left: pillLeft,
      top: pillTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSizes.allSize100,
            height: AppSizes.allSize100,
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
                    strokeWidth: ringStrokeWidth,
                    backgroundColor: colors.progressRingTrack,
                    valueColor: AlwaysStoppedAnimation(colors.progressRingFill),
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
                      style: theme.appTypography.mobileTypo.semibold42.copyWith(
                        color: colors.textPrimary,
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
            width: AppSizes.horizontalSize100,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$currentXp${AppStrings.xpProgressSeparator}$xpLabelTarget',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: theme.appTypography.mobileTypo.p1Med.copyWith(
                  color: colors.progressRingFill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
