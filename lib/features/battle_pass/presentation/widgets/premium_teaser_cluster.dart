import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Блок из 3 премиум-наград в начале трека (узел "Frame 1539", id 1:1275) +
/// плашка "Получи все сразу!" (Premium_Awards_Stiker, id 1:1297) под ним.
/// Награды этого блока взять нельзя напрямую — плашка "продаёт" премиум:
/// тап переключает сценарий на "премиум куплен" (см. README про мок-покупку),
/// после чего блок пропадает — он не имеет смысла, когда премиум уже куплен.
class PremiumTeaserCluster extends StatelessWidget {
  const PremiumTeaserCluster({required this.onUnlock, super.key});

  final VoidCallback onUnlock;

  static const double width = 646;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 0,
            child: _PremiumTeaserTile(
              asset: 'assets/images/battle_pass/premium_teaser_bag.png',
            ),
          ),
          const Positioned(
            left: 202,
            child: _PremiumTeaserTile(
              asset: 'assets/images/battle_pass/premium_teaser_bracelet.png',
              quantityLabel: '×2',
            ),
          ),
          const Positioned(
            left: 404,
            child: _PremiumTeaserTile(
              asset: 'assets/images/battle_pass/premium_teaser_fuel.png',
              selected: true,
            ),
          ),
          Positioned(
            left: 6,
            top: 248,
            width: 596,
            child: _UnlockSticker(onTap: onUnlock),
          ),
        ],
      ),
    );
  }
}

class _PremiumTeaserTile extends StatelessWidget {
  const _PremiumTeaserTile({
    required this.asset,
    this.quantityLabel,
    this.selected = false,
  });

  final String asset;
  final String? quantityLabel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 242,
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 21,
            top: 28,
            width: 200,
            height: 184,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.taskCardBodyBg,
                gradient: selected ? AppColors.levelUpBorderGradient : null,
                boxShadow: selected
                    ? const [
                        BoxShadow(
                          color: AppColors.glowShadow,
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              padding: selected ? const EdgeInsets.all(3) : EdgeInsets.zero,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: AppColors.taskCardBodyBg,
                ),
              ),
            ),
          ),
          Positioned(
            left: 45,
            top: 44,
            width: 152,
            height: 152,
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          Positioned(
            left: 47,
            top: 38,
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.itemTagGradientTop,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: AppColors.itemTagText,
                size: 22,
              ),
            ),
          ),
          if (quantityLabel != null)
            Positioned(
              right: 26,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  quantityLabel!,
                  style: const TextStyle(
                    fontFamily: 'Geologica',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0x4CE29432), // rgba(226,148,50,0.3)
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'Получи все сразу!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Geologica',
              fontWeight: FontWeight.w500,
              fontSize: 22,
              height: 1.2,
              letterSpacing: -0.22,
              color: AppColors.accentGold,
              shadows: [
                Shadow(color: Color(0xFFFF5C00), blurRadius: 14.4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
