import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exports.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required GetTasks getTasks})
    : _getTasks = getTasks,
      super(const TasksLoading()) {
    load(BattlePassScenario.premiumLocked);
  }

  final GetTasks _getTasks;

  // Без emit(TasksLoading()) на переключении: это мок без сетевой
  // задержки, а тизер-карточка на TasksLoading прячется целиком
  // (см. TasksTeaserCard) — старый таск лучше держать на экране до
  // прихода нового, чем мигать пустотой при каждой смене сценария.
  Future<void> load(BattlePassScenario scenario) async {
    final result = await _getTasks(GetTasksParams(scenario));
    result.fold(
      onSuccess: (success) => emit(TasksLoaded(success.data)),
      onFailure: (failure) => emit(TasksError(failure.failure.error)),
    );
  }

  /// Мок-клейм опыта с тизер-карточки (см. "Забрать опыт" в сценарии "Макс.
  /// уровень / Много наград") — как и claim-действия боевого пропуска, это
  /// заглушка без реального API: просто помечает мок-таск полученным.
  void claimTaskXp(int taskId) {
    final current = state;
    if (current is! TasksLoaded) return;
    final tasks = current.overview.tasks
        .map((task) => task.id == taskId ? task.copyWith(claimed: true) : task)
        .toList(growable: false);
    emit(
      TasksLoaded(
        TasksOverview(
          premiumOwned: current.overview.premiumOwned,
          premiumXpBuffActive: current.overview.premiumXpBuffActive,
          tasks: tasks,
        ),
      ),
    );
  }
}
