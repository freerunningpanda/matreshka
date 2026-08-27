import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/season.dart';
import '../repositories/battle_pass_repository.dart';

class ClaimAllRewards extends UseCase<BattlePassSeason, BattlePassSeason> {
  const ClaimAllRewards(this._repository);

  final BattlePassRepository _repository;

  @override
  Future<Result<BattlePassSeason>> call(BattlePassSeason params) =>
      _repository.claimAllRewards(params);
}
