import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/level.dart';
import '../../domain/entities/reward.dart';
import 'reward_carousel_tile.dart';

class RewardTile extends StatelessWidget {
  const RewardTile({
    required this.level,
    required this.premiumOwned,
    required this.onClaim,
    super.key,
  });

  final BattlePassLevel level;
  final bool premiumOwned;
  final VoidCallback onClaim;

  bool get _isMilestone => level.number % 10 == 0;

  @override
  Widget build(BuildContext context) {
    final reward = level.freeReward;
    final locked = level.state == LevelState.locked;
    final claimable = level.state == LevelState.claimable;
    final claimed = level.state == LevelState.claimed;
    final current = level.state == LevelState.current;
    final showPremiumBadge =
        level.premiumReward != null &&
        !premiumOwned &&
        level.premiumReward?.claimed != true;

    final tile = RewardCarouselTile(
      asset: reward?.iconAsset ?? _placeholderAsset,
      gradient: _rarityGradient(reward?.rarity),
      badge: showPremiumBadge ? RewardBadgeKind.premium : RewardBadgeKind.gift,
      quantityLabel: (reward != null && reward.amount > 1)
          ? '×${reward.amount}'
          : null,
      borderColor: current
          ? Colors.white
          : claimable
          ? const Color(0xFF3DDC6B)
          : null,
      claimed: claimed,
      locked: locked,
      onTap: claimable ? onClaim : null,
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
