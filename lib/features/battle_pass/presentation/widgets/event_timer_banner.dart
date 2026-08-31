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
    const iconSize = 32.0;
    const textFontSize = 26.0;
    const textLineHeight = 1.2;
    const textLetterSpacing = -0.26;

    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: iconSize,
          color: AppColors.timerText,
        ),
        AppSizedBoxes.horizontalSizedBoxW14,
        const EventCountdownText(
          style: TextStyle(
            fontFamily: 'Geologica',
            fontWeight: FontWeight.w500,
            fontSize: textFontSize,
            height: textLineHeight,
            letterSpacing: textLetterSpacing,
            color: AppColors.timerText,
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
    const titleFontSize = 48.0;
    const titleLineHeight = 0.93;
    const titleLetterSpacing = -0.48;
    // Прямоугольник шейдера градиента заголовка — 1×45, а не размер
    // реального текста: тот неизвестен заранее, а важна только высота (так
    // градиент растягивается по вертикали текста, не по горизонтали).
    const gradientShaderRect = Rect.fromLTWH(0, 0, 1, 45);

    return Text(
      AppStrings.eventTitle,
      style: TextStyle(
        fontFamily: 'Geologica',
        fontWeight: FontWeight.w600,
        fontSize: titleFontSize,
        height: titleLineHeight,
        letterSpacing: titleLetterSpacing,
        foreground: Paint()
          ..shader = AppColors.eventTitleGradient.createShader(
            gradientShaderRect,
          ),
      ),
    );
  }
}
