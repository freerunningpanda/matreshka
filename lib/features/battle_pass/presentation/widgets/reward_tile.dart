import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/level.dart';
import '../../domain/entities/reward.dart';
import 'reward_carousel_tile.dart';

class RewardTile extends StatefulWidget {
  const RewardTile({
    required this.level,
    required this.premiumOwned,
    required this.currentXp,
    required this.onClaim,
    required this.onUnlockPremium,
    this.nextReached,
    super.key,
  });

  final BattlePassLevel level;
  final bool premiumOwned;

  /// Достигнут ли следующий по порядку уровень — красит правую половину
  /// соединительной линии под этим уровнем (левая красится по себе самому).
  /// `null` для последнего уровня трека — линии дальше некуда идти.
  final bool? nextReached;

  /// Накопленный опыт сезона — нужен, чтобы на тапе по своему текущему
  /// уровню показать реальную нехватку XP, а не общую фразу (иначе не
  /// понятно, почему уровень, на который "уже дошли", ещё не открывается).
  final int currentXp;

  final VoidCallback onClaim;
  final VoidCallback onUnlockPremium;

  @override
  State<RewardTile> createState() => _RewardTileState();
}

class _RewardTileState extends State<RewardTile> {
  /// Обычная (не премиум) доступная награда изначально выглядит как ещё не
  /// открытая — рамка и кнопка "Забрать" появляются только после первого
  /// тапа, а забирает уже второй.
  bool _selected = false;

  @override
  void didUpdateWidget(covariant RewardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level.state != widget.level.state) {
      _selected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    final reward = level.freeReward;
    final locked = level.state == LevelState.locked;
    final claimable = level.state == LevelState.claimable;
    final claimed = level.state == LevelState.claimed;
    final showPremiumBadge =
        level.premiumReward != null &&
        !widget.premiumOwned &&
        level.premiumReward?.claimed != true;
    // Корона всегда перевешивает: даже если бесплатная награда сама по себе
    // claimable, плитку с премиум-апгрейдом нельзя "забрать в два тапа" —
    // тап по ней должен вести к покупке прокачки, а не показывать "Забрать".
    final showClaimUi = claimable && _selected && !showPremiumBadge;

    final tile = RewardCarouselTile(
      asset: reward?.iconAsset ?? _placeholderAsset,
      // Уровни с доступным премиум-апгрейдом всегда красим в фиолетовый —
      // тот же цвет, что у fuel в премиум-тизере, это общий язык "тут премиум".
      gradient: showPremiumBadge
          ? AppColors.rewardTilePurpleGradient
          : _rarityGradient(reward?.rarity),
      badge: showPremiumBadge ? RewardBadgeKind.premium : RewardBadgeKind.gift,
      quantityLabel: (reward != null && reward.amount > 1)
          ? '×${reward.amount}'
          : null,
      borderColor: showClaimUi ? const Color(0xFF3DDC6B) : null,
      claimed: claimed,
      locked: locked,
      // Плитка всегда кликабельна. Доступная бесплатная награда открывается
      // в два тапа: первый показывает рамку и кнопку "Забрать", второй —
      // уже забирает; премиум-плитка сразу ведёт к покупке прокачки, но
      // только если уровень уже достигнут — запертый уровень (не дошли по
      // XP) остаётся запертым независимо от короны, ведёт к покупке прокачки
      // нельзя раньше, чем сам уровень открылся.
      onTap: locked
          ? () => _showTapHint(
              context,
              locked: true,
              claimed: false,
              requiredXp: level.requiredXp,
            )
          : showPremiumBadge
          ? widget.onUnlockPremium
          : claimable
          ? (_selected
                ? widget.onClaim
                : () => setState(() => _selected = true))
          : () => _showTapHint(
              context,
              locked: locked,
              claimed: claimed,
              requiredXp: level.requiredXp,
            ),
      footer: showClaimUi ? const _ClaimButton() : null,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile,
        const SizedBox(height: 12),
        _LevelTrackNode(
          number: level.number,
          reached: !locked,
          nextReached: widget.nextReached,
          showIncomingLine: level.number != 1,
        ),
      ],
    );
  }

  void _showTapHint(
    BuildContext context, {
    required bool locked,
    required bool claimed,
    required int requiredXp,
  }) {
    final missingXp = requiredXp - widget.currentXp;
    final message = locked
        ? 'Откроется на ${widget.level.number} уровне'
        : claimed
        ? 'Уже получено'
        : 'Наберите ещё $missingXp XP, чтобы открыть';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static const _placeholderAsset =
      'assets/images/battle_pass/reward_placeholder.png';

  Gradient _rarityGradient(RewardRarity? rarity) => switch (rarity) {
    RewardRarity.legendary => AppColors.rewardTileGoldGradient,
    RewardRarity.epic => AppColors.rewardTilePurpleGradient,
    RewardRarity.rare => AppColors.rewardTileBlueGradient,
    RewardRarity.common || null => AppColors.rewardTileGrayGradient,
  };
}

/// Плашка "Забрать" на нижнем крае карточки — единственный визуальный
/// признак того, что награду реально можно взять тапом; без неё плитка
/// (значок подарка/премиума сам по себе) некликабельна.
class _ClaimButton extends StatelessWidget {
  const _ClaimButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF3DDC6B),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: const Text(
        'Забрать',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Geologica',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Ромб уровня + соединительная линия трека под плиткой. Линия рисуется
/// внутри самого узла (а не отдельным виджетом между плитками), чтобы не
/// зависеть от точной ширины разделителя между ними: левая половина красится
/// по этому же уровню, правая — по следующему, поэтому цвет на границе
/// "достигнуто / не достигнуто" плавно переходит от красного к серому.
/// Каждая половина заходит за границу плитки (`_overflow`) и перекрывается
/// с такой же половиной соседнего узла — так линия остаётся сплошной, даже
/// не зная точную ширину разделителя между плитками.
class _LevelTrackNode extends StatelessWidget {
  const _LevelTrackNode({
    required this.number,
    required this.reached,
    required this.nextReached,
    this.showIncomingLine = true,
  });

  final int number;
  final bool reached;
  final bool? nextReached;

  /// false только у самого первого уровня трека — идти линии слева не от куда.
  final bool showIncomingLine;

  static const _reachedColor = Color(0xFFE5484D);
  static const _unreachedColor = Color(0xFF4A4A52);
  static const _overflow = 40.0;

  @override
  Widget build(BuildContext context) {
    final ownColor = reached ? _reachedColor : _unreachedColor;
    final outColor = (nextReached ?? reached) ? _reachedColor : _unreachedColor;

    return SizedBox(
      width: 242,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -_overflow,
            right: -_overflow,
            child: Row(
              children: [
                Expanded(
                  child: showIncomingLine
                      ? ColoredBox(
                          color: ownColor,
                          child: const SizedBox(height: 4),
                        )
                      : const SizedBox(height: 4),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [ownColor, outColor]),
                    ),
                    child: const SizedBox(height: 4),
                  ),
                ),
              ],
            ),
          ),
          Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: ownColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Transform.rotate(
                angle: -0.785398,
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
