import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

/// Карточка премиума в правом верхнем углу — две вариации: апсейл (премиум
/// не куплен) и "повышение уровня" (премиум куплен). Фоновая иллюстрация —
/// картинка из макета (Group 611), заголовок/описание/кнопка — живые виджеты.
class PremiumBanner extends StatelessWidget {
  const PremiumBanner({
    required this.premiumOwned,
    required this.onPressed,
    this.maxLevelReached = false,
    super.key,
  });

  final bool premiumOwned;
  final VoidCallback onPressed;

  /// Уровень уже максимальный — "Повысить уровень" нечего делать: вместо
  /// золотой кнопки показывается неактивная плашка "Достигнут максимальный
  /// уровень" без тапа.
  final bool maxLevelReached;

  static const double width = 605;
  static const double height = 690;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    const bannerRight = 24.0;
    const bannerTop = 0.0;
    const artLeftUnlocked = -50.0;
    const artLeftLocked = 20.0;
    const artTopUnlocked = -278.0;
    const artTopLocked = -169.0;
    const contentLeft = 32.0;
    const contentRight = 32.0;
    const contentBottom = 40.0;
    const upgradeButtonIconHeight = 32.0;

    return Positioned(
      right: bannerRight,
      top: bannerTop,
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            // Group 611 (id 1:1252) в макете шире и намного выше самой карточки
            // и обрезается по её границам — намеренный портретный bleed, а не
            // изображение, вписанное в карточку.
            Positioned(
              left: premiumOwned ? artLeftUnlocked : artLeftLocked,
              top: premiumOwned ? artTopUnlocked : artTopLocked,
              width: AppSizes.horizontalSize668,
              height: AppSizes.verticalSize1304,
              child: Image.asset(
                premiumOwned
                    ? AppAssets.imagePremiumBannerUnlockedArt
                    : AppAssets.imagePremiumBannerLockedArt,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: contentLeft,
              right: contentRight,
              bottom: contentBottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    premiumOwned
                        ? AppStrings.premiumBannerTitleLevelUp
                        : AppStrings.premiumBannerTitleUnlock,
                    textAlign: TextAlign.center,
                    style: theme.appTypography.mobileTypo.h4.copyWith(
                      color: colors.accentGold,
                    ),
                  ),
                  AppSizedBoxes.verticalSizedBoxH10,
                  SizedBox(
                    width: AppSizes.horizontalSize400,
                    child: Text(
                      premiumOwned
                          ? AppStrings.premiumBannerSubtitleLevelUp
                          : AppStrings.premiumBannerSubtitleUnlock,
                      textAlign: TextAlign.center,
                      style: theme.appTypography.mobileTypo.p1Med.copyWith(
                        color: colors.textSecondary,
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
                            padding: AppPadding.onlyPaddingL32T53,
                            child: maxLevelReached
                                ? const _MaxLevelReachedNotice()
                                : _UpgradeButton(
                                    label: AppStrings.increaseLevelButton,
                                    icon: AppAssets.iconArrowUp,
                                    iconHeight: upgradeButtonIconHeight,
                                    onPressed: onPressed,
                                  ),
                          ),
                        )
                      : Padding(
                          padding: AppPadding.onlyPaddingL125T27R80,
                          child: _UpgradeButton(
                            label: AppStrings.unlockPremiumButton,
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

/// Неактивная плашка вместо "Повысить уровень", когда повышать уже некуда —
/// без градиента/иконки/тапа, только приглушённый текст на стеклянном фоне.
class _MaxLevelReachedNotice extends StatelessWidget {
  const _MaxLevelReachedNotice();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    return Container(
      width: AppSizes.horizontalSize400,
      alignment: Alignment.center,
      padding: AppPadding.symmetricPaddingH24V22,
      decoration: BoxDecoration(
        color: colors.buttonOverlayStrong, // #E9E9F3 @ 0.1
        borderRadius: AppRadius.circular30,
      ),
      child: Text(
        AppStrings.maxLevelReachedNotice,
        textAlign: TextAlign.center,
        style: theme.appTypography.mobileTypo.p1Med.copyWith(
          color: colors.progressRingFill, // = textMuted
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
    this.icon = AppAssets.iconPremiumIcon,
    this.iconHeight = 20,
  });

  final String label;
  final VoidCallback onPressed;
  final String icon;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    const glowBlurRadius = 40.0;
    const glowSpreadRadius = 4.0;

    final itemTagGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [colors.itemTagGradientTop, colors.itemTagGradientBottom],
    );
    // Глянцевый блик поверх золотой кнопки (Rectangle 64755, blend "overlay").
    final buttonShineGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      colors: [
        colors.buttonShineStart,
        colors.buttonShineSoft,
        colors.buttonShineCore,
        colors.buttonShineFade,
        colors.buttonShineEnd,
      ],
    );

    return Container(
      height: AppSizes.verticalSize100,
      width: AppSizes.horizontalSize400,
      decoration: BoxDecoration(
        borderRadius: AppRadius.circular30,
        boxShadow: [
          BoxShadow(
            color: colors.glowShadow,
            blurRadius: glowBlurRadius,
            spreadRadius: glowSpreadRadius,
          ),
        ],
      ),
      child: Material(
        color: colors.appColorTransparent,
        borderRadius: AppRadius.circular30,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(gradient: itemTagGradient),
          child: InkWell(
            onTap: onPressed,
            child: Ink(
              decoration: BoxDecoration(
                gradient: buttonShineGradient,
                backgroundBlendMode: BlendMode.overlay,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSizedBoxes.horizontalSizedBoxW32,
                  SvgPicture.asset(
                    icon,
                    width: AppSizes.horizontalSize27,
                    height: iconHeight,
                  ),
                  AppSizedBoxes.horizontalSizedBoxW27,
                  Text(
                    label,
                    style: theme.appTypography.mobileTypo.medium30.copyWith(
                      color: colors.itemTagText,
                    ),
                  ),
                  AppSizedBoxes.horizontalSizedBoxW32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
