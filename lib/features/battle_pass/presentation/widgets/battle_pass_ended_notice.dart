import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import 'event_countdown.dart';

/// Заменяет карточку заданий в сценарии "Battle Pass завершен" (см.
/// battle_pass_screen.dart) — раздавать/выполнять задания уже нечего,
/// вместо этого итоговое сообщение с обратным отсчётом, синхронизированным
/// с EventTimerBanner (общий eventCountdownDeadline).
class BattlePassEndedNotice extends StatelessWidget {
  const BattlePassEndedNotice({super.key});

  static const double _cardWidth = 466;
  static const double _stickerWidth = 64;
  static const double _stickerHeight = 68;

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
          SvgPicture.asset(
            'assets/icons/battle_pass/sticker_new.svg',
            width: _stickerWidth,
            height: _stickerHeight,
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
    // Рамка (Figma border-image): сплошной #FFB41C (AppColors.glowGold) с
    // глянцевым бликом поверх (тот же levelUpBorderGradient, что и у самого
    // sticker_new.svg) через blend "overlay" — тот же приём, что и у
    // золотой кнопки в premium_banner.dart (_UpgradeButton).
    return Container(
      width: BattlePassEndedNotice._cardWidth,
      decoration: BoxDecoration(
        color: AppColors.glowGold,
        borderRadius: BorderRadius.circular(_outerRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glowShadow,
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.levelUpBorderGradient,
          backgroundBlendMode: BlendMode.overlay,
        ),
        padding: const EdgeInsets.all(_borderWidth),
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
                    Text(
                      'Battle Pass завершен',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        height: 1.3,
                        letterSpacing: -0.36,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 28),
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
                    SizedBox(height: 28),
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

class _TimerPill extends StatelessWidget {
  const _TimerPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      // 214 — ширина из Figma, но это минимум, а не жёсткий лимит: она
      // измерена под короткий пример ("6д 13ч 55м"), а реальный мок-дедлайн
      // (15д 12ч 42м) шире и при фиксированной ширине обрезался.
      constraints: const BoxConstraints(minWidth: 214, minHeight: 52),
      alignment: Alignment.center,
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
