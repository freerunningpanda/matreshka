import 'package:flutter/material.dart';

import '../exports.dart';
import 'exports.dart';

/// Класс [AppTheme] содержит основную тему приложения, которая объединяет в
/// себе цветовую тему и типографику. Все изменения в теме приложения
/// производятся в этом классе.

class AppTheme {
  /// Создаёт экземпляр [AppTheme].
  const AppTheme({required this.appColors, required this.appTypography});

  /// Цвета темы.
  final AppColors appColors;

  /// Типографика приложения.
  final AppTypography appTypography;

  static final AppColors _themeColors = sl<AppColors>();
  static final AppTypography _appTypography = sl<AppTypography>();

  static ThemeData get appTheme => ThemeData.light().copyWith(
    scaffoldBackgroundColor: _themeColors.mainColors.screenBackground,
    extensions: [_themeColors, _appTypography],
  );
}

/// Расширение для [ThemeData], которое позволяет получить цветовую тему.
extension AppThemeExtension on ThemeData {
  /// Возвращает цветовую тему приложения.
  BaseColors get appColors => extension<AppColors>() ?? AppTheme._themeColors;
}

/// Расширение для [ThemeData], которое позволяет получить типографику.
extension AppTypographyExtension on ThemeData {
  /// Возвращает типографику приложения.
  AppTypography get appTypography =>
      extension<AppTypography>() ?? AppTheme._appTypography;
}
