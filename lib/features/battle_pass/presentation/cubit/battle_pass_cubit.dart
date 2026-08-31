import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exports.dart';

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

  /// Мок-покупка премиума: реального IAP в задании нет. Переключение
  /// сценария — источник правды один, так что уровень/трек/премиум-плашки
  /// остаются согласованными (см. README про мок-схему).
  Future<void> purchasePremium() =>
      switchScenario(BattlePassScenario.premiumUnlockedWithReward);

  /// Мок-"повышение уровня" по кнопке в баннере (см. purchasePremium) — тот
  /// же принцип: реального прогресса нет, просто переключаем сценарий на
  /// макс. уровень.
  Future<void> increaseLevel() => switchScenario(BattlePassScenario.maxLevel);

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
