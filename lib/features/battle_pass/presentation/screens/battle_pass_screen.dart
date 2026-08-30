import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/presentation/cubit/tasks_cubit.dart';
import '../../../tasks/presentation/cubit/tasks_state.dart';
import '../../domain/entities/level.dart';
import '../../domain/repositories/battle_pass_repository.dart';
import '../cubit/battle_pass_cubit.dart';
import '../cubit/battle_pass_state.dart';
import '../widgets/battle_pass_background.dart';
import '../widgets/central_item_display.dart';
import '../widgets/claim_all_button.dart';
import '../widgets/design_canvas.dart';
import '../widgets/event_timer_banner.dart';
import '../widgets/left_nav_panel.dart';
import '../widgets/premium_banner.dart';
import '../widgets/rewards_track.dart';
import '../widgets/scenario_switcher.dart';
import '../widgets/tasks_teaser_card.dart';
import '../widgets/xp_progress_pill.dart';

class BattlePassScreen extends StatelessWidget {
  const BattlePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BattlePassCubit>(
      create: (_) => sl<BattlePassCubit>(),
      child: BlocProvider<TasksCubit>(
        create: (_) => sl<TasksCubit>(),
        child: const _BattlePassView(),
      ),
    );
  }
}

class _BattlePassView extends StatelessWidget {
  const _BattlePassView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BattlePassCubit, BattlePassState>(
        builder: (context, state) {
          return switch (state) {
            BattlePassLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            BattlePassError(:final message) => Center(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
            BattlePassLoaded(:final season, :final scenario) => Stack(
              children: [
                DesignCanvas(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const BattlePassBackground(),
                      const LeftNavPanel(),
                      XpProgressPill(
                        currentLevel: season.currentLevel,
                        maxLevel: season.maxLevel,
                        currentXp: season.currentXp,
                        xpToNextLevel:
                            season.currentLevel < season.levels.length
                            ? season.levels[season.currentLevel - 1].requiredXp
                            : 0,
                      ),
                      const EventTimerBanner(),
                      BlocBuilder<TasksCubit, TasksState>(
                        builder: (context, tasksState) => TasksTeaserCard(
                          task: switch (tasksState) {
                            TasksLoaded(:final overview) =>
                              overview.tasks.isEmpty
                                  ? null
                                  : overview.tasks.first,
                            _ => null,
                          },
                          onTap: () => AppRouter.toTasks(context),
                        ),
                      ),
                      CentralItemDisplay(scenario: scenario),
                      _DismissiblePremiumPromo(
                        premiumOwned: season.premiumOwned,
                        onUnlockPremium: () =>
                            context.read<BattlePassCubit>().purchasePremium(),
                      ),
                      RewardsTrack(
                        season: season,
                        onClaim: (levelNumber) async {
                          // Второй вызов должен дождаться первого: claimReward
                          // читает текущий cubit.state как снимок для copyWith,
                          // и если оба вызова стартуют не дожидаясь друг друга,
                          // они оба берут один и тот же снимок "до клейма" —
                          // тогда результат более позднего emit затирает более
                          // ранний (особенно заметно, когда премиум-награды на
                          // уровне нет: тот вызов — no-op, но всё равно
                          // переэмитит устаревший season поверх уже забранного).
                          final cubit = context.read<BattlePassCubit>();
                          await cubit.claimReward(
                            levelNumber,
                            isPremiumReward: false,
                          );
                          if (season.premiumOwned) {
                            await cubit.claimReward(
                              levelNumber,
                              isPremiumReward: true,
                            );
                          }
                        },
                        onUnlockPremium: () =>
                            context.read<BattlePassCubit>().purchasePremium(),
                      ),
                      if (scenario != BattlePassScenario.premiumLocked &&
                          scenario !=
                              BattlePassScenario.premiumUnlockedWithReward &&
                          season.levels.any(
                            (l) => l.state == LevelState.claimable,
                          ))
                        ClaimAllButton(
                          label: 'Забрать все награды',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF56B877), Color(0xFF449660)],
                          ),
                          onPressed: () =>
                              context.read<BattlePassCubit>().claimAllRewards(),
                        ),
                    ],
                  ),
                ),
                ScenarioSwitcher(
                  current: scenario,
                  onChanged: (s) =>
                      context.read<BattlePassCubit>().switchScenario(s),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}

/// Баннер премиума + кнопка закрытия — своё локальное состояние видимости,
/// изолированное в отдельном виджете: скрытие/показ не должно триггерить
/// перестройку соседей по Stack (трек наград и т.п.), которые с баннером
/// никак не связаны.
class _DismissiblePremiumPromo extends StatefulWidget {
  const _DismissiblePremiumPromo({
    required this.premiumOwned,
    required this.onUnlockPremium,
  });

  final bool premiumOwned;
  final VoidCallback onUnlockPremium;

  @override
  State<_DismissiblePremiumPromo> createState() =>
      _DismissiblePremiumPromoState();
}

class _DismissiblePremiumPromoState extends State<_DismissiblePremiumPromo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    void dismiss() => setState(() => _visible = false);

    return Positioned.fill(
      child: Stack(
        children: [
          PremiumBanner(
            premiumOwned: widget.premiumOwned,
            // Пока премиум не куплен, кнопка баннера — "Прокачать": она
            // должна переключать сценарий на премиум, а не просто прятать
            // баннер (крестик рядом отвечает за скрытие отдельно). Когда
            // премиум уже куплен, у кнопки нет своего действия для "повысить
            // уровень" — оставляем прежнее поведение (скрыть баннер).
            onPressed: widget.premiumOwned ? dismiss : widget.onUnlockPremium,
          ),
          Positioned(
            right: 80,
            top: 50,
            child: Material(
              color: AppColors.buttonOverlayWeak,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: dismiss,
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(32),
                  child: SvgPicture.asset(
                    'assets/icons/battle_pass/icn_x.svg',
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
