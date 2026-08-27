import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/season.dart';
import '../repositories/battle_pass_repository.dart';

class GetSeasonParams extends Equatable {
  const GetSeasonParams(this.scenario);

  final BattlePassScenario scenario;

  @override
  List<Object?> get props => [scenario];
}

class GetSeason extends UseCase<BattlePassSeason, GetSeasonParams> {
  const GetSeason(this._repository);

  final BattlePassRepository _repository;

  @override
  Future<Result<BattlePassSeason>> call(GetSeasonParams params) =>
      _repository.getSeason(params.scenario);
}
