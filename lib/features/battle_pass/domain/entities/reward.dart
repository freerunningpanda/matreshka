import 'package:equatable/equatable.dart';

enum RewardRarity { common, rare, epic, legendary }

class Reward extends Equatable {
  const Reward({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.amount,
    required this.rarity,
    required this.claimed,
  });

  final int id;
  final String name;
  final String iconAsset;
  final int amount;
  final RewardRarity rarity;
  final bool claimed;

  Reward copyWith({bool? claimed}) => Reward(
    id: id,
    name: name,
    iconAsset: iconAsset,
    amount: amount,
    rarity: rarity,
    claimed: claimed ?? this.claimed,
  );

  @override
  List<Object?> get props => [id, name, iconAsset, amount, rarity, claimed];
}
