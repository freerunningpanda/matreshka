import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/level.dart';
import '../../domain/entities/reward.dart';

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
    final width = _isMilestone ? 200.0 : 150.0;
    final locked = level.state == LevelState.locked;
    final claimable = level.state == LevelState.claimable;
    final claimed = level.state == LevelState.claimed;
    final current = level.state == LevelState.current;
    final showPremiumBadge =
        level.premiumReward != null &&
        !premiumOwned &&
        level.premiumReward?.claimed != true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: width,
            height: _isMilestone ? 220 : 170,
            child: DecoratedBox(
              decoration: _isMilestone
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: AppColors.levelUpBorderGradient,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.glowShadow,
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: current
                            ? Colors.white
                            : claimable
                            ? const Color(0xFF3DDC6B)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: _rarityColor(
                    reward?.rarity,
                  ).withValues(alpha: locked ? 0.25 : 0.55),
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: claimable ? onClaim : null,
                    child: Opacity(
                      opacity: locked ? 0.5 : 1,
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              locked
                                  ? Icons.lock_rounded
                                  : Icons.card_giftcard_rounded,
                              color: Colors.white,
                              size: _isMilestone ? 64 : 44,
                            ),
                          ),
                          if (reward != null && reward.amount > 1)
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: _Chip(text: '×${reward.amount}'),
                            ),
                          if (claimed)
                            const Positioned(
                              left: 8,
                              top: 8,
                              child: _Badge(
                                icon: Icons.check_rounded,
                                color: Color(0xFF3DDC6B),
                              ),
                            )
                          else if (showPremiumBadge)
                            const Positioned(
                              left: 8,
                              top: 8,
                              child: _Badge(
                                icon: Icons.workspace_premium,
                                color: AppColors.accentGold,
                              ),
                            ),
                          if (claimable)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3DDC6B),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
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
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _LevelBadge(number: level.number, reached: !locked),
        ],
      ),
    );
  }

  Color _rarityColor(RewardRarity? rarity) => switch (rarity) {
    RewardRarity.legendary => AppColors.glowGold,
    RewardRarity.epic => AppColors.claimPurpleTop,
    RewardRarity.rare => const Color(0xFF4E8FE0),
    RewardRarity.common || null => const Color(0xFF6B6F76),
  };
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

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: const Color(0xFF2D2D31)),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Geologica',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
