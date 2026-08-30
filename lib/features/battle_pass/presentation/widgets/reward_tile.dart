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
    super.key,
  });

  final BattlePassLevel level;
  final bool premiumOwned;

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

  bool get _isMilestone => widget.level.number % 10 == 0;

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
    final current = level.state == LevelState.current;
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
      borderColor: current
          ? Colors.white
          : showClaimUi
          ? const Color(0xFF3DDC6B)
          : null,
      claimed: claimed,
      locked: locked,
      // Плитка всегда кликабельна. Доступная бесплатная награда открывается
      // в два тапа: первый показывает рамку и кнопку "Забрать", второй —
      // уже забирает; премиум-плитка сразу ведёт к покупке прокачки, а
      // прочие показывают, почему награда пока недоступна.
      onTap: showPremiumBadge
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
        _isMilestone ? _MilestoneFrame(child: tile) : tile,
        const SizedBox(height: 12),
        _LevelBadge(number: level.number, reached: !locked),
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

/// Рамка "уровень с большой наградой" (каждый 10-й) — золотой градиентный
/// бордер с сиянием вокруг обычной плитки трека.
class _MilestoneFrame extends StatelessWidget {
  const _MilestoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: AppColors.levelUpBorderGradient,
        boxShadow: const [
          BoxShadow(
            color: AppColors.glowShadow,
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
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

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.number, required this.reached});

  final int number;
  final bool reached;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45°
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: reached ? const Color(0xFFE5484D) : const Color(0xFF4A4A52),
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
    );
  }
}
