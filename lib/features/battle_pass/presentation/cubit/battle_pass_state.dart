import 'package:equatable/equatable.dart';

import '../../domain/entities/season.dart';
import '../../domain/repositories/battle_pass_repository.dart';

sealed class BattlePassState extends Equatable {
  const BattlePassState();

  @override
  List<Object?> get props => [];
}

final class BattlePassLoading extends BattlePassState {
  const BattlePassLoading();
}

final class BattlePassLoaded extends BattlePassState {
  const BattlePassLoaded({
    required this.season,
    required this.scenario,
    required this.selectedLevel,
  });

  final BattlePassSeason season;
  final BattlePassScenario scenario;
  final int selectedLevel;

  BattlePassLoaded copyWith({
    BattlePassSeason? season,
    BattlePassScenario? scenario,
    int? selectedLevel,
  }) => BattlePassLoaded(
    season: season ?? this.season,
    scenario: scenario ?? this.scenario,
    selectedLevel: selectedLevel ?? this.selectedLevel,
  );

  @override
  List<Object?> get props => [season, scenario, selectedLevel];
}

final class BattlePassError extends BattlePassState {
  const BattlePassError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
