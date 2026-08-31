import 'package:equatable/equatable.dart';

import '../../../exports.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksLoaded extends TasksState {
  const TasksLoaded(this.overview);

  final TasksOverview overview;

  @override
  List<Object?> get props => [overview];
}

final class TasksError extends TasksState {
  const TasksError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
