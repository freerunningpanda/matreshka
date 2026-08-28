import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../tasks/presentation/cubit/tasks_cubit.dart';
import '../../../tasks/presentation/cubit/tasks_state.dart';
import '../../domain/entities/level.dart';
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
                SafeArea(
                  child: DesignCanvas(
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
                              ? season
                                    .levels[season.currentLevel - 1]
                                    .requiredXp
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
                        PremiumBanner(
                          premiumOwned: season.premiumOwned,
                          onPressed: () {},
                        ),
                        RewardsTrack(
                          season: season,
                          onClaim: (levelNumber) {
                            final cubit = context.read<BattlePassCubit>();
                            cubit.claimReward(
                              levelNumber,
                              isPremiumReward: false,
                            );
                            if (season.premiumOwned) {
                              cubit.claimReward(
                                levelNumber,
                                isPremiumReward: true,
                              );
                            }
                          },
                        ),
                        if (season.levels.any(
                          (l) => l.state == LevelState.claimable,
                        ))
                          ClaimAllButton(
                            label: 'Забрать все награды',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF56B877), Color(0xFF449660)],
                            ),
                            onPressed: () => context
                                .read<BattlePassCubit>()
                                .claimAllRewards(),
                          ),
                        Positioned(
                          right: 24,
                          top: 24,
                          child: Material(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {},
                              child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
