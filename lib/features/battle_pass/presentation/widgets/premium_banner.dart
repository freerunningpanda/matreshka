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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD9D9D9), Color(0xFF737373)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -85,
                left: 0,
                width: 334,
                height: 652,
                child: Image.asset(
                  premiumOwned
                      ? 'assets/images/battle_pass/premium_banner_unlocked_art.png'
                      : 'assets/images/battle_pass/premium_banner_locked_art.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
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
                        fontSize: 34,
                        height: 1.2,
                        letterSpacing: -0.34,
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
                        fontSize: 20,
                        height: 1.2,
                        letterSpacing: -0.2,
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
      ),
    );
  }
}
