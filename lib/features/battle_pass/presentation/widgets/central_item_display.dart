import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports.dart';

/// Центральный предмет БП над аркой (Item + Item_Name из макета, id 1:1259).
class CentralItemDisplay extends StatelessWidget {
  const CentralItemDisplay({required this.scenario, super.key});

  final BattlePassScenario scenario;

  @override
  Widget build(BuildContext context) {
    const itemLeft = 960.0;
    const itemTop = 140.0;
    const switchDuration = Duration(milliseconds: 350);

    final flavor = ScenarioFlavor.of(scenario);
    return Positioned(
      left: itemLeft,
      top: itemTop,
      width: AppSizes.horizontalSize600,
      height: AppSizes.verticalSize550,
      child: AnimatedSwitcher(
        duration: switchDuration,
        child: Column(
          key: ValueKey(scenario),
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Transform.translate(
                offset: Offset(0, flavor.itemOffsetY),
                child: Transform.scale(
                  scale: flavor.itemScale,
                  child: Image.asset(flavor.itemAsset, fit: BoxFit.contain),
                ),
              ),
            ),
            AppSizedBoxes.verticalSizedBoxH20,
            if (flavor.tag case final tag?) ...[
              _Tag(text: tag),
              AppSizedBoxes.verticalSizedBoxH10,
            ],
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
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    final tagGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [colors.itemTagGradientTop, colors.itemTagGradientBottom],
    );

    return Container(
      width: AppSizes.horizontalSize324,
      height: AppSizes.verticalSize39,
      padding: AppPadding.onlyPaddingL12R19,
      decoration: BoxDecoration(
        gradient: tagGradient,
        borderRadius: AppRadius.circular30,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.iconPremiumIcon,
            width: AppSizes.horizontalSize30,
            height: AppSizes.verticalSize22,
          ),
          AppSizedBoxes.horizontalSizedBoxW10,
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.appTypography.mobileTypo.p1Med.copyWith(
                color: colors.itemTagText,
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text.rich(
              _titleSpan(context, text),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
        AppSizedBoxes.horizontalSizedBoxW16,
        SvgPicture.asset(
          AppAssets.iconInfo,
          width: AppSizes.allSize36,
          height: AppSizes.allSize36,
        ),
      ],
    );
  }

  // "или" между двумя названиями предмета подсвечивается золотым (см.
  // node-id 1-1372 в Figma) — остальной текст остаётся обычным.
  InlineSpan _titleSpan(BuildContext context, String text) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;
    final style = theme.appTypography.mobileTypo.h4.copyWith(
      color: colors.textPrimary,
    );
    const highlight = AppStrings.itemTitleOrConnector;
    final index = text.indexOf(highlight);
    if (index == -1) return TextSpan(text: text, style: style);

    return TextSpan(
      style: style,
      children: [
        TextSpan(text: text.substring(0, index)),
        TextSpan(
          text: highlight,
          style: TextStyle(color: colors.accentGold),
        ),
        TextSpan(text: text.substring(index + highlight.length)),
      ],
    );
  }
}
