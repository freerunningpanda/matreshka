import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

/// Карточка премиума в правом верхнем углу — две вариации: апсейл (премиум
/// не куплен) и "повышение уровня" (премиум куплен). Фоновая иллюстрация —
/// картинка из макета (Group 611), заголовок/описание/кнопка — живые виджеты.
class PremiumBanner extends StatelessWidget {
  const PremiumBanner({
    required this.premiumOwned,
    required this.onPressed,
    super.key,
  });

  final bool premiumOwned;
  final VoidCallback onPressed;

  static const double _width = 605;
  static const double _height = 690;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      top: 0,
      width: _width,
      height: _height,
      child: ClipRect(
        child: Stack(
          children: [
            // Group 611 (id 1:1252) в макете шире и намного выше самой карточки
            // и обрезается по её границам — намеренный портретный bleed, а не
            // изображение, вписанное в карточку.
            Positioned(
              left: 0,
              top: -169,
              width: 668,
              height: 1304,
              child: Image.asset(
                premiumOwned
                    ? 'assets/images/battle_pass/premium_banner_unlocked_art.png'
                    : 'assets/images/battle_pass/premium_banner_locked_art.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 32,
              right: 32,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    premiumOwned ? 'Повышение уровня' : 'Элитный пропуск',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                      height: 1.3,
                      letterSpacing: -0.36,
                      color: AppColors.accentGold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    premiumOwned
                        ? 'Повышай уровень боевого пропуска и забирай новые награды!'
                        : 'Прокачай боевой пропуск и забери чёткие скины, аксессуары и многое другое!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      height: 1.2,
                      letterSpacing: -0.22,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 125,
                      top: 27,
                      right: 80,
                    ),
                    child: _UpgradeButton(
                      label: premiumOwned ? 'Повысить уровень' : 'Прокачать',
                      onPressed: onPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Золотая кнопка с глянцевым бликом (Rectangle 64755, blend "overlay").
class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glowShadow,
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(gradient: AppColors.itemTagGradient),
          child: InkWell(
            onTap: onPressed,
            child: Ink(
              decoration: const BoxDecoration(
                gradient: AppColors.buttonShineGradient,
                backgroundBlendMode: BlendMode.overlay,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/battle_pass/premium.svg',
                    width: 27,
                    height: 20,
                  ),
                  const SizedBox(width: 24),
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      height: 1.2,
                      letterSpacing: -0.3,
                      color: AppColors.itemTagText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
