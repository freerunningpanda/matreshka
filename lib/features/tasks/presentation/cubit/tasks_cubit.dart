import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/use_case.dart';
import '../../domain/usecases/get_tasks.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required GetTasks getTasks})
    : _getTasks = getTasks,
      super(const TasksLoading()) {
    _load();
  }

  final GetTasks _getTasks;

  Future<void> _load() async {
    final result = await _getTasks(const NoParams());
    result.fold(
      onSuccess: (success) => emit(TasksLoaded(success.data)),
      onFailure: (failure) => emit(TasksError(failure.failure.error)),
    );
  }
}
