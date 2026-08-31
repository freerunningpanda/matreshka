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
              left: 10,
              top: premiumOwned ? -74 : -169,
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
                  SizedBox(
                    width: 400,
                    child: Text(
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
                  ),
                  premiumOwned
                      // Кнопка компактная (по ширине содержимого), но
                      // прижата к левому краю баннера с отступом 32px —
                      // фиксированные left:125/right:80 у "Прокачать" тут не
                      // подходят (шире контент — вылезает за правый край,
                      // см. предыдущий оверфлоу), а центрирование по Column
                      // давало отступ ~67px вместо нужных 32.
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32, top: 53),
                            child: _UpgradeButton(
                              label: 'Повысить уровень',
                              icon: 'assets/icons/battle_pass/arrow_up.svg',
                              iconHeight: 32,
                              onPressed: onPressed,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 125,
                            top: 27,
                            right: 80,
                          ),
                          child: _UpgradeButton(
                            label: 'Прокачать',
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
  const _UpgradeButton({
    required this.label,
    required this.onPressed,
    this.icon = 'assets/icons/battle_pass/premium_icon.svg',
    this.iconHeight = 20,
  });

  final String label;
  final VoidCallback onPressed;
  final String icon;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 400,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 32),
                  SvgPicture.asset(icon, width: 27, height: iconHeight),
                  const SizedBox(width: 27),
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
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
