import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/battle_pass_repository.dart';
import 'scenario_flavor.dart';

/// Центральный предмет БП над аркой (Item + Item_Name из макета).
class CentralItemDisplay extends StatelessWidget {
  const CentralItemDisplay({required this.scenario, super.key});

  final BattlePassScenario scenario;

  @override
  Widget build(BuildContext context) {
    final flavor = ScenarioFlavor.of(scenario);
    return Positioned(
      left: 900,
      top: 40,
      width: 730,
      height: 700,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Column(
          key: ValueKey(scenario),
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Image.asset(flavor.itemAsset, fit: BoxFit.contain)),
            const SizedBox(height: 20),
            _Tag(text: flavor.tag),
            const SizedBox(height: 14),
            Text(
              flavor.itemTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Geologica',
                fontWeight: FontWeight.w600,
                fontSize: 34,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.workspace_premium,
            color: AppColors.accentGold,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: AppColors.accentGold,
            ),
          ),
        ],
      ),
    );
  }
}
