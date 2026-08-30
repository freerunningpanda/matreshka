import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

/// Общий наклон (shear) для всех "боевых" элементов трека — плитки,
/// значок награды, чип количества, рамка кнопки, стрелка. Иконки/текст
/// внутри остаются прямыми — это отдельный неповёрнутый слой поверх.
const double kRewardTileSkewAngle = -0.12;

/// Фоновая подложка, наклонённая через shear-transform — контент поверх неё
/// (иконки, текст) кладётся отдельным неповёрнутым слоем, а не внутрь этого
/// виджета, чтобы не наклонять его вместе с фоном.
class SkewedBox extends StatelessWidget {
  const SkewedBox({
    required this.width,
    required this.height,
    required this.decoration,
    super.key,
  });

  final double width;
  final double height;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.skewX(kRewardTileSkewAngle),
      child: Container(width: width, height: height, decoration: decoration),
    );
  }
}

/// Какой значок сидит в углу плитки: премиум-корона (награда доступна
/// только с прокачкой) или обычный подарок (награда бесплатная).
enum RewardBadgeKind { premium, gift }

/// Значок "BP_Reward_Sticker" — наклонный квадрат 55×50 с иконкой внутри
/// (см. Figma-скрин с замером). Наклон общий (тот же shear, что у плиток),
/// иконку поворачиваем вместе с фоном — на референсе видно, что весь бейдж
/// читается как единая наклонная деталь.
class RewardBadge extends StatelessWidget {
  const RewardBadge({this.kind = RewardBadgeKind.gift, super.key});

  final RewardBadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final premium = kind == RewardBadgeKind.premium;
    return SizedBox(
      width: 55,
      height: 50,
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.skewX(kRewardTileSkewAngle),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: premium ? AppColors.itemTagGradient : null,
              color: premium ? null : AppColors.buttonOverlayStrong,
              borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            child: SvgPicture.asset(
              premium
                  ? 'assets/icons/battle_pass/premium.svg'
                  : 'assets/icons/battle_pass/gift.svg',
            ),
          ),
        ),
      ),
    );
  }
}

/// Плитка одной награды трека — переиспользуется и тизером премиума
/// (`PremiumTeaserCluster`), и обычными уровнями (`RewardTile`): везде одна
/// и та же наклонная карточка с картинкой, бейджем и чипом количества.
class RewardCarouselTile extends StatelessWidget {
  const RewardCarouselTile({
    required this.asset,
    required this.gradient,
    this.badge = RewardBadgeKind.gift,
    this.quantityLabel,
    this.borderColor,
    this.claimed = false,
    this.locked = false,
    this.onTap,
    this.footer,
    this.width = 242,
    this.height = 240,
    super.key,
  });

  final String asset;
  final Gradient gradient;
  final RewardBadgeKind badge;
  final String? quantityLabel;
  final Color? borderColor;
  final bool claimed;
  final bool locked;
  final VoidCallback? onTap;

  /// Плашка "Забрать" на нижнем крае карточки — рисуется только когда
  /// награду реально можно взять. Чисто декоративная (`IgnorePointer`):
  /// тап по ней должен попадать на тот же `InkWell`, что и по всей карточке,
  /// а не перехватываться отдельно.
  final Widget? footer;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width - 42;
    final cardHeight = height - 56;
    final content = Opacity(
      opacity: claimed || locked ? 0.5 : 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 21,
            top: 28,
            width: cardWidth,
            height: cardHeight,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.skewX(kRewardTileSkewAngle),
                  // Рамка и подсветка появляются по тапу (выбор для клейма) —
                  // AnimatedContainer вместо обычного, чтобы они плавно
                  // проступали, а не выскакивали внезапно (раньше из-за
                  // мгновенного boxShadow плитка визуально "выпрыгивала").
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(24),
                      border: borderColor != null
                          ? Border.all(color: borderColor!, width: 4)
                          : null,
                      // "Backlight_BP_Card" из Figma — мягкое свечение вокруг
                      // выбранной для получения плитки, того же цвета, что
                      // рамка.
                      boxShadow: borderColor != null
                          ? [
                              BoxShadow(
                                color: borderColor!.withValues(alpha: 0.6),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 45,
            top: 44,
            width: cardWidth - 48,
            height: cardHeight - 32,
            child: IgnorePointer(
              child: locked
                  ? const Center(
                      child: Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    )
                  : Image.asset(asset, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            left: 34,
            top: 34,
            child: IgnorePointer(child: RewardBadge(kind: badge)),
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
                      const SkewedBox(
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
                          fontSize: 26,
                          height: 1.2,
                          letterSpacing: -0.01,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Builder(
            builder: (context) {
              const margin = 8.0;
              const footerHeight = 48.0;
              final footerTop = 28 + cardHeight - margin - footerHeight;
              // Наклоняем плашку footer вокруг того же центра, что и сама
              // карточка (28 + cardHeight/2), а не вокруг своего — иначе
              // при независимом наклоне вокруг собственного (более
              // высокого, раз плашка ниже и у́же карточки) центра сдвиг
              // получается меньше, чем у карточки на той же высоте, и
              // плашка вылезает за скошенный край.
              final origin = Offset(0, 28 + cardHeight / 2 - footerTop);
              final visible = footer != null;
              return Positioned(
                left: 21 + margin,
                width: cardWidth - margin * 2,
                top: footerTop,
                height: footerHeight,
                child: IgnorePointer(
                  child: Transform(
                    origin: origin,
                    transform: Matrix4.skewX(kRewardTileSkewAngle),
                    // Плашка не выскакивает мгновенно, а плавно проступает
                    // и подрастает вместе с рамкой/подсветкой карточки —
                    // держим её виджет в дереве и просто гасим/масштабируем,
                    // а не добавляем/убираем условно (иначе анимировать
                    // нечего, виджет появляется/исчезает мгновенно).
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      scale: visible ? 1 : 0.85,
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: visible ? 1 : 0,
                        child: footer ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    // Выбранная для клейма плитка визуально подрастает целиком (картинка,
    // бейдж, рамка — всё вместе), а не только рамка/подсветка сами по себе:
    // Transform.scale не меняет раскладку соседей, поэтому нарочно перекрывает
    // их — так и задумано (см. референс из Figma).
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      scale: borderColor != null ? 1.12 : 1,
      child: SizedBox(
        width: width,
        height: height,
        child: claimed
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  content,
                  const Positioned(
                    right: 24,
                    top: 44,
                    child: IgnorePointer(child: _ClaimedBadge()),
                  ),
                ],
              )
            : content,
      ),
    );
  }
}

/// Зелёная галочка "уже забрано" — верхний правый угол, без своей подложки
/// (см. предоставленный done.svg): поверх наполовину прозрачной плитки.
class _ClaimedBadge extends StatelessWidget {
  const _ClaimedBadge();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/battle_pass/done.svg',
      width: 34,
      height: 18,
    );
  }
}
