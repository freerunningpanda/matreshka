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
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            width: 400,
            alignment: Alignment.center,
            padding: AppPadding.verticalPadding22,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Geologica',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
