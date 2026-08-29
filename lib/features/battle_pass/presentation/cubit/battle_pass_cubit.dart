import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/battle_pass_repository.dart';
import '../../domain/usecases/claim_all_rewards.dart';
import '../../domain/usecases/claim_reward.dart';
import '../../domain/usecases/get_season.dart';
import 'battle_pass_state.dart';

class BattlePassCubit extends Cubit<BattlePassState> {
  BattlePassCubit({
    required GetSeason getSeason,
    required ClaimReward claimReward,
    required ClaimAllRewards claimAllRewards,
  }) : _getSeason = getSeason,
       _claimReward = claimReward,
       _claimAllRewards = claimAllRewards,
       super(const BattlePassLoading()) {
    switchScenario(BattlePassScenario.premiumLocked);
  }

  final GetSeason _getSeason;
  final ClaimReward _claimReward;
  final ClaimAllRewards _claimAllRewards;

  Future<void> switchScenario(BattlePassScenario scenario) async {
    emit(const BattlePassLoading());
    final result = await _getSeason(GetSeasonParams(scenario));
    result.fold(
      onSuccess: (success) => emit(
        BattlePassLoaded(
          season: success.data,
          scenario: scenario,
          selectedLevel: success.data.currentLevel,
        ),
      ),
      onFailure: (failure) => emit(BattlePassError(failure.failure.error)),
    );
  }

  void selectLevel(int levelNumber) {
    final current = state;
    if (current is BattlePassLoaded) {
      emit(current.copyWith(selectedLevel: levelNumber));
    }
  }

  Future<void> claimReward(
    int levelNumber, {
    required bool isPremiumReward,
  }) async {
    final current = state;
    if (current is! BattlePassLoaded) return;
    final result = await _claimReward(
      ClaimRewardParams(
        season: current.season,
        levelNumber: levelNumber,
        isPremiumReward: isPremiumReward,
      ),
    );
    result.fold(
      onSuccess: (success) => emit(current.copyWith(season: success.data)),
      onFailure: (failure) => emit(BattlePassError(failure.failure.error)),
    );
  }

  Future<void> claimAllRewards() async {
    final current = state;
    if (current is! BattlePassLoaded) return;
    final result = await _claimAllRewards(current.season);
    result.fold(
      onSuccess: (success) => emit(current.copyWith(season: success.data)),
      onFailure: (failure) => emit(BattlePassError(failure.failure.error)),
    );
  }
}
