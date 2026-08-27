import '../../domain/entities/task.dart';

final class TaskModel extends BattlePassTask {
  const TaskModel({
    required super.id,
    required super.title,
    required super.progressCurrent,
    required super.progressTarget,
    required super.rewardXp,
    required super.completed,
    required super.claimed,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] as int,
    title: json['title'] as String,
    progressCurrent: json['progress_current'] as int,
    progressTarget: json['progress_target'] as int,
    rewardXp: json['reward_xp'] as int,
    completed: json['completed'] as bool,
    claimed: json['claimed'] as bool,
  );
}
