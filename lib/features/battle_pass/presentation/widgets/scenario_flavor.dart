import '../../../exports.dart';

/// Косметический текст/картинка центрального предмета под каждый сценарий.
/// Сознательно вынесено из domain-модели: это флейвор-контент конкретного
/// сезона, а не часть проданской схемы данных БП (см. README).
class ScenarioFlavor {
  const ScenarioFlavor({
    required this.itemAsset,
    required this.itemTitle,
    this.tag,
    this.itemOffsetY = 0,
    this.itemScale = 1,
  });

  final String itemAsset;
  final String itemTitle;

  /// null — плашки-тега над названием предмета нет (см. "Макс. уровень /
  /// Много наград": она конфликтует с названием по месту, ей там не быть).
  final String? tag;

  /// Сдвиг картинки предмета по вертикали (отрицательное — выше). У
  /// reward_item_max_level.png композиция ниже остальных, поднята на 30px.
  final double itemOffsetY;

  /// Масштаб картинки предмета сверх обычного BoxFit.contain — у
  /// bullets.png (rewardsEndedPremiumOwned) увеличена на 8%.
  final double itemScale;

  static ScenarioFlavor of(BattlePassScenario scenario) => switch (scenario) {
    BattlePassScenario.premiumLocked => const ScenarioFlavor(
      itemAsset: AppAssets.imageItemLocked,
      itemTitle: AppStrings.itemTitleMegaPack,
      tag: AppStrings.itemTagAvailableWithPremium,
    ),
    BattlePassScenario.premiumUnlockedWithReward => const ScenarioFlavor(
      itemAsset: AppAssets.imageItemPurchased,
      itemTitle: AppStrings.itemTitleFatalWomanOrMafiaBoss,
      tag: AppStrings.itemTagAvailableWithPremium,
      itemScale: 1.22,
    ),
    // Та же картинка/тег, что и у premiumUnlockedWithReward — только
    // название предмета короче ("Мега пак" вместо длинного варианта).
    // rewardsEndedPremiumNotOwned — та же, что и у rewardsEndedPremiumOwned
    // (см. battle_pass_mock_api.dart — наполнение оттуда же).
    BattlePassScenario.rewardsEndedPremiumOwned ||
    BattlePassScenario.rewardsEndedPremiumNotOwned => const ScenarioFlavor(
      itemAsset: AppAssets.imageBullets,
      itemTitle: AppStrings.itemTitleMegaPack,
      tag: AppStrings.itemTagAvailableWithPremium,
      itemScale: 1.12,
    ),
    // CentralItemDisplay для "Премиум куплен / нет наград" и "Макс.
    // уровень / Нет наград" — такой же, как у "Макс. уровень / Много
    // наград".
    BattlePassScenario.maxLevel ||
    BattlePassScenario.completed ||
    BattlePassScenario.premiumUnlockedNoReward ||
    BattlePassScenario.maxLevelNoReward => const ScenarioFlavor(
      itemAsset: AppAssets.imageItemMaxLevel,
      itemTitle: AppStrings.itemTitleMegaPack,
      itemOffsetY: -70,
      itemScale: 1.06,
    ),
  };
}
