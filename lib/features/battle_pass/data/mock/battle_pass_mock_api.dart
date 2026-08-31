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
        return _buildSeason(
          currentLevel: 12,
          premiumOwned: true,
          // Узел из Figma для этого сценария показывает уровни 4-8 как ещё
          // не забранные — выбивается из обычного правила "claimable только
          // 3 уровня перед текущим", поэтому заданы точечным оверрайдом, а
          // не общей формулой. 4-й — "боевой" приз (пара "босс мафии" x16),
          // 5-й — с тёмной (common) заливкой, 6-8 — с фиолетовой (epic).
          claimableLevels: const {4, 5, 6, 7, 8},
          freeRewardOverrides: const {
            4: (icon: 'assets/images/battle_pass/boss.png', amount: 16),
            5: (
              icon: 'assets/images/battle_pass/premium_teaser_bag.png',
              amount: 1,
            ),
            6: (icon: 'assets/images/battle_pass/filter.png', amount: 1),
            7: (icon: 'assets/images/battle_pass/blue_devil.png', amount: 1),
            8: (icon: 'assets/images/battle_pass/green_monster.png', amount: 1),
          },
          rarityOverrides: const {5: 'common', 6: 'epic', 7: 'epic', 8: 'epic'},
        );
      case BattlePassScenario.premiumUnlockedNoReward:
        return _buildSeason(
          currentLevel: 12,
          premiumOwned: true,
          // Свой набор точечных оверрайдов, отдельный от
          // premiumUnlockedWithReward: 4-й — тёмная (common) заливка, уже
          // забран (не в claimableLevels — по дефолтной формуле уходит в
          // 'claimed', притух + галочка). 5-й тоже тёмный, но claimable —
          // без этого он уходил бы в 'claimed' точно так же, а должен
          // выглядеть обычной ещё не забранной плиткой (см.
          // RewardTile._selected). 6-8 — фиолетовая (epic), тоже claimable.
          claimableLevels: const {5, 6, 7, 8},
          freeRewardOverrides: const {
            4: (
              icon: 'assets/images/battle_pass/reward_mask_ghost.png',
              amount: 1,
            ),
            5: (
              icon: 'assets/images/battle_pass/premium_teaser_bag.png',
              amount: 1,
            ),
            6: (icon: 'assets/images/battle_pass/blue_devil.png', amount: 1),
            7: (icon: 'assets/images/battle_pass/green_monster.png', amount: 1),
            8: (icon: 'assets/images/battle_pass/bull.png', amount: 1),
          },
          rarityOverrides: const {
            4: 'common',
            5: 'common',
            6: 'epic',
            7: 'epic',
            8: 'epic',
          },
        );
      case BattlePassScenario.maxLevel:
        return _buildSeason(
          currentLevel: _maxLevel,
          premiumOwned: true,
          // Тот же точечный оверрайд, что и у "премиум куплен/награда" (см.
          // выше) — уровни 4-8 получают конкретные иконки по Figma. 4 и 5 —
          // claimable (выбиваются из обычного правила "только 3 уровня перед
          // текущим"); 6-8 уже забраны — остаются на дефолтном 'claimed' (не
          // добавлены в claimableLevels), только с этими иконками/цветом.
          // 5-й красится под редкость 4-го (common), 6-8 — под фиолетовую
          // (epic), а не свою обычную.
          claimableLevels: const {4, 5},
          freeRewardOverrides: const {
            4: (
              icon: 'assets/images/battle_pass/reward_mask_ghost.png',
              amount: 16,
            ),
            5: (
              icon: 'assets/images/battle_pass/premium_teaser_bag.png',
              amount: 16,
            ),
            6: (icon: 'assets/images/battle_pass/blue_devil.png', amount: 1),
            7: (icon: 'assets/images/battle_pass/green_monster.png', amount: 1),
            8: (icon: 'assets/images/battle_pass/bull.png', amount: 1),
          },
          rarityOverrides: const {5: 'common', 6: 'epic', 7: 'epic', 8: 'epic'},
        );
      case BattlePassScenario.maxLevelNoReward:
        return _buildSeason(
          currentLevel: _maxLevel,
          premiumOwned: true,
          // По просьбе пользователя UI-база трека наград здесь —
          // premiumUnlockedNoReward (см. выше), не maxLevel: тот же набор
          // иконок/редкостей уровней 4-8, только currentLevel сам по себе —
          // 40 (то, что и делает это "Макс. уровень"). allClaimed — здесь
          // все элементы трека уже забраны, а не только эта пятёрка.
          allClaimed: true,
          freeRewardOverrides: const {
            4: (
              icon: 'assets/images/battle_pass/reward_mask_ghost.png',
              amount: 1,
            ),
            5: (
              icon: 'assets/images/battle_pass/premium_teaser_bag.png',
              amount: 1,
            ),
            6: (icon: 'assets/images/battle_pass/blue_devil.png', amount: 1),
            7: (icon: 'assets/images/battle_pass/green_monster.png', amount: 1),
            8: (icon: 'assets/images/battle_pass/bull.png', amount: 1),
          },
          rarityOverrides: const {
            4: 'common',
            5: 'common',
            6: 'epic',
            7: 'epic',
            8: 'epic',
          },
        );
      case BattlePassScenario.completed:
        return _buildSeason(
          currentLevel: _maxLevel,
          premiumOwned: true,
          // BattlePassEndedNotice зовёт "успеть забрать оставшиеся
          // награды" — значит есть что забирать, поэтому не allClaimed:
          // уровни 4-8 остаются claimable. 4-й — ghost x16 (редкость и так
          // common по дефолтной формуле, оверрайда не требует); 5-й —
          // тёмная (common) заливка, 6-8 — фиолетовая (epic), тот же набор
          // иконок, что и у premiumUnlockedNoReward/maxLevelNoReward выше.
          claimableLevels: const {4, 5, 6, 7, 8},
          freeRewardOverrides: const {
            4: (
              icon: 'assets/images/battle_pass/reward_mask_ghost.png',
              amount: 16,
            ),
            5: (
              icon: 'assets/images/battle_pass/premium_teaser_bag.png',
              amount: 1,
            ),
            6: (icon: 'assets/images/battle_pass/blue_devil.png', amount: 1),
            7: (icon: 'assets/images/battle_pass/green_monster.png', amount: 1),
            8: (icon: 'assets/images/battle_pass/bull.png', amount: 1),
          },
          rarityOverrides: const {5: 'common', 6: 'epic', 7: 'epic', 8: 'epic'},
        );
    }
  }

  Map<String, dynamic> _buildSeason({
    required int currentLevel,
    required bool premiumOwned,
    bool allClaimed = false,
    Set<int> claimableLevels = const {},
    Map<int, ({String icon, int amount})> freeRewardOverrides = const {},
    Map<int, String> rarityOverrides = const {},
  }) {
    final levels = List.generate(_maxLevel, (index) {
      final number = index + 1;
      final state = allClaimed
          ? 'claimed'
          : number > currentLevel
          ? 'locked'
          : number == currentLevel
          ? 'current'
          : (claimableLevels.contains(number) || currentLevel - number <= 3)
          ? 'claimable'
          : 'claimed';
      final claimed = state == 'claimed';
      final rarity = rarityOverrides[number] ?? _rarityFor(number);
      // Премиум-награда есть не на каждом уровне — только там, где и так
      // выпадает более редкий бесплатный предмет: это она "продаёт" апгрейд,
      // корону над плиткой показываем именно на таких уровнях. Переопределён-
      // ная (под другой уровень) редкость тоже отменяет корону — иначе
      // заливка "как у 4-го" не сходится с тем, есть ли премиум-плитка.
      final hasPremiumTier = rarity != 'common';
      final freeOverride = freeRewardOverrides[number];
      return {
        'number': number,
        'required_xp': number * 1000,
        'state': state,
        'free_reward': _reward(
          number,
          premium: false,
          claimed: claimed,
          iconAssetOverride: freeOverride?.icon,
          amountOverride: freeOverride?.amount,
          rarityOverride: rarityOverrides[number],
        ),
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
    String? iconAssetOverride,
    int? amountOverride,
    String? rarityOverride,
  }) {
    final iconIndex = (level - 1) % _rewardIcons.length;
    // Чип количества (×N) показываем только у леденца — у остальных наград
    // это одна штука, амаунт-чип на плитке не рисуется.
    final isLollipop = iconIndex == 0;
    // 10-й уровень — легендарный, у него свой уникальный ассет вместо
    // обычного цикла из четырёх иконок.
    final iconAsset =
        iconAssetOverride ??
        (level == 10
            ? 'assets/images/battle_pass/case_audi.png'
            : _rewardIcons[iconIndex]);
    return {
      'id': level * 10 + (premium ? 1 : 0),
      'name': premium ? 'Премиум-награда $level ур.' : 'Награда $level ур.',
      'icon_asset': iconAsset,
      'amount': amountOverride ?? (premium ? 50 : (isLollipop ? 16 : 1)),
      'rarity': rarityOverride ?? _rarityFor(level),
      'claimed': claimed,
    };
  }
}
