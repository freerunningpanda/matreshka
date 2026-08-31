import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

/// Заменяет карточку заданий в сценарии "Battle Pass завершен" (см.
/// battle_pass_screen.dart) — раздавать/выполнять задания уже нечего,
/// вместо этого итоговое сообщение с обратным отсчётом, синхронизированным
/// с EventTimerBanner (общий eventCountdownDeadline).
class BattlePassEndedNotice extends StatelessWidget {
  const BattlePassEndedNotice({super.key});

  static const double _cardWidth = 466;
  static const double _stickerHeight = 92;

  // Рамка виджета (Figma): left:346 top:305 — сама иконка выше на половину
  // своей высоты, так что её низ проходит ровно по верхнему краю рамки.
  static const double _cardTop = 305;
  static const double _stickerTop = _cardTop - _stickerHeight / 2;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    const noticeLeft = 346.0;
    const stickerGlowTop = -8.0;
    const stickerGlowBlurRadius = 40.0;
    const stickerGlowSpreadRadius = 1.0;

    return Positioned(
      left: noticeLeft,
      top: _stickerTop,
      width: _cardWidth,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          const Padding(padding: AppPadding.topPadding46, child: _Card()),
          Positioned(
            top: stickerGlowTop,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.appColors.mainColors.glowShadow,
                    blurRadius: stickerGlowBlurRadius,
                    spreadRadius: stickerGlowSpreadRadius,
                  ),
                ],
              ),
              child: SvgPicture.asset(AppAssets.iconStickerBig),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card();

  static const _borderWidth = 4.0;
  static const _outerRadius = 40.0;

  // Форма диагонального блика (Figma) — сами цвета берутся из темы
  // (см. build), здесь только геометрия градиента.
  static const _sheenBegin = Alignment(-0.99, -0.14); // ≈ 97.91deg
  static const _sheenEnd = Alignment(0.99, 0.14);
  static const _sheenStops = [0.0, 0.5745, 0.7907, 0.9241, 1.0];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    // background (Figma): сплошной rgba(117,83,27,0.6) поверх диагонального
    // блика rgba(200,166,111,·) с прозрачными краями — два слоя, а не один
    // цвет, поэтому рисуются отдельными DecoratedBox друг на друге, а не
    // одним BoxDecoration (color и gradient в нём взаимно исключают друг
    // друга).
    final flatBg = colors.endedNoticeFlatBg; // rgba(117,83,27,0.6)
    final sheenGradient = LinearGradient(
      begin: _sheenBegin,
      end: _sheenEnd,
      stops: _sheenStops,
      colors: [
        colors.endedNoticeSheenTransparent,
        colors.endedNoticeSheenTransparent,
        colors.endedNoticeSheenHighlight, // rgba(200,166,111,0.3)
        colors.endedNoticeSheenTransparent,
        colors.endedNoticeSheenTransparent,
      ],
    );
    // Рамка (Figma border-image) — 4px кольцо, а не Border.all одним цветом:
    // спецификация даёт два слоя — сплошной #FFB41C (glowGold) и поверх него
    // блик из levelUpBorder*-стопов через blend "overlay" (тот же приём, что
    // у золотой кнопки в premium_banner.dart). Обычный "заливка + паддинг
    // вместо бордера" здесь не подходит: интерьер сделан прозрачным намеренно
    // (см. flatBg/sheenGradient выше), и его прозрачные слои просвечивали бы
    // не сквозь карточку до фона экрана, а до этой золотой заливки под ними.
    // Поэтому кольцо рисуется отдельно поверх контента через CustomPaint —
    // так оно не участвует в фоне интерьера.
    final borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colors.levelUpBorderOrange,
        colors.levelUpBorderYellow,
        colors.levelUpBorderLight,
        colors.levelUpBorderAmber,
        colors.levelUpBorderCoral,
      ],
      stops: const [0.0, 0.37, 0.40, 0.73, 1.0],
    );

    const cardGlowBlurRadius = 40.0;
    const cardGlowSpreadRadius = 2.0;
    const subtitleFontSize = 26.0;
    const subtitleLineHeight = 1.2;
    const subtitleLetterSpacing = -0.26;

    return Container(
      width: BattlePassEndedNotice._cardWidth,
      // Только тень — заливки/бордера здесь нет, кольцо рисует CustomPaint
      // ниже (отдельно от контента, см. комментарий выше).
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_outerRadius),
        boxShadow: [
          BoxShadow(
            color: colors.glowShadow,
            blurRadius: cardGlowBlurRadius,
            spreadRadius: cardGlowSpreadRadius,
          ),
        ],
      ),
      child: CustomPaint(
        foregroundPainter: _GradientBorderPainter(
          radius: _outerRadius,
          borderWidth: _borderWidth,
          borderColor: colors.glowGold,
          borderGradient: borderGradient,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_outerRadius - _borderWidth),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: sheenGradient),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(decoration: BoxDecoration(color: flatBg)),
              ),
              Padding(
                padding: AppPadding.ltrbPaddingL40T40R40B32,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppStrings.battlePassEndedTitle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: theme.appTypography.mobileTypo.h4.copyWith(
                          color: theme.appColors.mainColors.appColorWhite,
                        ),
                      ),
                    ),
                    AppSizedBoxes.verticalSizedBoxH4,
                    Text(
                      AppStrings.battlePassEndedSubtitle,
                      textAlign: TextAlign.center,
                      // Токена типографики для этого сочетания (500/26/1.2)
                      // в MobileTypo пока нет — оставлено как есть, только
                      // цвет взят из темы.
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        fontWeight: FontWeight.w500,
                        fontSize: subtitleFontSize,
                        height: subtitleLineHeight,
                        letterSpacing: subtitleLetterSpacing,
                        color: colors.timerText, // #E9E9F3 @ 0.4
                      ),
                    ),
                    AppSizedBoxes.verticalSizedBoxH28,
                    _TimerPill(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Рамка-кольцо шириной [borderWidth] вокруг скруглённого прямоугольника
/// (радиус [radius]) — рисуется через evenOdd-путь (внешний прямоугольник
/// минус внутренний), поэтому середина остаётся полностью непрокрашенной:
/// в отличие от Border.all + паддинг, ничего не подмешивается под
/// прозрачный интерьер карточки (см. комментарий в _Card.build).
/// Два слоя, как в Figma border-image: сплошной [borderColor] и поверх него
/// блик [borderGradient] через blend "overlay" — оба берутся из темы в
/// _Card.build (у CustomPainter нет своего BuildContext) — саveLayer
/// ограничивает блендинг только этим кольцом, не задним фоном.
class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.radius,
    required this.borderWidth,
    required this.borderColor,
    required this.borderGradient,
  });

  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Gradient borderGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Offset.zero & size;
    final outerRRect = RRect.fromRectAndRadius(outer, Radius.circular(radius));
    final inner = outer.deflate(borderWidth);
    final innerRadius = (radius - borderWidth).clamp(0.0, double.infinity);
    final innerRRect = RRect.fromRectAndRadius(
      inner,
      Radius.circular(innerRadius),
    );
    final ringPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(outerRRect)
      ..addRRect(innerRRect);

    canvas.saveLayer(outer, Paint());
    canvas.drawPath(ringPath, Paint()..color = borderColor);
    canvas.drawPath(
      ringPath,
      Paint()
        ..shader = borderGradient.createShader(outer)
        ..blendMode = BlendMode.overlay,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) =>
      radius != oldDelegate.radius ||
      borderWidth != oldDelegate.borderWidth ||
      borderColor != oldDelegate.borderColor ||
      borderGradient != oldDelegate.borderGradient;
}

class _TimerPill extends StatelessWidget {
  const _TimerPill();

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors.mainColors;

    const textFontSize = 30.0;
    const textLineHeight = 1.2;
    const textLetterSpacing = -0.3;

    // Тот же набор levelUpBorder*-стопов, что и у рамки карточки (см.
    // _Card.build), но всего 4 (без levelUpBorderLight) и по более пологой
    // диагонали — чип широкий и невысокий, полный 45°-угол давал слишком
    // заметный перепад по вертикали.
    final pillGradient = LinearGradient(
      begin: const Alignment(-1.0, -0.4),
      end: const Alignment(1.0, 0.4),
      colors: [
        colors.levelUpBorderOrange,
        colors.levelUpBorderYellow,
        colors.levelUpBorderAmber,
        colors.levelUpBorderCoral,
      ],
      stops: const [0.0, 0.28, 0.72, 1.0],
    );

    return Container(
      // 214 — ширина из Figma, но это минимум, а не жёсткий лимит: она
      // измерена под короткий пример ("6д 13ч 55м"), а реальный мок-дедлайн
      // (15д 12ч 42м) шире и при фиксированной ширине обрезался.
      constraints: const BoxConstraints(
        minWidth: AppSizes.horizontalSize214,
        minHeight: AppSizes.verticalSize52,
      ),
      padding: AppPadding.symmetricPaddingH28V8,
      decoration: BoxDecoration(
        gradient: pillGradient,
        borderRadius: AppRadius.circular60,
      ),
      // Токена типографики для этого сочетания (600/30/1.2) в MobileTypo
      // пока нет — оставлено как есть, только цвет взят из темы.
      child: EventCountdownText(
        style: TextStyle(
          fontFamily: 'Geologica',
          fontWeight: FontWeight.w600,
          fontSize: textFontSize,
          height: textLineHeight,
          letterSpacing: textLetterSpacing,
          color: colors.countdownPillText,
        ),
      ),
    );
  }
}
