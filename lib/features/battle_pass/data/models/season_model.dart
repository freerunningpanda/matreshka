import '../../domain/entities/season.dart';
import 'level_model.dart';

final class SeasonModel extends BattlePassSeason {
  const SeasonModel({
    required super.seasonId,
    required super.seasonName,
    required super.premiumOwned,
    required super.currentLevel,
    required super.currentXp,
    required super.maxLevel,
    required super.levels,
    required super.seasonEndsAt,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
    seasonId: json['season_id'] as int,
    seasonName: json['season_name'] as String,
    premiumOwned: json['premium_owned'] as bool,
    currentLevel: json['current_level'] as int,
    currentXp: json['current_xp'] as int,
    maxLevel: json['max_level'] as int,
    levels: (json['levels'] as List<dynamic>)
        .map((e) => LevelModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    seasonEndsAt: DateTime.fromMillisecondsSinceEpoch(
      json['season_ends_at_ms'] as int,
    ),
  );
}
