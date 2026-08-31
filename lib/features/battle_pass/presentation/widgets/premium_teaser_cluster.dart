import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Блок из 3 премиум-наград в начале трека (узел "Frame 1539", id 1:1275) +
/// плашка "Получи все сразу!" (Premium_Awards_Stiker, id 1:1297) под ним.
/// Награды этого блока взять нельзя напрямую — плашка "продаёт" премиум:
/// тап переключает сценарий на "премиум куплен" (см. README про мок-покупку),
/// после чего блок пропадает — он не имеет смысла, когда премиум уже куплен.
/// Сами иконки кликабельны — можно выбрать (подсветить), какая из наград
/// интересна, ровно один элемент одновременно.
class PremiumTeaserCluster extends StatefulWidget {
  const PremiumTeaserCluster({
    required this.onUnlock,
    this.hidePremiumBadge = false,
    super.key,
  });

  final VoidCallback onUnlock;

  /// Значок короны (premium.svg) не показывается ни у одной из 3 наград
  /// блока — сама плитка (заливка, переход на покупку прокачки по тапу) не
  /// меняется. Только в сценарии "Конец наград (Не куплен премиум)" (см.
  /// battle_pass_screen.dart).
  final bool hidePremiumBadge;

  static const double width = 676;

  @override
  State<PremiumTeaserCluster> createState() => _PremiumTeaserClusterState();
}

class _PremiumTeaserClusterState extends State<PremiumTeaserCluster> {
  static const _assets = [
    AppAssets.imagePremiumTeaserBag,
    AppAssets.imagePremiumTeaserBracelet,
    AppAssets.imagePremiumTeaserFuel,
  ];
  static const _quantityLabels = [null, AppStrings.quantityLabelX2, null];
  static const _gradients = [
    AppColors.rewardTileGrayGradient,
    AppColors.rewardTileBlueGradient,
    AppColors.rewardTilePurpleGradient,
  ];

  static const _defaultSelectedIndex = 2;
  int _selectedIndex = _defaultSelectedIndex;

  @override
  Widget build(BuildContext context) {
    const tileStride = 216.0;
    const stickerLeft = 6.0;
    const stickerTop = 236.0;

    return SizedBox(
      width: PremiumTeaserCluster.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < _assets.length; i++)
            Positioned(
              left: i * tileStride,
              child: RewardCarouselTile(
                asset: _assets[i],
                quantityLabel: _quantityLabels[i],
                gradient: _gradients[i],
                badge: RewardBadgeKind.premium,
                showBadge: !widget.hidePremiumBadge,
                borderColor: _selectedIndex == i ? AppColors.textPrimary : null,
                onTap: () => setState(() => _selectedIndex = i),
              ),
            ),
          Positioned(
            left: stickerLeft,
            top: stickerTop,
            width: AppSizes.horizontalSize626,
            child: _UnlockSticker(onTap: widget.onUnlock),
          ),
        ],
      ),
    );
  }
}

class _UnlockSticker extends StatelessWidget {
  const _UnlockSticker({required this.onTap});

  final VoidCallback onTap;

  static const _stickerBgColor = Color(0x4CE29432); // rgba(226,148,50,0.3)
  static const _textShadowColor = Color(0xFFFF5C00);

  @override
  Widget build(BuildContext context) {
    const textFontSize = 30.0;
    const textLineHeight = 1.2;
    const textLetterSpacing = -1.0;
    const textShadowBlurRadius = 14.4;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSizes.verticalSize60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SkewedBox(
                width: AppSizes.horizontalSize626,
                height: AppSizes.verticalSize60,
                decoration: BoxDecoration(
                  color: _stickerBgColor,
                  borderRadius: AppRadius.circular20,
                ),
              ),
              Text(
                AppStrings.premiumTeaserUnlockAll,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w500,
                  fontSize: textFontSize,
                  height: textLineHeight,
                  letterSpacing: textLetterSpacing,
                  color: AppColors.accentGold,
                  shadows: [
                    Shadow(
                      color: _textShadowColor,
                      blurRadius: textShadowBlurRadius,
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
