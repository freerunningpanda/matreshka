import 'package:flutter/material.dart';

import '../../exports.dart';

/// [BaseColors] отвечает за базовые цвета темы.
/// Цвета приложения, используемые в макетах.
abstract class BaseColors<T extends BaseColors<T>> extends ThemeExtension<T> {
  /// Создаёт экземпляр [BaseColors].
  const BaseColors({required this.mainColors});

  /// Главные цвета.
  final MainColors mainColors;
}
