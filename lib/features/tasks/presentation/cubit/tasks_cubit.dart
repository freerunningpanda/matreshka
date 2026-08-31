import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_tasks.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required GetTasks getTasks})
    : _getTasks = getTasks,
      super(const TasksLoading()) {
    load(premiumOwned: false);
  }

  final GetTasks _getTasks;

  // Без emit(TasksLoading()) на переключении: это мок без сетевой
  // задержки, а тизер-карточка на TasksLoading прячется целиком
  // (см. TasksTeaserCard) — старый таск лучше держать на экране до
  // прихода нового, чем мигать пустотой при каждой смене сценария.
  Future<void> load({required bool premiumOwned}) async {
    final result = await _getTasks(GetTasksParams(premiumOwned: premiumOwned));
    result.fold(
      onSuccess: (success) => emit(TasksLoaded(success.data)),
      onFailure: (failure) => emit(TasksError(failure.failure.error)),
    );
  }
}
