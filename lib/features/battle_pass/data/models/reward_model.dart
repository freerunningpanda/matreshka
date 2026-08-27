import '../../domain/entities/reward.dart';

final class RewardModel extends Reward {
  const RewardModel({
    required super.id,
    required super.name,
    required super.iconAsset,
    required super.amount,
    required super.rarity,
    required super.claimed,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json['id'] as int,
    name: json['name'] as String,
    iconAsset: json['icon_asset'] as String,
    amount: json['amount'] as int,
    rarity: RewardRarity.values.byName(json['rarity'] as String),
    claimed: json['claimed'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon_asset': iconAsset,
    'amount': amount,
    'rarity': rarity.name,
    'claimed': claimed,
  };
}
