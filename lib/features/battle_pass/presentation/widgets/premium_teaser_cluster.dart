import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'reward_carousel_tile.dart';

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
    'assets/images/battle_pass/premium_teaser_bag.png',
    'assets/images/battle_pass/premium_teaser_bracelet.png',
    'assets/images/battle_pass/premium_teaser_fuel.png',
  ];
  static const _quantityLabels = [null, '×2', null];
  static const _gradients = [
    AppColors.rewardTileGrayGradient,
    AppColors.rewardTileBlueGradient,
    AppColors.rewardTilePurpleGradient,
  ];

  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PremiumTeaserCluster.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < _assets.length; i++)
            Positioned(
              left: i * 216,
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
            left: 6,
            top: 236,
            width: 626,
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

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SkewedBox(
                width: 626,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0x4CE29432), // rgba(226,148,50,0.3)
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              const Text(
                'Получи все сразу!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  height: 1.2,
                  letterSpacing: -1,
                  color: AppColors.accentGold,
                  shadows: [Shadow(color: Color(0xFFFF5C00), blurRadius: 14.4)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
