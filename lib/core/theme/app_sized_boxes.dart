import 'package:flutter/widgets.dart';

/// Общие константы отступов-спейсеров — вместо разбросанных по проекту
/// SizedBox(height: N) / SizedBox(width: N) с повторяющимися значениями.
///
/// Именование: verticalSizedBoxH{N} — вертикальный отступ (SizedBox
/// высотой N), horizontalSizedBoxW{N} — горизонтальный (SizedBox
/// шириной N).
abstract final class AppSizedBoxes {
  static const verticalSizedBoxH4 = SizedBox(height: 4);
  static const verticalSizedBoxH8 = SizedBox(height: 8);
  static const verticalSizedBoxH10 = SizedBox(height: 10);
  static const verticalSizedBoxH12 = SizedBox(height: 12);
  static const verticalSizedBoxH20 = SizedBox(height: 20);
  static const verticalSizedBoxH28 = SizedBox(height: 28);
  static const verticalSizedBoxH34 = SizedBox(height: 34);
  static const verticalSizedBoxH50 = SizedBox(height: 50);

  static const horizontalSizedBoxW8 = SizedBox(width: 8);
  static const horizontalSizedBoxW10 = SizedBox(width: 10);
  static const horizontalSizedBoxW12 = SizedBox(width: 12);
  static const horizontalSizedBoxW14 = SizedBox(width: 14);
  static const horizontalSizedBoxW16 = SizedBox(width: 16);
  static const horizontalSizedBoxW18 = SizedBox(width: 18);
  static const horizontalSizedBoxW27 = SizedBox(width: 27);
  static const horizontalSizedBoxW32 = SizedBox(width: 32);
}
