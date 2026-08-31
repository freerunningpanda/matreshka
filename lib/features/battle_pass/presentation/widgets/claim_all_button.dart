import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Кнопка "Забрать все награды" — зелёный градиент (есть что забрать) или
/// фиолетовый (апсейл премиума), см. AppColors.claim*Gradient из макета.
class ClaimAllButton extends StatelessWidget {
  const ClaimAllButton({
    required this.label,
    required this.gradient,
    required this.onPressed,
    super.key,
  });

  final String label;
  final LinearGradient gradient;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors.mainColors;

    const labelFontSize = 24.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppRadius.circular30,
      ),
      child: Material(
        color: colors.appColorTransparent,
        child: InkWell(
          borderRadius: AppRadius.circular30,
          onTap: onPressed,
          child: Container(
            width: AppSizes.horizontalSize400,
            alignment: Alignment.center,
            padding: AppPadding.verticalPadding22,
            child: Text(
              label,
              textAlign: TextAlign.center,
              // Токена типографики для этого сочетания (600/24) в MobileTypo
              // пока нет — оставлено как есть, только цвет взят из темы.
              style: TextStyle(
                fontFamily: 'Geologica',
                fontWeight: FontWeight.w600,
                fontSize: labelFontSize,
                color: colors.appColorWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
