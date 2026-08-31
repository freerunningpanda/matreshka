import 'package:flutter/material.dart';

import '../../../exports.dart';

/// Левая панель навигации (иконки разделов игры) — статичная картинка из
/// макета: одинакова во всех состояниях экрана БП, поэтому не требует
/// динамической вёрстки (см. README, раздел "спорные места").
class LeftNavPanel extends StatelessWidget {
  const LeftNavPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: 295,
      child: Image(
        image: AssetImage(AppAssets.imageLeftNavBar),
        fit: BoxFit.fitHeight,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
