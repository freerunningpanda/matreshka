import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Полноэкранный фон архи-сцены из макета (BG-компонент в Figma).
class BattlePassBackground extends StatelessWidget {
  const BattlePassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.screenBackground,
        child: Image.asset(
          'assets/images/battle_pass/bg_main.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
