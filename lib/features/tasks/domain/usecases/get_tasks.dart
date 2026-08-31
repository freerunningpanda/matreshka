import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/tasks_overview.dart';
import '../repositories/tasks_repository.dart';

class GetTasksParams extends Equatable {
  const GetTasksParams({required this.premiumOwned});

  final bool premiumOwned;

  @override
  List<Object?> get props => [premiumOwned];
}

class GetTasks extends UseCase<TasksOverview, GetTasksParams> {
  const GetTasks(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<TasksOverview>> call(GetTasksParams params) =>
      _repository.getTasks(premiumOwned: params.premiumOwned);
}
