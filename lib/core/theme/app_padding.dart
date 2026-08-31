import 'package:flutter/widgets.dart';

/// Общие константы EdgeInsets — вместо разбросанных по проекту
/// `padding: const EdgeInsets.xxx(...)` с повторяющимися значениями.
///
/// Именование:
/// - horizontalPadding{N} — EdgeInsets.symmetric(horizontal: N)
/// - verticalPadding{N} — EdgeInsets.symmetric(vertical: N)
/// - symmetricPaddingH{H}V{V} — EdgeInsets.symmetric(horizontal: H, vertical: V)
/// - allPadding{N} — EdgeInsets.all(N)
/// - topPadding{N} / leftPadding{N} / rightPadding{N} / bottomPadding{N} —
///   EdgeInsets.only с ровно одной стороной
/// - onlyPadding{L?}{T?}{R?}{B?} — EdgeInsets.only с несколькими сторонами
///   (буква + значение только для заданных сторон)
/// - ltrbPadding{L}{T}{R}{B} — EdgeInsets.fromLTRB(L, T, R, B)
abstract final class AppPadding {
  // Горизонтальные (symmetric horizontal: N)
  static const horizontalPadding3 = EdgeInsets.symmetric(horizontal: 3);
  static const horizontalPadding8 = EdgeInsets.symmetric(horizontal: 8);
  static const horizontalPadding21 = EdgeInsets.symmetric(horizontal: 21);
  static const horizontalPadding30 = EdgeInsets.symmetric(horizontal: 30);
  static const horizontalPadding40 = EdgeInsets.symmetric(horizontal: 40);

  // Вертикальные (symmetric vertical: N)
  static const verticalPadding22 = EdgeInsets.symmetric(vertical: 22);

  // Обе оси сразу (symmetric horizontal: H, vertical: V)
  static const symmetricPaddingH24V22 = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 22,
  );
  static const symmetricPaddingH28V8 = EdgeInsets.symmetric(
    horizontal: 28,
    vertical: 8,
  );

  // Все стороны поровну (EdgeInsets.all(N))
  static const allPadding12 = EdgeInsets.all(12);
  static const allPadding24 = EdgeInsets.all(24);
  static const allPadding32 = EdgeInsets.all(32);

  // Одна сторона (EdgeInsets.only)
  static const topPadding28 = EdgeInsets.only(top: 28);
  static const topPadding46 = EdgeInsets.only(top: 46);

  // Несколько сторон (EdgeInsets.only)
  static const onlyPaddingL32T53 = EdgeInsets.only(left: 32, top: 53);
  static const onlyPaddingL125T27R80 = EdgeInsets.only(
    left: 125,
    top: 27,
    right: 80,
  );
  static const onlyPaddingL12R19 = EdgeInsets.only(left: 12, right: 19);

  // Все 4 стороны (EdgeInsets.fromLTRB)
  static const ltrbPaddingL40T44R40B20 = EdgeInsets.fromLTRB(40, 44, 40, 20);
  static const ltrbPaddingL36T20R36B23 = EdgeInsets.fromLTRB(36, 20, 36, 23);
  static const ltrbPaddingL40T40R40B32 = EdgeInsets.fromLTRB(40, 40, 40, 32);
}
