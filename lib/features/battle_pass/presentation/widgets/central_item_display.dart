import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/battle_pass_repository.dart';
import 'scenario_flavor.dart';

/// Центральный предмет БП над аркой (Item + Item_Name из макета, id 1:1259).
class CentralItemDisplay extends StatelessWidget {
  const CentralItemDisplay({required this.scenario, super.key});

  final BattlePassScenario scenario;

  @override
  Widget build(BuildContext context) {
    final flavor = ScenarioFlavor.of(scenario);
    return Positioned(
      left: 960,
      top: 160,
      width: 600,
      height: 550,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Column(
          key: ValueKey(scenario),
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Image.asset(flavor.itemAsset, fit: BoxFit.contain)),
            const SizedBox(height: 20),
            _Tag(text: flavor.tag),
            const SizedBox(height: 10),
            _ItemTitle(text: flavor.itemTitle),
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
      width: 324,
      height: 39,
      padding: const EdgeInsets.only(left: 12, right: 19),
      decoration: const BoxDecoration(
        gradient: AppColors.itemTagGradient,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/battle_pass/premium.svg',
            width: 30,
            height: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Geologica',
                fontWeight: FontWeight.w500,
                fontSize: 22,
                height: 1.2,
                letterSpacing: -0.22,
                color: AppColors.itemTagText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTitle extends StatelessWidget {
  const _ItemTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontWeight: FontWeight.w600,
              fontSize: 36,
              height: 1.3,
              letterSpacing: -0.36,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SvgPicture.asset(
          'assets/icons/battle_pass/info.svg',
          width: 36,
          height: 36,
        ),
      ],
    );
  }
}
