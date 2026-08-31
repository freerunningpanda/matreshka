import 'package:flutter/material.dart';

import '../../../exports.dart';

/// [BaseTypography] отвечает за базовую типографику темы.
/// Типографика приложения, используемая в макетах.
abstract class BaseTypography<T extends BaseTypography<T>>
    extends ThemeExtension<T> {
  /// Создаёт экземпляр [BaseTypography].
  const BaseTypography({required this.mobileTypo});

  final MobileTypo mobileTypo;
}
