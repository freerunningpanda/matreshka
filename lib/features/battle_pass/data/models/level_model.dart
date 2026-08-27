import '../../domain/entities/level.dart';
import 'reward_model.dart';

final class LevelModel extends BattlePassLevel {
  const LevelModel({
    required super.number,
    required super.requiredXp,
    required super.state,
    super.freeReward,
    super.premiumReward,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
    number: json['number'] as int,
    requiredXp: json['required_xp'] as int,
    state: LevelState.values.byName(json['state'] as String),
    freeReward: json['free_reward'] != null
        ? RewardModel.fromJson(json['free_reward'] as Map<String, dynamic>)
        : null,
    premiumReward: json['premium_reward'] != null
        ? RewardModel.fromJson(json['premium_reward'] as Map<String, dynamic>)
        : null,
  );
}
