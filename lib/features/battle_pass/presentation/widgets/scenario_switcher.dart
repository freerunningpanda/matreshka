import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Служебный dev-контрол переключения моковых сценариев экрана (не часть
/// макета) — способ переключать состояния экрана, который просит ТЗ.
/// Свёрнут в плавающую кнопку, чтобы не перекрывать трек наград.
class ScenarioSwitcher extends StatelessWidget {
  const ScenarioSwitcher({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final BattlePassScenario current;
  final ValueChanged<BattlePassScenario> onChanged;

  static const _labels = {
    BattlePassScenario.premiumLocked: AppStrings.devScenarioPremiumLocked,
    BattlePassScenario.premiumUnlockedWithReward:
        AppStrings.devScenarioPremiumUnlockedWithReward,
    BattlePassScenario.maxLevel: AppStrings.devScenarioMaxLevel,
    BattlePassScenario.premiumUnlockedNoReward:
        AppStrings.devScenarioPremiumUnlockedNoReward,
    BattlePassScenario.maxLevelNoReward: AppStrings.devScenarioMaxLevelNoReward,
    BattlePassScenario.completed: AppStrings.battlePassEndedTitle,
    BattlePassScenario.rewardsEndedPremiumOwned:
        AppStrings.devScenarioRewardsEndedPremiumOwned,
    BattlePassScenario.rewardsEndedPremiumNotOwned:
        AppStrings.devScenarioRewardsEndedPremiumNotOwned,
  };

  @override
  Widget build(BuildContext context) {
    const buttonBgAlpha = 0.55;
    const buttonIconSize = 22.0;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: AppPadding.allPadding12,
          child: PopupMenuButton<BattlePassScenario>(
            initialValue: current,
            onSelected: onChanged,
            tooltip: AppStrings.devScenarioSwitcherTooltip,
            itemBuilder: (context) => [
              for (final scenario in BattlePassScenario.values)
                PopupMenuItem(
                  value: scenario,
                  child: Row(
                    children: [
                      if (scenario == current)
                        const Icon(Icons.check, size: AppSizes.allSize18)
                      else
                        AppSizedBoxes.horizontalSizedBoxW18,
                      AppSizedBoxes.horizontalSizedBoxW8,
                      Flexible(
                        child: Text(
                          _labels[scenario] ?? scenario.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            child: Container(
              padding: AppPadding.allPadding12,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: buttonBgAlpha),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horiz,
                color: Colors.white,
                size: buttonIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
