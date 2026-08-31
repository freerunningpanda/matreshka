import 'package:flutter/material.dart';

/// Расширение для [BuildContext].
extension BuildContextExtension on BuildContext {
  /// Возвращает [ThemeData] из текущего контекста.
  ThemeData get theme => Theme.of(this);
}
