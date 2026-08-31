import 'dart:math' as math;

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

class _EventTitle extends StatefulWidget {
  const _EventTitle();

  @override
  State<_EventTitle> createState() => _EventTitleState();
}

class _EventTitleState extends State<_EventTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // "Дай пять!" в буквальном смысле — тап отвечает жестом: ладонь
      // выпрыгивает с перехлёстом и гаснет под разлёт золотых искр вокруг
      // заголовка. Чисто декоративная обратная связь, ничего не меняет в
      // состоянии экрана.
      onTap: () => _controller.forward(from: 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(
            AppStrings.eventTitle,
            style: theme.appTypography.mobileTypo.semibold48.copyWith(
              foreground: Paint()
                ..shader = titleGradient.createShader(gradientShaderRect),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => IgnorePointer(
              child: _HighFiveBurst(
                progress: _controller.value,
                color: colors.accentGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ладонь "дай пять" + разлёт искр вокруг заголовка события по тапу —
/// целиком декоративный слой (см. _EventTitleState._controller), ничего не
/// хранит и не влияет на данные экрана.
class _HighFiveBurst extends StatelessWidget {
  const _HighFiveBurst({required this.progress, required this.color});

  /// 0 — анимация не запущена (ничего не рисуем), 1 — полностью прошла.
  final double progress;
  final Color color;

  static const _sparkCount = 8;
  static const _maxRadius = 70.0;
  static const _sparkSize = 14.0;
  static const _handSize = 56.0;

  @override
  Widget build(BuildContext context) {
    if (progress == 0) return const SizedBox.shrink();

    // Ладонь выпрыгивает с перехлёстом первую половину анимации и
    // растворяется во второй — сам разлёт искр (см. _buildSpark) идёт все
    // 100% отдельным, более плавным темпом.
    final handProgress = (progress / 0.5).clamp(0.0, 1.0);
    final handScale = Curves.elasticOut.transform(handProgress);
    final handOpacity =
        1 - Curves.easeIn.transform(((progress - 0.5) / 0.5).clamp(0.0, 1.0));

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        for (var i = 0; i < _sparkCount; i++) _buildSpark(i),
        Opacity(
          opacity: handOpacity,
          child: Transform.scale(
            scale: handScale,
            child: Icon(Icons.pan_tool, size: _handSize, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildSpark(int index) {
    final angle = 2 * math.pi * index / _sparkCount;
    final distance = Curves.easeOut.transform(progress) * _maxRadius;
    final opacity = 1 - progress;

    return Transform.translate(
      offset: Offset(math.cos(angle) * distance, math.sin(angle) * distance),
      child: Opacity(
        opacity: opacity,
        child: Icon(Icons.star, size: _sparkSize, color: color),
      ),
    );
  }
}
