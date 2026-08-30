import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

/// Общий наклон (shear) для всех "боевых" элементов трека — плитки,
/// значок премиума, чип количества, рамка кнопки, стрелка. Иконки/текст
/// внутри остаются прямыми — это отдельный неповёрнутый слой поверх.
const double _skewAngle = -0.12;

/// Блок из 3 премиум-наград в начале трека (узел "Frame 1539", id 1:1275) +
/// плашка "Получи все сразу!" (Premium_Awards_Stiker, id 1:1297) под ним.
/// Награды этого блока взять нельзя напрямую — плашка "продаёт" премиум:
/// тап переключает сценарий на "премиум куплен" (см. README про мок-покупку),
/// после чего блок пропадает — он не имеет смысла, когда премиум уже куплен.
/// Сами иконки кликабельны — можно выбрать (подсветить), какая из наград
/// интересна, ровно один элемент одновременно.
class PremiumTeaserCluster extends StatefulWidget {
  const PremiumTeaserCluster({required this.onUnlock, super.key});

  final VoidCallback onUnlock;

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
              child: _PremiumTeaserTile(
                asset: _assets[i],
                quantityLabel: _quantityLabels[i],
                gradient: _gradients[i],
                selected: _selectedIndex == i,
                onTap: () => setState(() => _selectedIndex = i),
              ),
            ),
          Positioned(
            left: 670,
            top: 100,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/icons/battle_pass/arrow.svg',
                width: 12,
                height: 20,
              ),
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

/// Фоновая подложка, наклонённая через shear-transform — контент поверх неё
/// (иконки, текст) кладётся отдельным неповёрнутым слоем, а не внутрь этого
/// виджета, чтобы не наклонять его вместе с фоном.
class _SkewedBox extends StatelessWidget {
  const _SkewedBox({
    required this.width,
    required this.height,
    required this.decoration,
  });

  final double width;
  final double height;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.skewX(_skewAngle),
      child: Container(width: width, height: height, decoration: decoration),
    );
  }
}

class _PremiumTeaserTile extends StatelessWidget {
  const _PremiumTeaserTile({
    required this.asset,
    required this.onTap,
    required this.gradient,
    this.quantityLabel,
    this.selected = false,
  });

  final String asset;
  final VoidCallback onTap;
  final Gradient gradient;
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
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                child: _SkewedBox(
                  width: 200,
                  height: 184,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(30),
                    border: selected
                        ? Border.all(color: AppColors.textPrimary, width: 4)
                        : null,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 45,
            top: 44,
            width: 152,
            height: 152,
            child: IgnorePointer(
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
          ),
          const Positioned(
            left: 34,
            top: 34,
            child: IgnorePointer(child: _RewardSticker()),
          ),
          if (quantityLabel != null)
            Positioned(
              right: 48,
              bottom: 44,
              child: IgnorePointer(
                child: SizedBox(
                  width: 69,
                  height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const _SkewedBox(
                        width: 69,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(0x8C000000),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      Text(
                        quantityLabel!,
                        style: const TextStyle(
                          fontFamily: 'Geologica',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Значок "BP_Reward_Sticker" — наклонный жёлто-оранжевый квадрат с
/// premium.svg внутри, 55×50 (см. Figma-скрин с замером). Наклон общий
/// (тот же shear, что у плиток), крону поворачиваем вместе с фоном — на
/// референсе видно, что весь бейдж читается как единая наклонная деталь.
class _RewardSticker extends StatelessWidget {
  const _RewardSticker();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      height: 50,
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.skewX(_skewAngle),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: AppColors.itemTagGradient,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: SvgPicture.asset('assets/icons/battle_pass/premium.svg'),
          ),
        ),
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
              const _SkewedBox(
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
