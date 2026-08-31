import '../../domain/repositories/battle_pass_repository.dart';

/// Косметический текст/картинка центрального предмета под каждый сценарий.
/// Сознательно вынесено из domain-модели: это флейвор-контент конкретного
/// сезона, а не часть проданской схемы данных БП (см. README).
class ScenarioFlavor {
  const ScenarioFlavor({
    required this.itemAsset,
    required this.itemTitle,
    this.tag,
    this.itemOffsetY = 0,
  });

  final String itemAsset;
  final String itemTitle;

  /// null — плашки-тега над названием предмета нет (см. "Макс. уровень /
  /// Много наград": она конфликтует с названием по месту, ей там не быть).
  final String? tag;

  /// Сдвиг картинки предмета по вертикали (отрицательное — выше). У
  /// reward_item_max_level.png композиция ниже остальных, поднята на 30px.
  final double itemOffsetY;

  static const _assetsBase = 'assets/images/battle_pass';

  static ScenarioFlavor of(BattlePassScenario scenario) => switch (scenario) {
    BattlePassScenario.premiumLocked => const ScenarioFlavor(
      itemAsset: '$_assetsBase/reward_item_locked.png',
      itemTitle: 'Мега пак',
      tag: 'Доступно с прокачкой!',
    ),
    BattlePassScenario.premiumUnlockedWithReward => const ScenarioFlavor(
      itemAsset: '$_assetsBase/reward_item_purchased.png',
      itemTitle: '«Роковая женщина» или «Босс мафии»',
      tag: 'Доступно с прокачкой!',
    ),
    // CentralItemDisplay для "Премиум куплен / нет наград" и "Макс.
    // уровень / Нет наград" — такой же, как у "Макс. уровень / Много
    // наград".
    BattlePassScenario.maxLevel ||
    BattlePassScenario.completed ||
    BattlePassScenario.premiumUnlockedNoReward ||
    BattlePassScenario.maxLevelNoReward => const ScenarioFlavor(
      itemAsset: '$_assetsBase/reward_item_max_level.png',
      itemTitle: 'Мега пак',
      itemOffsetY: -70,
    ),
  };
}
