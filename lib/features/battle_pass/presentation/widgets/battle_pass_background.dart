import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Полноэкранный фон архи-сцены из макета (BG-компонент в Figma).
class BattlePassBackground extends StatelessWidget {
  const BattlePassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: context.theme.appColors.mainColors.screenBackground,
        child: Image.asset(AppAssets.imageBackground, fit: BoxFit.cover),
      ),
    );
  }
}
