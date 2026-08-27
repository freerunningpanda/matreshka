import '../../domain/entities/tasks_overview.dart';
import 'task_model.dart';

final class TasksOverviewModel extends TasksOverview {
  const TasksOverviewModel({
    required super.premiumOwned,
    required super.premiumXpBuffActive,
    required super.tasks,
  });

  factory TasksOverviewModel.fromJson(Map<String, dynamic> json) =>
      TasksOverviewModel(
        premiumOwned: json['premium_owned'] as bool,
        premiumXpBuffActive: json['premium_xp_buff_active'] as bool,
        tasks: (json['tasks'] as List<dynamic>)
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );
}
