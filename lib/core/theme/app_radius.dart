import 'package:flutter/widgets.dart';

/// Скругления углов (BorderRadius/Radius) presentation-слоя
/// (features/**/presentation) — вместо разбросанных по коду литералов вида
/// `BorderRadius.circular(30)` / `Radius.circular(30)`.
///
/// Именование: circular{N} — готовый BorderRadius.circular(N) (для
/// `borderRadius: ...` со скруглением со всех сторон поровну — заменяет и
/// `BorderRadius.circular(N)`, и эквивалентный ему `BorderRadius.all(
/// Radius.circular(N))`); radius{N} — отдельный Radius.circular(N) для
/// `BorderRadius.only(...)`, когда скруглены не все углы.
abstract final class AppRadius {
  static const circular4 = BorderRadius.all(Radius.circular(4));
  static const circular6 = BorderRadius.all(Radius.circular(6));
  static const circular8 = BorderRadius.all(Radius.circular(8));
  static const circular14 = BorderRadius.all(Radius.circular(14));
  static const circular20 = BorderRadius.all(Radius.circular(20));
  static const circular24 = BorderRadius.all(Radius.circular(24));
  static const circular30 = BorderRadius.all(Radius.circular(30));
  static const circular60 = BorderRadius.all(Radius.circular(60));

  static const radius30 = Radius.circular(30);
}
