import 'package:equatable/equatable.dart';

import 'task.dart';

class TasksOverview extends Equatable {
  const TasksOverview({
    required this.premiumOwned,
    required this.premiumXpBuffActive,
    required this.tasks,
  });

  final bool premiumOwned;
  final bool premiumXpBuffActive;
  final List<BattlePassTask> tasks;

  @override
  List<Object?> get props => [premiumOwned, premiumXpBuffActive, tasks];
}
