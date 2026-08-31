import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../tasks/domain/entities/task.dart';

/// Карточка-тизер "Задания" на главном экране БП — узел "Tasks_Main_BP"
/// (id 1:1266) из макета: верхняя стеклянная плашка с наградой/прогрессом
/// поверх нижней карточки с описанием задания и переходом на экран заданий.
/// Полноценный список заданий — вне скоупа (см. README), поэтому показывается
/// один мок-таск.
class TasksTeaserCard extends StatelessWidget {
  const TasksTeaserCard({required this.onTap, this.task, super.key});

  final VoidCallback onTap;
  final BattlePassTask? task;

  @override
  Widget build(BuildContext context) {
    final task = this.task;
    if (task == null) return const SizedBox.shrink();

    return Positioned(
      left: 346,
      top: 220,
      width: 400,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RewardHeader(
                rewardXp: task.rewardXp,
                progressCurrent: task.progressCurrent,
                progressTarget: task.progressTarget,
                completed: task.completed,
              ),
              _TaskBody(
                title: task.title,
                progressCurrent: task.progressCurrent,
                progressTarget: task.progressTarget,
                completed: task.completed,
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
    return Opacity(
      opacity: completed ? _kCompletedOpacity : 1,
      child: Container(
        height: 110,
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          color: AppColors.taskCardHeaderBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/battle_pass/icon_xp_bp.png',
              width: 96,
              height: 96,
            ),
            const SizedBox(width: 12),
            Text(
              'x $rewardXp',
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
              width: 112,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.taskChipBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: completed
                  ? SvgPicture.asset(
                      'assets/icons/battle_pass/done.svg',
                      width: 40,
                      height: 22,
                    )
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
                          TextSpan(text: ' / $progressTarget'),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskBody extends StatelessWidget {
  const _TaskBody({
    required this.title,
    required this.progressCurrent,
    required this.progressTarget,
    required this.completed,
  });

  final String title;
  final int progressCurrent;
  final int progressTarget;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
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
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 44, 40, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: completed ? _kCompletedOpacity : 1,
                  child: Text(
                    title,
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
                const SizedBox(height: 50),
                Opacity(
                  opacity: completed ? _kCompletedOpacity : 1,
                  child: _ProgressDashes(
                    current: progressCurrent,
                    target: progressTarget,
                  ),
                ),
                const SizedBox(height: 34),
                _TasksButton(showRewardBadge: completed),
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
          width: 54,
          height: 8,
          decoration: BoxDecoration(
            color: filled ? AppColors.textPrimary : AppColors.progressRingTrack,
            borderRadius: BorderRadius.circular(4),
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
          width: 320,
          padding: const EdgeInsets.fromLTRB(36, 20, 36, 23),
          decoration: BoxDecoration(
            color: AppColors.buttonOverlayStrong,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/battle_pass/icn_tasks.svg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 16),
              const Text(
                'Задания',
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
            child: SvgPicture.asset(
              'assets/icons/battle_pass/sticker_new.svg',
              width: 44,
              height: 46,
            ),
          ),
      ],
    );
  }
}
