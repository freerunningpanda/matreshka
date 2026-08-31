import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Класс [AppTypography] содержит типографику приложения.
/// Все изменения в типографике производятся в этом классе.

class AppTypography extends BaseTypography<AppTypography> {
  /// Конструктор для типографики приложения
  AppTypography() : super(mobileTypo: _MobileTypo());

  @override
  ThemeExtension<AppTypography> copyWith() => AppTypography();

  @override
  ThemeExtension<AppTypography> lerp(
    covariant ThemeExtension<AppTypography>? other,
    double t,
  ) {
    if (other == null) return this;
    return AppTypography();
  }
}

class _MobileTypo extends MobileTypo {
  static const String _fontFamily = 'Geologica';

  _MobileTypo()
    : super(
        h4: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 36,
          height: 1.3,
          letterSpacing: -0.01,
        ),
        p4Reg: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 22,
          height: 1.2,
          letterSpacing: -0.01,
        ),
        p1Med: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 22,
          height: 1.2,
          letterSpacing: -0.01,
        ),
        p2Med: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 30,
          height: 1.2,
          letterSpacing: -0.01,
        ),
        p4Med: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 22,
          height: 1.2,
          letterSpacing: -0.01,
        ),
      );
}
