import 'package:flutter/material.dart';

/// [MobileTypo] включает базовую типографику для мобильных устройств.
abstract class MobileTypo {
  /// Создаёт экземпляр [MobileTypo].
  const MobileTypo({
    required this.h4,
    required this.p4Reg,
    required this.p1Med,
    required this.p2Med,
    required this.p4Med,
  });

  /// Заголовок уровня 4.
  final TextStyle h4;

  /// Параграф уровня 4, обычный.
  final TextStyle p4Reg;

  /// Параграф уровня 1, полужирный.
  final TextStyle p1Med;

  /// Параграф уровня 2, полужирный.
  final TextStyle p2Med;

  /// Параграф уровня 4, полужирный.
  final TextStyle p4Med;
}
