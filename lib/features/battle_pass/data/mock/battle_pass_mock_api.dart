import '../../domain/repositories/battle_pass_repository.dart';

/// Мок "сервера": отдаёт JSON-подобные Map под каждый сценарий экрана,
/// чтобы Model.fromJson реально разбирал данные, а не просто оборачивал Dart-объекты.
class BattlePassMockApi {
  static const int _maxLevel = 40;

  Map<String, dynamic> fetchSeason(BattlePassScenario scenario) {
    switch (scenario) {
      case BattlePassScenario.premiumLocked:
        return _buildSeason(currentLevel: 7, premiumOwned: false);
      case BattlePassScenario.premiumUnlockedWithReward:
        return _buildSeason(currentLevel: 12, premiumOwned: true);
      case BattlePassScenario.maxLevel:
        return _buildSeason(currentLevel: _maxLevel, premiumOwned: true);
      case BattlePassScenario.completed:
        return _buildSeason(
          currentLevel: _maxLevel,
          premiumOwned: true,
          allClaimed: true,
        );
    }
  }

  Map<String, dynamic> _buildSeason({
    required int currentLevel,
    required bool premiumOwned,
    bool allClaimed = false,
  }) {
    final levels = List.generate(_maxLevel, (index) {
      final number = index + 1;
      final state = allClaimed
          ? 'claimed'
          : number > currentLevel
          ? 'locked'
          : number == currentLevel
          ? 'current'
          : (currentLevel - number <= 3 ? 'claimable' : 'claimed');
      final claimed = state == 'claimed';
      return {
        'number': number,
        'required_xp': number * 1000,
        'state': state,
        'free_reward': _reward(number, premium: false, claimed: claimed),
        'premium_reward': (premiumOwned || allClaimed)
            ? _reward(number, premium: true, claimed: claimed)
            : null,
      };
    });

    return {
      'season_id': 1,
      'season_name': 'Сезон «Экспедиция»',
      'premium_owned': premiumOwned,
      'current_level': currentLevel,
      'current_xp': 450,
      'max_level': _maxLevel,
      'levels': levels,
      'season_ends_at_ms': DateTime.now()
          .add(const Duration(days: 14))
          .millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> _reward(
    int level, {
    required bool premium,
    required bool claimed,
  }) {
    final rarity = level % 10 == 0
        ? 'legendary'
        : level % 5 == 0
        ? 'epic'
        : level % 3 == 0
        ? 'rare'
        : 'common';
    return {
      'id': level * 10 + (premium ? 1 : 0),
      'name': premium ? 'Премиум-награда $level ур.' : 'Награда $level ур.',
      'icon_asset': 'assets/images/battle_pass/reward_placeholder.png',
      'amount': premium ? 50 : 10,
      'rarity': rarity,
      'claimed': claimed,
    };
  }
}
