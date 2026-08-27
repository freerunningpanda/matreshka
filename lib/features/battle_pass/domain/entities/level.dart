import 'package:equatable/equatable.dart';

import 'reward.dart';

enum LevelState { locked, current, claimable, claimed }

class BattlePassLevel extends Equatable {
  const BattlePassLevel({
    required this.number,
    required this.requiredXp,
    required this.state,
    this.freeReward,
    this.premiumReward,
  });

  final int number;
  final int requiredXp;
  final LevelState state;
  final Reward? freeReward;
  final Reward? premiumReward;

  BattlePassLevel copyWith({
    LevelState? state,
    Reward? freeReward,
    Reward? premiumReward,
  }) => BattlePassLevel(
    number: number,
    requiredXp: requiredXp,
    state: state ?? this.state,
    freeReward: freeReward ?? this.freeReward,
    premiumReward: premiumReward ?? this.premiumReward,
  );

  @override
  List<Object?> get props => [
    number,
    requiredXp,
    state,
    freeReward,
    premiumReward,
  ];
}
