import 'package:flutter/material.dart';

import '../../../exports.dart';

class RewardTile extends StatefulWidget {
  const RewardTile({
    required this.level,
    required this.premiumOwned,
    required this.currentXp,
    required this.onClaim,
    required this.onUnlockPremium,
    this.nextRequiredXp,
    this.hideGiftBadge = false,
    this.highlighted = false,
    this.hidePremiumBadge = false,
    this.gradientOverride,
    super.key,
  });

  final BattlePassLevel level;
  final bool premiumOwned;

  /// Сценарий "Премиум куплен / награда" (см. battle_pass_screen.dart) —
  /// значок подарка в углу плитки убран у всех уровней; корона за премиум
  /// это не затрагивает.
  final bool hideGiftBadge;

  /// Рамка 4px solid #E9E9F3 (AppColors.textPrimary) и значок подарка,
  /// даже если он скрыт для всего трека через hideGiftBadge — точечно для
  /// 97-го уровня сценария "Конец наград (Куплен премиум)" (см.
  /// battle_pass_screen.dart). Активная рамка "к клейму готово" (зелёная)
  /// всё равно перевешивает — см. showClaimUi ниже.
  final bool highlighted;

  /// Значок короны (premium.svg) не показывается совсем, даже у уровней с
  /// доступным премиум-апгрейдом — сама плитка (фиолетовая заливка, переход
  /// на покупку прокачки по тапу) не меняется. Только в сценарии "Конец
  /// наград (Не куплен премиум)" (см. battle_pass_screen.dart).
  final bool hidePremiumBadge;

  /// Принудительный градиент плитки — перевешивает и заливку по редкости, и
  /// фиолетовую "тут премиум" (showPremiumBadge). Точечно для 100-го уровня
  /// сценария "Конец наград (Не куплен премиум)" (см.
  /// battle_pass_screen.dart): его rarity уже 'legendary' (золотой), но
  /// premiumOwned: false у этого уровня делает showPremiumBadge истинным и
  /// без оверрайда перекрашивает плитку в фиолетовый.
  final Gradient? gradientOverride;

  /// Порог опыта следующего по порядку уровня — нужен, чтобы соединительная
  /// линия трека красилась по реальному прогрессу (currentXp относительно
  /// порогов), а не по грубому состоянию уровня. `null` для последнего
  /// уровня трека — линии дальше некуда идти.
  final int? nextRequiredXp;

  /// Накопленный опыт сезона — нужен, чтобы на тапе по своему текущему
  /// уровню показать реальную нехватку XP, а не общую фразу (иначе не
  /// понятно, почему уровень, на который "уже дошли", ещё не открывается).
  final int currentXp;

  final VoidCallback onClaim;
  final VoidCallback onUnlockPremium;

  @override
  State<RewardTile> createState() => _RewardTileState();
}

class _RewardTileState extends State<RewardTile> {
  /// Обычная (не премиум) доступная награда изначально выглядит как ещё не
  /// открытая — рамка и кнопка "Забрать" появляются только после первого
  /// тапа, а забирает уже второй.
  bool _selected = false;

  @override
  void didUpdateWidget(covariant RewardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level.state != widget.level.state) {
      _selected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    final reward = level.freeReward;
    final locked = level.state == LevelState.locked;
    final claimable = level.state == LevelState.claimable;
    final claimed = level.state == LevelState.claimed;
    // Свой текущий уровень тоже не забрать — XP на него ещё не набран,
    // поэтому визуально он ничем не должен отличаться от запертого: тот же
    // замок вместо картинки. Тап всё равно ведёт на конкретное "не хватает
    // N XP" через ветку ниже, а не на общее "откроется на N уровне".
    final visuallyLocked = locked || level.state == LevelState.current;
    final showPremiumBadge =
        level.premiumReward != null &&
        !widget.premiumOwned &&
        level.premiumReward?.claimed != true;
    // Корона всегда перевешивает: даже если бесплатная награда сама по себе
    // claimable, плитку с премиум-апгрейдом нельзя "забрать в два тапа" —
    // тап по ней должен вести к покупке прокачки, а не показывать "Забрать".
    final showClaimUi = claimable && _selected && !showPremiumBadge;

    final tile = RewardCarouselTile(
      asset: reward?.iconAsset ?? _placeholderAsset,
      // Уровни с доступным премиум-апгрейдом всегда красим в фиолетовый —
      // тот же цвет, что у fuel в премиум-тизере, это общий язык "тут премиум".
      gradient:
          widget.gradientOverride ??
          (showPremiumBadge
              ? AppColors.rewardTilePurpleGradient
              : _rarityGradient(reward?.rarity)),
      badge: showPremiumBadge && !widget.hidePremiumBadge
          ? RewardBadgeKind.premium
          : RewardBadgeKind.gift,
      showBadge:
          (showPremiumBadge && !widget.hidePremiumBadge) ||
          widget.highlighted ||
          !widget.hideGiftBadge,
      quantityLabel: (reward != null && reward.amount > 1)
          ? '×${reward.amount}'
          : null,
      borderColor: showClaimUi
          ? const Color(0xFF3DDC6B)
          : widget.highlighted
          ? AppColors.textPrimary
          : null,
      showGlow: showClaimUi,
      claimed: claimed,
      locked: visuallyLocked,
      // Плитка всегда кликабельна. Доступная бесплатная награда открывается
      // в два тапа: первый показывает рамку и кнопку "Забрать", второй —
      // уже забирает; премиум-плитка сразу ведёт к покупке прокачки, но
      // только если уровень уже достигнут — запертый ИЛИ текущий уровень
      // (XP ещё не набран) остаётся запертым независимо от короны, ведёт
      // к покупке прокачки нельзя раньше, чем сам уровень открылся.
      onTap: visuallyLocked
          ? () => _showTapHint(
              context,
              locked: locked,
              claimed: false,
              requiredXp: level.requiredXp,
            )
          : showPremiumBadge
          ? widget.onUnlockPremium
          : claimable
          ? (_selected
                ? widget.onClaim
                : () => setState(() => _selected = true))
          : () => _showTapHint(
              context,
              locked: locked,
              claimed: claimed,
              requiredXp: level.requiredXp,
            ),
      footer: showClaimUi ? const _ClaimButton() : null,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile,
        AppSizedBoxes.verticalSizedBoxH12,
        _LevelTrackNode(
          number: level.number,
          requiredXp: level.requiredXp,
          currentXp: widget.currentXp,
          nextRequiredXp: widget.nextRequiredXp,
        ),
      ],
    );
  }

  void _showTapHint(
    BuildContext context, {
    required bool locked,
    required bool claimed,
    required int requiredXp,
  }) {
    final missingXp = requiredXp - widget.currentXp;
    final message = locked
        ? 'Откроется на ${widget.level.number} уровне'
        : claimed
        ? 'Уже получено'
        : 'Наберите ещё $missingXp XP, чтобы открыть';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static const _placeholderAsset =
      'assets/images/battle_pass/reward_placeholder.png';

  Gradient _rarityGradient(RewardRarity? rarity) => switch (rarity) {
    RewardRarity.legendary => AppColors.rewardTileGoldGradient,
    RewardRarity.epic => AppColors.rewardTilePurpleGradient,
    RewardRarity.rare => AppColors.rewardTileBlueGradient,
    RewardRarity.common || null => AppColors.rewardTileGrayGradient,
  };
}

/// Плашка "Забрать" на нижнем крае карточки — единственный визуальный
/// признак того, что награду реально можно взять тапом; без неё плитка
/// (значок подарка/премиума сам по себе) некликабельна.
class _ClaimButton extends StatelessWidget {
  const _ClaimButton();

  @override
  Widget build(BuildContext context) {
    // Сам наклон вокруг общего с карточкой центра накладывает снаружи
    // RewardCarouselTile (см. footer в reward_carousel_tile.dart) — здесь
    // только компенсирующий встречный наклон, чтобы текст остался прямым.
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: AppColors.claimGreenGradient,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.skewX(-kRewardTileSkewAngle),
        child: const Text(
          'Забрать',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Geologica',
            fontWeight: FontWeight.w500,
            fontSize: 26,
            height: 1.2,
            letterSpacing: -0.01,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Ромб уровня + соединительная линия трека под плиткой. Каждый узел рисует
/// ТОЛЬКО отрезок ОТ своего ромба ДО следующего (а не половинки с обеих
/// сторон) — так фактическая доля прогресса (currentXp относительно порогов
/// requiredXp двух соседних уровней) кладётся на реальную геометрическую
/// длину между их центрами, а не на случайную часть её. Соседний узел слева
/// от своего ромба ничего не рисует — сегмент до него уже нарисован этим.
class _LevelTrackNode extends StatelessWidget {
  const _LevelTrackNode({
    required this.number,
    required this.requiredXp,
    required this.currentXp,
    required this.nextRequiredXp,
  });

  final int number;
  final int requiredXp;
  final int currentXp;

  /// Порог следующего уровня; `null` для последнего уровня трека — рисовать
  /// отрезок дальше некуда.
  final int? nextRequiredXp;

  static const _reachedColor = Color(0xFFE5484D);
  static const _unreachedColor = Color(0xFF4A4A52);

  /// Расстояние между центрами соседних ромбов: ширина плитки (242) плюс
  /// ширина разделителя-стрелки между ними (см. `_TrackSeparator`, ~12 —
  /// определяется её содержимым, явной ширины у неё нет).
  static const _diamondStride = 254.0;

  /// Ромб 34×34, повёрнутый на 45° — половина его диагонали (34·√2/2), т.е.
  /// на сколько его левый кончик выступает влево от центра; отрезок обрезан
  /// примерно на это расстояние до центра следующего ромба, иначе остаток
  /// (когда прогресс близок к 100%) прячется у него под иконкой.
  static const _diamondHalfSpan = 24.04;

  /// Толщина линии — половина её нужна отдельно: у ромба острый кончик
  /// (в точности на _diamondHalfSpan от центра его высота равна нулю), так
  /// что при стыковке линии ровно с кончиком по бокам виден треугольный
  /// зазор. Забираемся вглубь ромба ещё на половину толщины линии — там он
  /// уже достаточно "вырос" по высоте, чтобы полностью перекрыть линию.
  static const _lineThickness = 10.0;

  @override
  Widget build(BuildContext context) {
    final reached = currentXp >= requiredXp;
    final ownColor = reached ? _reachedColor : _unreachedColor;

    return SizedBox(
      width: 242,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (nextRequiredXp != null)
            Positioned(
              left: 121, // от центра этой плитки — ровно на ромбе
              width:
                  _diamondStride -
                  _diamondHalfSpan +
                  _lineThickness / 2 +
                  2, // небольшой запас поверх точного расчёта — иначе из-за
              // сглаживания пикселей на стыке остаётся тонкий зазор
              child: Builder(
                builder: (context) {
                  final nextReached = currentXp >= nextRequiredXp!;
                  final outColor = nextReached
                      ? _reachedColor
                      : _unreachedColor;
                  // currentXp/nextRequiredXp — та же доля, что показана в
                  // XP-пилюле наверху экрана (см. battle_pass_screen.dart,
                  // xpToNextLevel = requiredXp текущего уровня), чтобы полоса
                  // читалась согласованно с тем числом.
                  final fraction = nextRequiredXp! > 0
                      ? (currentXp / nextRequiredXp!).clamp(0.0, 1.0)
                      : (reached ? 1.0 : 0.0);
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ownColor, ownColor, outColor, outColor],
                        stops: [0, fraction, fraction, 1],
                      ),
                    ),
                    child: AppSizedBoxes.verticalSizedBoxH10,
                  );
                },
              ),
            ),
          Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: ownColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Transform.rotate(
                angle: -0.785398,
                child: Center(
                  child: Padding(
                    // Трёхзначные уровни (100+) не помещаются в ромб на
                    // полный fontSize — сжимаем, а не обрезаем цифры.
                    padding: AppPadding.horizontalPadding3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          fontFamily: 'Geologica',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
