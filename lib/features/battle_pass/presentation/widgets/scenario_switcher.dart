import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Служебный dev-контрол переключения моковых сценариев экрана (не часть
/// макета) — способ переключать состояния экрана, который просит ТЗ.
/// Свёрнут в плавающую кнопку, чтобы не перекрывать трек наград.
class ScenarioSwitcher extends StatefulWidget {
  const ScenarioSwitcher({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final BattlePassScenario current;
  final ValueChanged<BattlePassScenario> onChanged;

  @override
  State<ScenarioSwitcher> createState() => _ScenarioSwitcherState();
}

class _ScenarioSwitcherState extends State<ScenarioSwitcher> {
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

  // Подсказка на кнопку переключения сценариев — сама кнопка сжата в
  // маленькую иконку в углу и легко теряется при первом знакомстве с
  // экраном. Живёт только в памяти State (не персистится) — значит,
  // показывается заново при каждом полном перезапуске приложения, а не
  // один раз за всё время, что здесь и нужно: рецензент может перезапускать
  // приложение по нескольку раз за сессию ревью.
  bool _showHint = true;

  void _dismissHint() {
    if (_showHint) setState(() => _showHint = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors.mainColors;

    const buttonBgAlpha = 0.55;
    const buttonIconSize = 22.0;

    return Stack(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: AppPadding.allPadding12,
              child: PopupMenuButton<BattlePassScenario>(
                initialValue: widget.current,
                onSelected: widget.onChanged,
                tooltip: AppStrings.devScenarioSwitcherTooltip,
                itemBuilder: (context) => [
                  for (final scenario in BattlePassScenario.values)
                    PopupMenuItem(
                      value: scenario,
                      child: Row(
                        children: [
                          if (scenario == widget.current)
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
                    color: colors.appColorBlack.withValues(
                      alpha: buttonBgAlpha,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: colors.appColorWhite,
                    size: buttonIconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_showHint) _ScenarioSwitcherHint(onDismiss: _dismissHint),
      ],
    );
  }
}

/// Затемнение всего экрана + выноска со стрелкой на кнопку переключения
/// сценариев — показывается поверх всего остального контента, пока не
/// снята тапом в любом месте.
class _ScenarioSwitcherHint extends StatelessWidget {
  const _ScenarioSwitcherHint({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    const overlayAlpha = 0.6;
    const bubbleMaxWidth = 280.0;
    const bubblePadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    const bubbleBorderWidth = 1.5;
    const bubbleGlowBlurRadius = 20.0;
    const bubbleGlowSpreadRadius = 1.0;
    const calloutRight = 12.0;
    // Ниже нижнего края самой кнопки (12 внешний паддинг + ~46 диаметр
    // круга) — чтобы стрелка-указатель между выноской и кнопкой не
    // накладывалась на саму кнопку.
    const calloutBottom = 74.0;
    const arrowSize = 32.0;
    // Стрелка заходит под нижний край рамки бабла — чтобы шов между ними не
    // читался как отдельная деталь, а выноска выглядела цельной "капелькой".
    const arrowOverlap = -4.0;

    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        child: ColoredBox(
          color: colors.appColorBlack.withValues(alpha: overlayAlpha),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  right: calloutRight,
                  bottom: calloutBottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: bubbleMaxWidth,
                        ),
                        child: Container(
                          padding: bubblePadding,
                          decoration: BoxDecoration(
                            color: colors.taskCardHeaderBg,
                            borderRadius: AppRadius.circular24,
                            border: Border.all(
                              color: colors.glowGold,
                              width: bubbleBorderWidth,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.glowShadow,
                                blurRadius: bubbleGlowBlurRadius,
                                spreadRadius: bubbleGlowSpreadRadius,
                              ),
                            ],
                          ),
                          child: Text(
                            AppStrings.devScenarioSwitcherTooltip,
                            textAlign: TextAlign.center,
                            style: theme.appTypography.mobileTypo.p1Med
                                .copyWith(color: colors.accentGold),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, arrowOverlap),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: arrowSize,
                          color: colors.glowGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
