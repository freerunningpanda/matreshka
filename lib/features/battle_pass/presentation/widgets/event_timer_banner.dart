import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Таймер + заголовок ивента ("+" фрейм узла "Info bar", id 1:1312) —
/// рядом с кольцом уровня. Дедлайн — статичный мок (см. README): сам ивент
/// "Дай пять!" сторонний по отношению к боевому пропуску, вне схемы данных
/// этого задания, но обратный отсчёт тикает по-настоящему.
class EventTimerBanner extends StatelessWidget {
  const EventTimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const bannerLeft = 513.0;
    const bannerTop = 56.0;

    return const Positioned(
      left: bannerLeft,
      top: bannerTop,
      width: AppSizes.horizontalSize439,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CountdownTimer(),
          AppSizedBoxes.verticalSizedBoxH8,
          _EventTitle(),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatelessWidget {
  const _CountdownTimer();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    const iconSize = 32.0;

    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: iconSize,
          color: colors.timerText,
        ),
        AppSizedBoxes.horizontalSizedBoxW14,
        EventCountdownText(
          style: theme.appTypography.mobileTypo.medium26.copyWith(
            color: colors.timerText,
          ),
        ),
      ],
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    // Прямоугольник шейдера градиента заголовка — 1×45, а не размер
    // реального текста: тот неизвестен заранее, а важна только высота (так
    // градиент растягивается по вертикали текста, не по горизонтали).
    const gradientShaderRect = Rect.fromLTWH(0, 0, 1, 45);
    final titleGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [colors.eventTitleTop, colors.eventTitleBottom],
    );

    return Text(
      AppStrings.eventTitle,
      style: theme.appTypography.mobileTypo.semibold48.copyWith(
        foreground: Paint()
          ..shader = titleGradient.createShader(gradientShaderRect),
      ),
    );
  }
}
