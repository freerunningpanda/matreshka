import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sized_boxes.dart';
import 'event_countdown.dart';

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
    return Positioned(
      left: 346,
      top: _stickerTop,
      width: _cardWidth,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: _stickerHeight / 2),
            child: _Card(),
          ),
          Positioned(
            top: -8,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.glowShadow,
                    blurRadius: 40,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/icons/battle_pass/sticker_big.svg',
              ),
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

  // background (Figma): сплошной rgba(117,83,27,0.6) поверх диагонального
  // блика rgba(200,166,111,·) с прозрачными краями — два слоя, а не один
  // цвет, поэтому рисуются отдельными DecoratedBox друг на друге, а не
  // одним BoxDecoration (color и gradient в нём взаимно исключают друг
  // друга).
  static const _flatBg = Color(0x9975531B); // rgba(117,83,27,0.6)
  static const _sheenGradient = LinearGradient(
    begin: Alignment(-0.99, -0.14), // ≈ 97.91deg
    end: Alignment(0.99, 0.14),
    stops: [0.0, 0.5745, 0.7907, 0.9241, 1.0],
    colors: [
      Color(0x00C8A66F),
      Color(0x00C8A66F),
      Color(0x4DC8A66F), // rgba(200,166,111,0.3)
      Color(0x00C8A66F),
      Color(0x00C8A66F),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Рамка (Figma border-image) — 4px кольцо, а не Border.all одним цветом:
    // спецификация даёт два слоя — сплошной #FFB41C (AppColors.glowGold) и
    // поверх него блик levelUpBorderGradient через blend "overlay" (тот же
    // приём, что у золотой кнопки в premium_banner.dart). Обычный
    // "заливка + паддинг вместо бордера" здесь не подходит: интерьер сделан
    // прозрачным намеренно (см. _flatBg/_sheenGradient), и его прозрачные
    // слои просвечивали бы не сквозь карточку до фона экрана, а до этой
    // золотой заливки под ними. Поэтому кольцо рисуется отдельно поверх
    // контента через CustomPaint — так оно не участвует в фоне интерьера.
    return Container(
      width: BattlePassEndedNotice._cardWidth,
      // Только тень — заливки/бордера здесь нет, кольцо рисует CustomPaint
      // ниже (отдельно от контента, см. комментарий выше).
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_outerRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glowShadow,
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomPaint(
        foregroundPainter: _GradientBorderPainter(
          radius: _outerRadius,
          borderWidth: _borderWidth,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_outerRadius - _borderWidth),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: _sheenGradient),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(decoration: BoxDecoration(color: _flatBg)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(40, 40, 40, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Battle Pass завершен',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Geologica',
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                          height: 1.3,
                          letterSpacing: -0.36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    AppSizedBoxes.verticalSizedBoxH4,
                    Text(
                      'Успей забрать оставшиеся награды!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                        height: 1.2,
                        letterSpacing: -0.26,
                        color: AppColors.timerText, // #E9E9F3 @ 0.4
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
/// Два слоя, как в Figma border-image: сплошной AppColors.glowGold и поверх
/// него блик AppColors.levelUpBorderGradient через blend "overlay" —
/// саveLayer ограничивает блендинг только этим кольцом, не задним фоном.
class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.radius,
    required this.borderWidth,
  });

  final double radius;
  final double borderWidth;

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
    canvas.drawPath(ringPath, Paint()..color = AppColors.glowGold);
    canvas.drawPath(
      ringPath,
      Paint()
        ..shader = AppColors.levelUpBorderGradient.createShader(outer)
        ..blendMode = BlendMode.overlay,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) =>
      radius != oldDelegate.radius || borderWidth != oldDelegate.borderWidth;
}

class _TimerPill extends StatelessWidget {
  const _TimerPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      // 214 — ширина из Figma, но это минимум, а не жёсткий лимит: она
      // измерена под короткий пример ("6д 13ч 55м"), а реальный мок-дедлайн
      // (15д 12ч 42м) шире и при фиксированной ширине обрезался.
      constraints: const BoxConstraints(minWidth: 214, minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppColors.countdownPillGradient,
        borderRadius: BorderRadius.circular(60),
      ),
      child: const EventCountdownText(
        style: TextStyle(
          fontFamily: 'Geologica',
          fontWeight: FontWeight.w600,
          fontSize: 30,
          height: 1.2,
          letterSpacing: -0.3,
          color: AppColors.countdownPillText,
        ),
      ),
    );
  }
}
