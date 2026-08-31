import '../../../../core/result/result.dart';
import '../entities/season.dart';

/// Сценарии мока, соответствуют состояниям экрана "БП / Главная" из Figma.
enum BattlePassScenario {
  premiumLocked,
  premiumUnlockedWithReward,
  maxLevel,
  // Изначально был точной копией premiumUnlockedWithReward, постепенно
  // обрастает точечными отличиями (см. tasks_mock_api.dart — таск пока
  // общий с premiumUnlockedWithReward).
  premiumUnlockedNoReward,
  // "Макс. уровень" по season (currentLevel=maxLevel), но в плане UI трека
  // наград/тизера заданий/бейджей берёт за основу premiumUnlockedNoReward,
  // а не maxLevel — см. battle_pass_mock_api.dart/tasks_mock_api.dart/
  // battle_pass_screen.dart.
  maxLevelNoReward,
  completed,
}

abstract class BattlePassRepository {
  Future<Result<BattlePassSeason>> getSeason(BattlePassScenario scenario);

  Future<Result<BattlePassSeason>> claimReward(
    BattlePassSeason season,
    int levelNumber, {
    required bool isPremiumReward,
  });

  Future<Result<BattlePassSeason>> claimAllRewards(BattlePassSeason season);
}
