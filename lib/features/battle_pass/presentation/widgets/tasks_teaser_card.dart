import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

/// Карточка-тизер "Задания" на главном экране БП — узел "Tasks_Main_BP"
/// (id 1:1266) из макета: верхняя стеклянная плашка с наградой/прогрессом
/// поверх нижней карточки с описанием задания и переходом на экран заданий.
/// Полноценный список заданий — вне скоупа (см. README), поэтому показывается
/// один мок-таск.
class TasksTeaserCard extends StatelessWidget {
  const TasksTeaserCard({
    required this.onTap,
    this.task,
    this.claimableInline = false,
    this.onClaimXp,
    super.key,
  });

  final VoidCallback onTap;
  final BattlePassTask? task;

  /// "Макс. уровень / Много наград" (см. README про мок-схему заданий) —
  /// вместо перехода на экран заданий выполненный таск клеймится прямо с
  /// тизера ("Забрать опыт"). Во всех остальных сценариях завершённый таск
  /// по-прежнему просто открывает экран заданий.
  final bool claimableInline;
  final VoidCallback? onClaimXp;

  @override
  Widget build(BuildContext context) {
    final task = this.task;
    if (task == null) return const SizedBox.shrink();

    final claimMode = claimableInline && task.completed;
    // Клейм-режим переиспользует "просматриваемый" completed-стиль (притух-
    // ание + чек-иконка в чипе, см. сценарий "премиум куплен/награда") лишь
    // частично: числовой прогресс здесь остаётся видимым и на полной
    // непрозрачности — completed в этом смысле относится только к обычному
    // browsable-варианту.
    final cardTap = claimMode ? (task.claimed ? null : onClaimXp) : onTap;

    return Positioned(
      left: 346,
      top: 220,
      width: 400,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: cardTap,
          borderRadius: AppRadius.circular30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RewardHeader(
                rewardXp: task.rewardXp,
                progressCurrent: task.progressCurrent,
                progressTarget: task.progressTarget,
                completed: task.completed && !claimMode,
              ),
              _TaskBody(
                title: task.title,
                progressCurrent: task.progressCurrent,
                progressTarget: task.progressTarget,
                completed: task.completed && !claimMode,
                // Клейм-режим не притушен целиком (см. выше), но заголовок
                // центрируется, а сегменты прогресса всё равно притушены —
                // отдельные флаги, не общий completed.
                centerContent: claimMode,
                dimProgress: claimMode,
                footerButton: claimMode
                    ? _ClaimXpButton(claimed: task.claimed)
                    : _TasksButton(showRewardBadge: task.completed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Общая притушенность выполненного, но ещё не забранного задания — узел
// "Tasks_Main_BP" сценария "премиум куплен / награда" (node-id 1-1324 в
// Figma). Кнопка "Задания" и бейдж на ней в эту притушенность не входят —
// они остаются на полной непрозрачности, поэтому оборачиваются в Opacity
// отдельно от заголовка/текста/прогресса.
const double _kCompletedOpacity = 0.55;

class _RewardHeader extends StatelessWidget {
  const _RewardHeader({
    required this.rewardXp,
    required this.progressCurrent,
    required this.progressTarget,
    required this.completed,
  });

  final int rewardXp;
  final int progressCurrent;
  final int progressTarget;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: completed ? _kCompletedOpacity : 1,
          child: Container(
            height: AppSizes.verticalSize110,
            width: AppSizes.horizontalSize400,
            padding: AppPadding.horizontalPadding30,
            decoration: const BoxDecoration(
              color: AppColors.taskCardHeaderBg,
              borderRadius: BorderRadius.only(
                topLeft: AppRadius.radius30,
                topRight: AppRadius.radius30,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.imageIconXpBp,
                  width: AppSizes.allSize96,
                  height: AppSizes.allSize96,
                ),
                AppSizedBoxes.horizontalSizedBoxW12,
                Text(
                  '${AppStrings.taskRewardXpPrefix}$rewardXp',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Geologica',
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    height: 1.2,
                    letterSpacing: -0.26,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  width: AppSizes.horizontalSize112,
                  height: AppSizes.verticalSize56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.taskChipBg,
                    borderRadius: AppRadius.circular20,
                  ),
                  // Галочка "готово" рисуется отдельным неприглушённым слоем
                  // ниже (см. Positioned) — здесь на её месте пусто.
                  child: completed
                      ? null
                      : Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Geologica',
                              fontWeight: FontWeight.w500,
                              fontSize: 26,
                              height: 1.2,
                              letterSpacing: -0.26,
                              color: AppColors.textMuted,
                            ),
                            children: [
                              TextSpan(
                                text: '$progressCurrent',
                                style: const TextStyle(
                                  color: AppColors.claimGreenTop,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${AppStrings.taskProgressSeparator}'
                                    '$progressTarget',
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        // Галочка "готово" — поверх притушенной шапки, сама не тускнеет
        // вместе с ней (см. _kCompletedOpacity). Плашка Row справа всегда
        // прижата к правому краю (Spacer забирает всё свободное место), а
        // сама галочка центрирована в ней — координаты те же, что были бы у
        // неё внутри Row: 400 (ширина шапки) − 30 (правый паддинг) − 112
        // (ширина плашки) = 258 (левый край плашки); плашка высотой 56
        // центрирована по вертикали в шапке высотой 110 → top 27. Галочка
        // 40×22 центрирована в плашке 112×56.
        if (completed)
          Positioned(
            left: 294,
            top: 44,
            child: IgnorePointer(
              child: SvgPicture.asset(
                AppAssets.iconDone,
                width: AppSizes.horizontalSize40,
                height: AppSizes.verticalSize22,
              ),
            ),
          ),
      ],
    );
  }
}

class _TaskBody extends StatelessWidget {
  const _TaskBody({
    required this.title,
    required this.progressCurrent,
    required this.progressTarget,
    required this.completed,
    required this.footerButton,
    this.centerContent = false,
    this.dimProgress = false,
  });

  final String title;
  final int progressCurrent;
  final int progressTarget;
  final bool completed;
  final Widget footerButton;

  /// "Забрать опыт" (см. TasksTeaserCard.claimMode) центрирует заголовок,
  /// а не притушивает его вместе с остальным — самостоятельный флаг,
  /// отдельный от completed.
  final bool centerContent;

  /// Сегменты прогресса притушены и в клейм-режиме, хотя заголовок и
  /// шапка карточки в нём остаются на полной непрозрачности.
  final bool dimProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.horizontalSize400,
      child: Stack(
        children: [
          // Фон + текст/прогресс притушены при завершённом задании; кнопка —
          // отдельный слой поверх, полностью непрозрачный (см.
          // _kCompletedOpacity).
          Positioned.fill(
            child: Opacity(
              opacity: completed ? _kCompletedOpacity : 1,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.taskCardBodyBg,
                  borderRadius: BorderRadius.only(
                    bottomLeft: AppRadius.radius30,
                    bottomRight: AppRadius.radius30,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: AppPadding.ltrbPaddingL40T44R40B20,
            child: Column(
              crossAxisAlignment: centerContent
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: completed ? _kCompletedOpacity : 1,
                  child: Text(
                    title,
                    textAlign: centerContent
                        ? TextAlign.center
                        : TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      height: 1.2,
                      letterSpacing: -0.22,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                AppSizedBoxes.verticalSizedBoxH50,
                Opacity(
                  opacity: (completed || dimProgress) ? _kCompletedOpacity : 1,
                  child: _ProgressDashes(
                    current: progressCurrent,
                    target: progressTarget,
                  ),
                ),
                AppSizedBoxes.verticalSizedBoxH34,
                footerButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressDashes extends StatelessWidget {
  const _ProgressDashes({required this.current, required this.target});

  final int current;
  final int target;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(target, (index) {
        final filled = index < current;
        return Container(
          width: AppSizes.horizontalSize54,
          height: AppSizes.verticalSize8,
          decoration: BoxDecoration(
            color: filled ? AppColors.textPrimary : AppColors.progressRingTrack,
            borderRadius: AppRadius.circular4,
          ),
        );
      }),
    );
  }
}

class _TasksButton extends StatelessWidget {
  const _TasksButton({this.showRewardBadge = false});

  final bool showRewardBadge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppSizes.horizontalSize320,
          padding: AppPadding.ltrbPaddingL36T20R36B23,
          decoration: BoxDecoration(
            color: AppColors.buttonOverlayStrong,
            borderRadius: AppRadius.circular30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.iconTasks,
                width: AppSizes.allSize30,
                height: AppSizes.allSize30,
              ),
              AppSizedBoxes.horizontalSizedBoxW16,
              const Text(
                AppStrings.tasksButtonLabel,
                style: TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  height: 1.2,
                  letterSpacing: -0.26,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        // Бейдж "есть невостребованная награда" — сидит в правом верхнем
        // углу кнопки, слегка выходя за её границы.
        if (showRewardBadge)
          Positioned(
            right: -12,
            top: -10,
            child: Container(
              width: AppSizes.horizontalSize44,
              height: AppSizes.verticalSize46,
              decoration: BoxDecoration(
                borderRadius: AppRadius.circular30,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.glowShadow,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AppAssets.iconStickerNew,
                width: AppSizes.horizontalSize44,
                height: AppSizes.verticalSize46,
              ),
            ),
          ),
      ],
    );
  }
}

/// Кнопка клейма опыта прямо с тизера ("Забрать опыт" / "Получено" — см.
/// сценарий "Макс. уровень / Много наград"). В отличие от _TasksButton не
/// декоративна: собственного тапа не имеет — реагирует на тап по всей
/// карточке (см. TasksTeaserCard.cardTap), а после клейма просто выглядит
/// неактивной (карточка перестаёт быть кликабельной вместе с ней).
class _ClaimXpButton extends StatelessWidget {
  const _ClaimXpButton({required this.claimed});

  final bool claimed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.horizontalSize320,
      padding: AppPadding.ltrbPaddingL36T20R36B23,
      decoration: BoxDecoration(
        gradient: claimed ? null : AppColors.claimXpButtonGradient,
        color: claimed ? AppColors.taskChipBg : null,
        borderRadius: AppRadius.circular30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (claimed) ...[
            SvgPicture.asset(
              AppAssets.iconDone,
              width: AppSizes.horizontalSize26,
              height: AppSizes.verticalSize14,
            ),
            AppSizedBoxes.horizontalSizedBoxW14,
          ],
          Text(
            claimed ? AppStrings.xpClaimedLabel : AppStrings.claimXpButtonLabel,
            style: TextStyle(
              fontFamily: 'Geologica',
              fontWeight: FontWeight.w500,
              fontSize: 26,
              height: 1.2,
              letterSpacing: -0.26,
              color: claimed ? AppColors.textMuted : AppColors.claimXpText,
            ),
          ),
        ],
      ),
    );
  }
}
