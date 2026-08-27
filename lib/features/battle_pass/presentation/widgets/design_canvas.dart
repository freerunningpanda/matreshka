import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_dimens.dart';

/// Оборачивает контент в фиксированный холст 2320×1080 (как в Figma) и
/// масштабирует его целиком под реальный экран, сохраняя пропорции макета —
/// внутри дети верстаются напрямую в координатах/размерах из Figma.
class DesignCanvas extends StatelessWidget {
  const DesignCanvas({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: AppDimens.designWidth / AppDimens.designHeight,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: AppDimens.designWidth,
            height: AppDimens.designHeight,
            child: child,
          ),
        ),
      ),
    );
  }
}
