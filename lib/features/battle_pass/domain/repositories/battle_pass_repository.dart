import '../../../../core/result/result.dart';
import '../entities/season.dart';

/// Сценарии мока, соответствуют состояниям экрана "БП / Главная" из Figma.
enum BattlePassScenario {
  premiumLocked,
  premiumUnlockedWithReward,
  maxLevel,
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
