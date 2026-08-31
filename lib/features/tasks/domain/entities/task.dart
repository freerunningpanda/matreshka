import 'package:equatable/equatable.dart';

class BattlePassTask extends Equatable {
  const BattlePassTask({
    required this.id,
    required this.title,
    required this.progressCurrent,
    required this.progressTarget,
    required this.rewardXp,
    required this.completed,
    required this.claimed,
  });

  final int id;
  final String title;
  final int progressCurrent;
  final int progressTarget;
  final int rewardXp;
  final bool completed;
  final bool claimed;

  BattlePassTask copyWith({bool? claimed}) => BattlePassTask(
    id: id,
    title: title,
    progressCurrent: progressCurrent,
    progressTarget: progressTarget,
    rewardXp: rewardXp,
    completed: completed,
    claimed: claimed ?? this.claimed,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    progressCurrent,
    progressTarget,
    rewardXp,
    completed,
    claimed,
  ];
}
