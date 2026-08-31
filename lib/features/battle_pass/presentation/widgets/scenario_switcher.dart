import 'package:flutter/material.dart';

import '../../../../core/theme/app_padding.dart';
import '../../../../core/theme/app_sized_boxes.dart';
import '../../domain/repositories/battle_pass_repository.dart';

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
    BattlePassScenario.premiumLocked: 'Премиум не куплен',
    BattlePassScenario.premiumUnlockedWithReward: 'Премиум куплен / награда',
    BattlePassScenario.maxLevel: 'Макс. уровень / Много наград',
    BattlePassScenario.premiumUnlockedNoReward: 'Премиум куплен / нет наград',
    BattlePassScenario.maxLevelNoReward: 'Макс. уровень / Нет наград',
    BattlePassScenario.completed: 'Battle Pass завершен',
    BattlePassScenario.rewardsEndedPremiumOwned:
        'Конец наград (Куплен премиум)',
    BattlePassScenario.rewardsEndedPremiumNotOwned:
        'Конец наград (Не куплен премиум)',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: AppPadding.allPadding12,
          child: PopupMenuButton<BattlePassScenario>(
            initialValue: current,
            onSelected: onChanged,
            tooltip: 'Переключить сценарий (dev)',
            itemBuilder: (context) => [
              for (final scenario in BattlePassScenario.values)
                PopupMenuItem(
                  value: scenario,
                  child: Row(
                    children: [
                      if (scenario == current)
                        const Icon(Icons.check, size: 18)
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
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horiz,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
