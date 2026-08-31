import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../battle_pass/domain/repositories/battle_pass_repository.dart';
import '../entities/tasks_overview.dart';
import '../repositories/tasks_repository.dart';

class GetTasksParams extends Equatable {
  const GetTasksParams(this.scenario);

  final BattlePassScenario scenario;

  @override
  List<Object?> get props => [scenario];
}

class GetTasks extends UseCase<TasksOverview, GetTasksParams> {
  const GetTasks(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<TasksOverview>> call(GetTasksParams params) =>
      _repository.getTasks(params.scenario);
}
