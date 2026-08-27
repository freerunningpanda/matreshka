import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/season.dart';
import '../repositories/battle_pass_repository.dart';

class ClaimRewardParams extends Equatable {
  const ClaimRewardParams({
    required this.season,
    required this.levelNumber,
    required this.isPremiumReward,
  });

  final BattlePassSeason season;
  final int levelNumber;
  final bool isPremiumReward;

  @override
  List<Object?> get props => [season, levelNumber, isPremiumReward];
}

class ClaimReward extends UseCase<BattlePassSeason, ClaimRewardParams> {
  const ClaimReward(this._repository);

  final BattlePassRepository _repository;

  @override
  Future<Result<BattlePassSeason>> call(ClaimRewardParams params) =>
      _repository.claimReward(
        params.season,
        params.levelNumber,
        isPremiumReward: params.isPremiumReward,
      );
}
