/// Все пользовательские строки presentation-слоя (features/**/presentation)
/// — вместо разбросанных по виджетам литералов. Если в проект добавится
/// локализация, строки нужно будет брать из одного места, а не искать их
/// по всему проекту.
abstract final class AppStrings {
  // Battle Pass завершён
  static const battlePassEndedTitle = 'Battle Pass завершен';
  static const battlePassEndedSubtitle = 'Успей забрать оставшиеся награды!';

  // Обратный отсчёт ивента
  static const eventTitle = 'Дай пять!';
  static const countdownDaysUnit = 'д';
  static const countdownHoursUnit = 'ч';
  static const countdownMinutesUnit = 'м';

  // Баннер премиума
  static const premiumBannerTitleLevelUp = 'Повышение уровня';
  static const premiumBannerTitleUnlock = 'Элитный пропуск';
  static const premiumBannerSubtitleLevelUp =
      'Повышай уровень боевого пропуска и забирай новые награды!';
  static const premiumBannerSubtitleUnlock =
      'Прокачай боевой пропуск и забери чёткие скины, аксессуары и многое '
      'другое!';
  static const increaseLevelButton = 'Повысить уровень';
  static const unlockPremiumButton = 'Прокачать';
  static const maxLevelReachedNotice = 'Достигнут максимальный уровень';

  // Тизер премиум-наград в начале трека
  static const quantityLabelX2 = '×2';
  static const premiumTeaserUnlockAll = 'Получи все сразу!';

  // Центральный предмет / флейвор сценария
  static const itemTitleMegaPack = 'Мега пак';
  static const itemTagAvailableWithPremium = 'Доступно с прокачкой!';
  static const itemTitleFatalWomanOrMafiaBoss =
      '«Роковая женщина» или «Босс мафии»';

  /// Тот же текст, что и внутри [itemTitleFatalWomanOrMafiaBoss] — используется
  /// для поиска и золотой подсветки слова "или" внутри itemTitle.
  static const itemTitleOrConnector = ' или ';

  // Dev-переключатель сценариев
  static const devScenarioSwitcherTooltip = 'Переключить сценарий (dev)';
  static const devScenarioPremiumLocked = 'Премиум не куплен';
  static const devScenarioPremiumUnlockedWithReward =
      'Премиум куплен / награда';
  static const devScenarioMaxLevel = 'Макс. уровень / Много наград';
  static const devScenarioPremiumUnlockedNoReward =
      'Премиум куплен / нет наград';
  static const devScenarioMaxLevelNoReward = 'Макс. уровень / Нет наград';
  static const devScenarioRewardsEndedPremiumOwned =
      'Конец наград (Куплен премиум)';
  static const devScenarioRewardsEndedPremiumNotOwned =
      'Конец наград (Не куплен премиум)';

  // Тизер-карточка "Задания"
  static const taskRewardXpPrefix = 'x ';
  static const taskProgressSeparator = ' / ';
  static const tasksButtonLabel = 'Задания';
  static const xpClaimedLabel = 'Получено';
  static const claimXpButtonLabel = 'Забрать опыт';

  // Кнопка "Забрать все награды"
  static const claimAllRewardsButton = 'Забрать все награды';

  // Плитка награды трека
  static const claimButtonLabel = 'Забрать';
  static const levelLockedHintPrefix = 'Откроется на ';
  static const levelLockedHintSuffix = ' уровне';
  static const rewardAlreadyClaimedHint = 'Уже получено';
  static const levelMissingXpHintPrefix = 'Наберите ещё ';
  static const levelMissingXpHintSuffix = ' XP, чтобы открыть';

  // Карточка "следующий сезон" в конце трека
  static const seasonEndTeaserRewardsPrefix = 'Награды ';
  static const seasonEndTeaserRewardsSuffix = '+ уровней ';
  static const seasonEndTeaserRequiresPremiumMiddle = 'доступны только\nс ';
  static const seasonEndTeaserRequiresPremiumSuffix = 'прокачкой';
  static const seasonEndTeaserUnlockPrefix =
      'Награды откроются после прохождения ';
  static const seasonEndTeaserUnlockLevelSuffix = ' уровня';

  // XP-пилюля
  static const xpProgressSeparator = ' / ';
}
