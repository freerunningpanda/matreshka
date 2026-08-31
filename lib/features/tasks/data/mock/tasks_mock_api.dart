import '../../../battle_pass/domain/repositories/battle_pass_repository.dart';

/// Экран "Задания" в этом задании — минимальная заглушка (см. README): один
/// мок-таск для тизер-карточки на главном экране БП (узел "Tasks_Main_BP",
/// id 1:1266 в Figma), список на самом экране "Задания" не разбирался.
class TasksMockApi {
  Map<String, dynamic> fetchTasks(BattlePassScenario scenario) {
    switch (scenario) {
      case BattlePassScenario.premiumLocked:
        return _overview(premiumOwned: false, task: _activeTask);
      case BattlePassScenario.premiumUnlockedWithReward:
      // Пока пиксель-в-пиксель повторяет premiumUnlockedWithReward — см.
      // комментарий у enum-значения в battle_pass_repository.dart.
      case BattlePassScenario.premiumUnlockedNoReward:
      // maxLevelNoReward в плане UI берёт за основу premiumUnlockedNoReward,
      // а не maxLevel (несмотря на currentLevel=40 в season) — тот же таск
      // и обычный переход на экран заданий, без "Забрать опыт" с тизера.
      case BattlePassScenario.maxLevelNoReward:
        return _overview(premiumOwned: true, task: _completedRewardTask);
      case BattlePassScenario.maxLevel:
        // Узел "Tasks_Main_BP" для "Макс. уровень / Много наград" (см.
        // Figma-скрин): другой таск ("...в классическом режиме"), больше
        // XP и явный клейм ("Забрать опыт") прямо с тизера — обрабатывается
        // отдельно на уровне виджета (TasksTeaserCard.claimableInline).
        return _overview(premiumOwned: true, task: _classicModeTask);
      case BattlePassScenario.completed:
        return _overview(premiumOwned: true, task: _completedRewardTask);
    }
  }

  Map<String, dynamic> _overview({
    required bool premiumOwned,
    required Map<String, dynamic> task,
  }) => {
    'premium_owned': premiumOwned,
    'premium_xp_buff_active': false,
    'tasks': <Map<String, dynamic>>[task],
  };

  static const _activeTask = {
    'id': 1,
    'title': 'Используйте определенный предмет (Энергетик) 10 раз.',
    'progress_current': 3,
    'progress_target': 5,
    'reward_xp': 25,
    'completed': false,
    'claimed': false,
  };

  static const _completedRewardTask = {
    'id': 1,
    'title': 'Используйте определенный предмет (Энергетик) 10 раз.',
    'progress_current': 5,
    'progress_target': 5,
    'reward_xp': 100,
    'completed': true,
    'claimed': false,
  };

  static const _classicModeTask = {
    'id': 1,
    'title':
        'Используйте определенный предмет (Энергетик) 10 раз в '
        'классическом режиме.',
    'progress_current': 5,
    'progress_target': 5,
    'reward_xp': 250,
    'completed': true,
    'claimed': false,
  };
}
