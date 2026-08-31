import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../battle_pass/domain/repositories/battle_pass_repository.dart';
import '../../domain/entities/tasks_overview.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../mock/tasks_mock_api.dart';
import '../models/tasks_overview_model.dart';

class TasksRepositoryImpl extends BaseRepository implements TasksRepository {
  TasksRepositoryImpl({required TasksMockApi mockApi}) : _mockApi = mockApi;

  final TasksMockApi _mockApi;

  @override
  Future<Result<TasksOverview>> getTasks(BattlePassScenario scenario) =>
      execute(
        () async => TasksOverviewModel.fromJson(_mockApi.fetchTasks(scenario)),
        const Failure('Не удалось загрузить задания'),
      );
}
