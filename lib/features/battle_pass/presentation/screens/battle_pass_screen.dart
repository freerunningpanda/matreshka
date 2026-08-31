import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../tasks/presentation/cubit/tasks_cubit.dart';
import '../../../tasks/presentation/cubit/tasks_state.dart';
import '../../domain/entities/level.dart';
import '../../domain/repositories/battle_pass_repository.dart';
import '../cubit/battle_pass_cubit.dart';
import '../cubit/battle_pass_state.dart';
import '../widgets/battle_pass_background.dart';
import '../widgets/battle_pass_ended_notice.dart';
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
        // Мок-таск на тизер-карточке (см. TasksMockApi) свой под каждый
        // сценарий (разные xp/прогресс/текст) — держим его в синхроне со
        // scenario, а не только с начальным сценарием TasksCubit по
        // умолчанию. Сравниваем именно scenario, а не season.premiumOwned:
        // "премиум куплен/награда" и "макс. уровень" оба premiumOwned=true,
        // но с разными тасками.
        child: BlocListener<BattlePassCubit, BattlePassState>(
          listenWhen: (previous, current) =>
              current is BattlePassLoaded &&
              (previous is! BattlePassLoaded ||
                  previous.scenario != current.scenario),
          listener: (context, state) {
            if (state is BattlePassLoaded) {
              context.read<TasksCubit>().load(state.scenario);
            }
          },
          child: const _BattlePassView(),
        ),
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
                      // Карточка заданий убрана в "Battle Pass завершен" —
                      // раздавать/выполнять задания уже нечего, вместо неё
                      // итоговое сообщение с обратным отсчётом.
                      if (scenario == BattlePassScenario.completed)
                        const BattlePassEndedNotice()
                      else
                        BlocBuilder<TasksCubit, TasksState>(
                          builder: (context, tasksState) {
                            final task = switch (tasksState) {
                              TasksLoaded(:final overview) =>
                                overview.tasks.isEmpty
                                    ? null
                                    : overview.tasks.first,
                              _ => null,
                            };
                            return TasksTeaserCard(
                              task: task,
                              onTap: () => AppRouter.toTasks(context),
                              // "Забрать опыт" прямо с тизера — только в
                              // "Макс. уровень / Много наград" (см. README
                              // про мок-схему заданий). "Макс. уровень / Нет
                              // наград" в плане UI берёт за основу
                              // premiumUnlockedNoReward — там обычный переход
                              // на экран заданий, без клейма с тизера.
                              claimableInline:
                                  scenario == BattlePassScenario.maxLevel,
                              onClaimXp: task == null
                                  ? null
                                  : () => context
                                        .read<TasksCubit>()
                                        .claimTaskXp(task.id),
                            );
                          },
                        ),
                      CentralItemDisplay(scenario: scenario),
                      _DismissiblePremiumPromo(
                        premiumOwned: season.premiumOwned,
                        onUnlockPremium: () =>
                            context.read<BattlePassCubit>().purchasePremium(),
                        onIncreaseLevel: () =>
                            context.read<BattlePassCubit>().increaseLevel(),
                        // "Повысить уровень" нечего делать, если уровень уже
                        // максимальный — баннер вместо кнопки показывает
                        // неактивную плашку (см. PremiumBanner). Кроме
                        // "Battle Pass завершен" — там currentLevel тоже
                        // максимальный, но кнопка остаётся активной, как в
                        // "Премиум куплен / награда".
                        maxLevelReached:
                            season.currentLevel >= season.maxLevel &&
                            scenario != BattlePassScenario.completed,
                        // "Забрать все награды" — только в "Макс. уровень /
                        // Много наград". Не часть колонки PremiumBanner
                        // (баннер фиксированной высоты, кнопка внутри сдвигала
                        // заголовок/подзаголовок вверх) — рисуется отдельным
                        // элементом Stack прямо под баннером, см.
                        // _DismissiblePremiumPromoState.build.
                        claimAllButton:
                            scenario != BattlePassScenario.premiumLocked &&
                                scenario !=
                                    BattlePassScenario
                                        .premiumUnlockedWithReward &&
                                // premiumUnlockedNoReward прячет эту кнопку;
                                // maxLevelNoReward в плане UI берёт его за
                                // основу (см. комментарий у enum-значения) —
                                // тоже прячем.
                                scenario !=
                                    BattlePassScenario
                                        .premiumUnlockedNoReward &&
                                scenario !=
                                    BattlePassScenario.maxLevelNoReward &&
                                season.levels.any(
                                  (l) => l.state == LevelState.claimable,
                                )
                            ? ClaimAllButton(
                                label: 'Забрать все награды',
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF56B877),
                                    Color(0xFF449660),
                                  ],
                                ),
                                onPressed: () => context
                                    .read<BattlePassCubit>()
                                    .claimAllRewards(),
                              )
                            : null,
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
                        // Ромб превью юбилейного уровня — это про то, что
                        // трек реально на 40-м уровне, а не про "UI-базу"
                        // сценария (см. maxLevelNoReward ниже), поэтому
                        // завязан на currentLevel, а не наследует
                        // premiumUnlockedNoReward.
                        highlightMaxLevelMilestone:
                            scenario == BattlePassScenario.maxLevel ||
                            scenario == BattlePassScenario.maxLevelNoReward,
                        // premiumUnlockedNoReward — как premiumUnlockedWith
                        // Reward. maxLevelNoReward в плане UI берёт за
                        // основу premiumUnlockedNoReward (см. трек наград
                        // выше в battle_pass_mock_api.dart), в т.ч. и здесь.
                        hideGiftBadge:
                            scenario ==
                                BattlePassScenario.premiumUnlockedWithReward ||
                            scenario ==
                                BattlePassScenario.premiumUnlockedNoReward ||
                            scenario == BattlePassScenario.maxLevelNoReward,
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
    required this.onIncreaseLevel,
    this.claimAllButton,
    this.maxLevelReached = false,
  });

  final bool premiumOwned;
  final VoidCallback onUnlockPremium;
  final VoidCallback onIncreaseLevel;
  final Widget? claimAllButton;
  final bool maxLevelReached;

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
            // Кнопка баннера переключает сценарий в обоих состояниях —
            // "Прокачать" ведёт на премиум, "Повысить уровень" на макс.
            // уровень; скрытие баннера остаётся отдельным действием
            // крестика рядом, а не побочным эффектом этой кнопки.
            onPressed: widget.premiumOwned
                ? widget.onIncreaseLevel
                : widget.onUnlockPremium,
            maxLevelReached: widget.maxLevelReached,
          ),
          // Отдельный элемент Stack, а не часть колонки баннера — баннер
          // фиксированной высоты, и добавление кнопки внутрь неё раньше
          // сдвигало заголовок/подзаголовок вверх (растущий снизу-вверх
          // bottom-anchored Column). "top: height+24" (сразу под баннером)
          // наезжал на плавающее превью юбилейного уровня из RewardsTrack —
          // оно якорится от низа холста (Positioned(bottom:24,height:300) +
          // сама карточка 268+12+34=314 снизу с отступом 14 в rewards_track
          // .dart), поэтому её верхний край фиксирован в координатах холста:
          // designHeight-24-14-314=728. Поднимаем кнопку по низу (не по
          // верху — так не нужно знать точную высоту самой кнопки), чтобы
          // её нижний край гарантированно оставался выше этой отметки.
          if (widget.claimAllButton != null)
            Positioned(
              right: 6,
              bottom: AppDimens.designHeight - 748 + 8,
              width: PremiumBanner.width,
              child: Center(child: widget.claimAllButton),
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
