import 'package:equatable/equatable.dart';

import 'level.dart';

class BattlePassSeason extends Equatable {
  const BattlePassSeason({
    required this.seasonId,
    required this.seasonName,
    required this.premiumOwned,
    required this.currentLevel,
    required this.currentXp,
    required this.maxLevel,
    required this.levels,
    required this.seasonEndsAt,
  });

  final int seasonId;
  final String seasonName;
  final bool premiumOwned;
  final int currentLevel;
  final int currentXp;
  final int maxLevel;
  final List<BattlePassLevel> levels;
  final DateTime seasonEndsAt;

  bool get isMaxLevel => currentLevel >= maxLevel;

  BattlePassSeason copyWith({
    bool? premiumOwned,
    int? currentLevel,
    int? currentXp,
    List<BattlePassLevel>? levels,
  }) => BattlePassSeason(
    seasonId: seasonId,
    seasonName: seasonName,
    premiumOwned: premiumOwned ?? this.premiumOwned,
    currentLevel: currentLevel ?? this.currentLevel,
    currentXp: currentXp ?? this.currentXp,
    maxLevel: maxLevel,
    levels: levels ?? this.levels,
    seasonEndsAt: seasonEndsAt,
  );

  @override
  List<Object?> get props => [
    seasonId,
    seasonName,
    premiumOwned,
    currentLevel,
    currentXp,
    maxLevel,
    levels,
    seasonEndsAt,
  ];
}
