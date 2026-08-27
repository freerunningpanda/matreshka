import 'package:flutter/material.dart';

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
    return Positioned(
      left: 346,
      bottom: 340,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
