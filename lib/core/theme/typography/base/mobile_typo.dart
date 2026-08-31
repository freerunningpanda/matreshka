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
    required this.bold14,
    required this.semibold24,
    required this.medium26,
    required this.semibold26,
    required this.medium26Tall,
    required this.medium30,
    required this.semibold30,
    required this.medium30Tight,
    required this.semibold42,
    required this.semibold48,
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

  /// 14px, 700 — номер уровня в ромбе трека наград.
  final TextStyle bold14;

  /// 24px, 600 — лейбл кнопки "Забрать все награды".
  final TextStyle semibold24;

  /// 26px, 500, line-height 1.2 — самый частый размер текста карточек
  /// (задания, наградные плашки, кнопки).
  final TextStyle medium26;

  /// 26px, 600, line-height 1.2 — количество награды на плитке карусели.
  final TextStyle semibold26;

  /// 26px, 500, line-height 1.35 — текст карточки "следующий сезон".
  final TextStyle medium26Tall;

  /// 30px, 500, line-height 1.2 — кнопка "Прокачать" в баннере премиума.
  final TextStyle medium30;

  /// 30px, 600, line-height 1.2 — таймер в плашке "Battle Pass завершён".
  final TextStyle semibold30;

  /// 30px, 500, line-height 1.2, увеличенный отрицательный трекинг — текст
  /// плашки "Получи всё сразу!" премиум-тизера.
  final TextStyle medium30Tight;

  /// 42px, 600, line-height 1.3 — номер текущего уровня в кольце прогресса.
  final TextStyle semibold42;

  /// 48px, 600, line-height 0.93 — заголовок ивента.
  final TextStyle semibold48;
}
