import 'package:flutter/material.dart';

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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        foregroundColor: const Color(0xFF2D2D31),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      icon: Icon(
                        premiumOwned
                            ? Icons.arrow_upward
                            : Icons.workspace_premium,
                      ),
                      label: Text(
                        premiumOwned ? 'Повысить уровень' : 'Прокачать',
                        style: const TextStyle(
                          fontFamily: 'Geologica',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
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
