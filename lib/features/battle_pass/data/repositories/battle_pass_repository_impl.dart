import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/level.dart';
import '../../domain/entities/season.dart';
import '../../domain/repositories/battle_pass_repository.dart';
import '../mock/battle_pass_mock_api.dart';
import '../models/season_model.dart';

class BattlePassRepositoryImpl extends BaseRepository
    implements BattlePassRepository {
  BattlePassRepositoryImpl({required BattlePassMockApi mockApi})
    : _mockApi = mockApi;

  final BattlePassMockApi _mockApi;

  @override
  Future<Result<BattlePassSeason>> getSeason(BattlePassScenario scenario) =>
      execute(
        () async => SeasonModel.fromJson(_mockApi.fetchSeason(scenario)),
        const Failure('Не удалось загрузить боевой пропуск'),
      );

  @override
  Future<Result<BattlePassSeason>> claimReward(
    BattlePassSeason season,
    int levelNumber, {
    required bool isPremiumReward,
  }) => execute(() async {
    final levels = season.levels
        .map((level) {
          if (level.number != levelNumber) return level;
          final reward = isPremiumReward
              ? level.premiumReward
              : level.freeReward;
          if (reward == null) return level;
          final claimedReward = reward.copyWith(claimed: true);
          return level.copyWith(
            freeReward: isPremiumReward ? level.freeReward : claimedReward,
            premiumReward: isPremiumReward
                ? claimedReward
                : level.premiumReward,
            state: LevelState.claimed,
          );
        })
        .toList(growable: false);
    return season.copyWith(levels: levels);
  }, const Failure('Не удалось забрать награду'));

  @override
  Future<Result<BattlePassSeason>> claimAllRewards(BattlePassSeason season) =>
      execute(() async {
        final levels = season.levels
            .map((level) {
              if (level.state != LevelState.claimable) return level;
              return level.copyWith(
                state: LevelState.claimed,
                freeReward: level.freeReward?.copyWith(claimed: true),
                premiumReward: level.premiumReward?.copyWith(claimed: true),
              );
            })
            .toList(growable: false);
        return season.copyWith(levels: levels);
      }, const Failure('Не удалось забрать награды'));
}
