import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_dimens.dart';

/// Оборачивает контент в фиксированный холст 2320×1080 (как в Figma) и
/// растягивает его на весь экран устройства — реальные экраны чуть отличаются
/// по пропорциям от макета, а `BoxFit.fill` вместо `contain` не оставляет
/// чёрных полей по краям (важнее заполнить экран, чем сохранить точное
/// соотношение сторон при разнице в пару процентов). Дети верстаются
/// напрямую в координатах/размерах из Figma.
class DesignCanvas extends StatelessWidget {
  const DesignCanvas({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: AppDimens.designWidth,
          height: AppDimens.designHeight,
          child: child,
        ),
      ),
    );
  }
}
