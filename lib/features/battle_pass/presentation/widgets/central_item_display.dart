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
            _ItemTitle(
              text: flavor.itemTitle,
              infoAsset: flavor.itemAsset,
              infoText: flavor.infoText,
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
  const _ItemTitle({
    required this.text,
    required this.infoAsset,
    required this.infoText,
  });

  final String text;

  /// Картинка предмета — переиспользуется как превью в диалоге по тапу на
  /// инфо-иконку, чтобы не грузить отдельный ассет.
  final String infoAsset;

  final String infoText;

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
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => _ItemInfoDialog(
              title: text,
              asset: infoAsset,
              description: infoText,
            ),
          ),
          child: SvgPicture.asset(
            AppAssets.iconInfo,
            width: AppSizes.allSize36,
            height: AppSizes.allSize36,
          ),
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

/// Карточка предмета по тапу на инфо-иконку рядом с названием — превью,
/// заголовок и описание. Тот же язык оформления (золотая рамка + мягкое
/// свечение), что и у выноски дев-переключателя сценариев
/// (см. scenario_switcher.dart._ScenarioSwitcherHint).
class _ItemInfoDialog extends StatelessWidget {
  const _ItemInfoDialog({
    required this.title,
    required this.asset,
    required this.description,
  });

  final String title;
  final String asset;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.appColors.mainColors;

    const dialogMaxWidth = 480.0;
    const previewSize = 160.0;
    const borderWidth = 1.5;
    const glowBlurRadius = 24.0;
    const glowSpreadRadius = 1.0;
    // Верхний паддинг больше остальных — освобождает место под крестик,
    // который плавает поверх скролла отдельным слоем (см. Stack ниже) и не
    // должен наезжать на превью/заголовок в самом верху контента.
    const contentPadding = EdgeInsets.fromLTRB(32, 52, 32, 32);
    const closeButtonInset = 8.0;
    const closeButtonPadding = 8.0;
    // Диалог живёт в реальных координатах экрана устройства (а не в 1080px
    // дизайн-канвасе — showDialog кладёт его выше DesignCanvas, поверх
    // всего MaterialApp), на невысоком landscape-экране превью+текст могут
    // не влезть по высоте — отсюда и maxHeight, и скролл контента ниже.
    final dialogMaxHeight = MediaQuery.sizeOf(context).height * 0.8;

    return Dialog(
      backgroundColor: colors.appColorTransparent,
      insetPadding: AppPadding.allPadding24,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogMaxWidth,
          maxHeight: dialogMaxHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.taskCardHeaderBg,
            borderRadius: AppRadius.circular24,
            border: Border.all(color: colors.glowGold, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: colors.glowShadow,
                blurRadius: glowBlurRadius,
                spreadRadius: glowSpreadRadius,
              ),
            ],
          ),
          // ClipRRect — скроллбар и контент не должны вылезать за скруглённые
          // углы карточки при прокрутке.
          child: ClipRRect(
            borderRadius: AppRadius.circular24,
            child: Stack(
              children: [
                Padding(
                  padding: contentPadding,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: previewSize,
                            height: previewSize,
                            child: Image.asset(asset, fit: BoxFit.contain),
                          ),
                          AppSizedBoxes.verticalSizedBoxH12,
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: theme.appTypography.mobileTypo.p1Med
                                .copyWith(color: colors.accentGold),
                          ),
                          AppSizedBoxes.verticalSizedBoxH8,
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: theme.appTypography.mobileTypo.p4Reg
                                .copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Отдельным слоем поверх скролла — не прокручивается вместе
                // с контентом.
                Positioned(
                  top: closeButtonInset,
                  right: closeButtonInset,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(closeButtonPadding),
                      child: Icon(
                        Icons.close,
                        color: colors.textSecondary,
                        size: AppSizes.allSize18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
