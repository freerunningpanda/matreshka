import 'package:flutter/material.dart';

import '../../domain/repositories/battle_pass_repository.dart';

/// Служебный dev-контрол переключения моковых сценариев экрана (не часть
/// макета) — способ переключать состояния экрана, который просит ТЗ.
/// Свёрнут в плавающую кнопку, чтобы не перекрывать трек наград.
class ScenarioSwitcher extends StatelessWidget {
  const ScenarioSwitcher({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final BattlePassScenario current;
  final ValueChanged<BattlePassScenario> onChanged;

  static const _labels = {
    BattlePassScenario.premiumLocked: 'Премиум не куплен',
    BattlePassScenario.premiumUnlockedWithReward: 'Премиум куплен / награда',
    BattlePassScenario.maxLevel: 'Макс. уровень',
    BattlePassScenario.completed: 'Завершён',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: PopupMenuButton<BattlePassScenario>(
            initialValue: current,
            onSelected: onChanged,
            tooltip: 'Переключить сценарий (dev)',
            itemBuilder: (context) => [
              for (final scenario in BattlePassScenario.values)
                PopupMenuItem(
                  value: scenario,
                  child: Row(
                    children: [
                      if (scenario == current)
                        const Icon(Icons.check, size: 18)
                      else
                        const SizedBox(width: 18),
                      const SizedBox(width: 8),
                      Text(_labels[scenario] ?? scenario.name),
                    ],
                  ),
                ),
            ],
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.science_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
