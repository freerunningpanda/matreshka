import '../../domain/repositories/battle_pass_repository.dart';

/// Мок "сервера": отдаёт JSON-подобные Map под каждый сценарий экрана,
/// чтобы Model.fromJson реально разбирал данные, а не просто оборачивал Dart-объекты.
class BattlePassMockApi {
  static const int _maxLevel = 40;

  static const _rewardIcons = [
    'assets/images/battle_pass/reward_lollipop.png',
    'assets/images/battle_pass/reward_passport.png',
    'assets/images/battle_pass/reward_mask_devil.png',
    'assets/images/battle_pass/reward_mask_ghost.png',
  ];

  Map<String, dynamic> fetchSeason(BattlePassScenario scenario) {
    switch (scenario) {
      case BattlePassScenario.premiumLocked:
        return _buildSeason(currentLevel: 5, premiumOwned: false);
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
      // Премиум-награда есть не на каждом уровне — только там, где и так
      // выпадает более редкий бесплатный предмет: это она "продаёт" апгрейд,
      // корону над плиткой показываем именно на таких уровнях.
      final hasPremiumTier = _rarityFor(number) != 'common';
      return {
        'number': number,
        'required_xp': number * 1000,
        'state': state,
        'free_reward': _reward(number, premium: false, claimed: claimed),
        'premium_reward': hasPremiumTier
            ? _reward(number, premium: true, claimed: premiumOwned && claimed)
            : null,
      };
    });

    return {
      'season_id': 1,
      'season_name': 'Сезон «Экспедиция»',
      'premium_owned': premiumOwned,
      'current_level': currentLevel,
      // current_level ещё не пройден — это уровень, до завершения которого
      // осталось набрать опыт, поэтому xp должен быть чуть меньше его
      // порога, а не константой, слабо связанной с currentLevel. Но на
      // максимальном уровне дальше копить нечего — там он должен быть
      // полностью пройден (иначе ромб 40 красится как недостигнутый).
      'current_xp': currentLevel >= _maxLevel
          ? currentLevel * 1000
          : currentLevel * 1000 - 450,
      'max_level': _maxLevel,
      'levels': levels,
      'season_ends_at_ms': DateTime.now()
          .add(const Duration(days: 14))
          .millisecondsSinceEpoch,
    };
  }

  String _rarityFor(int level) => level % 10 == 0
      ? 'legendary'
      : level % 5 == 0
      ? 'epic'
      : level % 3 == 0
      ? 'rare'
      : 'common';

  Map<String, dynamic> _reward(
    int level, {
    required bool premium,
    required bool claimed,
  }) {
    final iconIndex = (level - 1) % _rewardIcons.length;
    // Чип количества (×N) показываем только у леденца — у остальных наград
    // это одна штука, амаунт-чип на плитке не рисуется.
    final isLollipop = iconIndex == 0;
    // 10-й уровень — легендарный, у него свой уникальный ассет вместо
    // обычного цикла из четырёх иконок.
    final iconAsset = level == 10
        ? 'assets/images/battle_pass/case_audi.png'
        : _rewardIcons[iconIndex];
    return {
      'id': level * 10 + (premium ? 1 : 0),
      'name': premium ? 'Премиум-награда $level ур.' : 'Награда $level ур.',
      'icon_asset': iconAsset,
      'amount': premium ? 50 : (isLollipop ? 16 : 1),
      'rarity': _rarityFor(level),
      'claimed': claimed,
    };
  }
}
