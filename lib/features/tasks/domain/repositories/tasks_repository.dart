import '../../../../core/result/result.dart';
import '../../../battle_pass/domain/repositories/battle_pass_repository.dart';
import '../entities/tasks_overview.dart';

abstract class TasksRepository {
  Future<Result<TasksOverview>> getTasks(BattlePassScenario scenario);
}
