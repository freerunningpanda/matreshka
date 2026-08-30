import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/level.dart';
import '../../domain/entities/season.dart';
import 'premium_teaser_cluster.dart';
import 'reward_carousel_tile.dart';
import 'reward_tile.dart';

class RewardsTrack extends StatefulWidget {
  const RewardsTrack({
    required this.season,
    required this.onClaim,
    required this.onUnlockPremium,
    super.key,
  });

  final BattlePassSeason season;
  final void Function(int levelNumber) onClaim;
  final VoidCallback onUnlockPremium;

  @override
  State<RewardsTrack> createState() => _RewardsTrackState();
}

class _RewardsTrackState extends State<RewardsTrack> {
  final _controller = ScrollController();
  static const double _tileExtent = 170;

  bool _showLeftArrow = false;
  bool _hasScrolled = false;
  int? _nextMilestone;

  /// Ширина первого элемента списка — стрелка "назад" появляется, только
  /// когда он целиком уходит за левый край экрана.
  double get _firstItemExtent =>
      widget.season.premiumOwned ? _tileExtent : PremiumTeaserCluster.width / 3;

  /// Смещение скролла, на котором начинается плитка уровня — та же
  /// приближённая арифметика, что уже использует `_scrollToCurrent`.
  double _offsetForLevel(int levelNumber) {
    final leading = widget.season.premiumOwned ? 0.0 : PremiumTeaserCluster.width;
    return leading + (levelNumber - 1) * _tileExtent;
  }

  /// Ближайший ещё не пройденный юбилейный уровень (10, 20, 30…) — пока он
  /// не проскроллен в начало трека, к нему ведут стрелка вправо и оверлей.
  int? _computeNextMilestone() {
    final maxLevel = widget.season.levels.length;
    for (var m = 10; m <= maxLevel; m += 10) {
      if (_controller.offset < _offsetForLevel(m)) return m;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrent();
      if (mounted) setState(() => _nextMilestone = _computeNextMilestone());
    });
  }

  void _onScroll() {
    final showLeftArrow = _controller.offset >= _firstItemExtent;
    final hasScrolled = _controller.offset > 0;
    final nextMilestone = _computeNextMilestone();
    if (showLeftArrow != _showLeftArrow ||
        hasScrolled != _hasScrolled ||
        nextMilestone != _nextMilestone) {
      setState(() {
        _showLeftArrow = showLeftArrow;
        _hasScrolled = hasScrolled;
        _nextMilestone = nextMilestone;
      });
    }
  }

  bool _allClaimed(BattlePassSeason season) =>
      season.levels.every((level) => level.state == LevelState.claimed);

  @override
  void didUpdateWidget(covariant RewardsTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // "Макс. уровень" и "Завершён" совпадают по seasonId и currentLevel (оба
    // 40) — отличаются только тем, что во втором всё уже забрано, так что
    // это тоже нужно сравнивать, иначе переключение между ними друг в друга
    // никогда не перезапускает скролл.
    if (oldWidget.season.seasonId != widget.season.seasonId ||
        oldWidget.season.currentLevel != widget.season.currentLevel ||
        _allClaimed(oldWidget.season) != _allClaimed(widget.season)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
    }
  }

  void _scrollToCurrent() {
    if (!_controller.hasClients) return;
    // Пока премиум не куплен, трек должен открываться с самого начала —
    // с тизером премиум-наград, а не сразу проскроленным вперёд.
    if (!widget.season.premiumOwned) return;
    // Сезон завершён (все уровни забраны) — открываемся у последнего
    // элемента; иначе (премиум куплен / макс. уровень, но ещё не всё
    // забрано) — смещаемся только к 2-му, тизера уже нет, но и к текущему
    // уровню, который может быть далеко, сразу прыгать не нужно.
    final target = _allClaimed(widget.season)
        ? _controller.position.maxScrollExtent
        : _tileExtent;
    _controller.animateTo(
      target.clamp(0, _controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollToMilestone(int levelNumber) {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      _offsetForLevel(levelNumber).clamp(
        0,
        _controller.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      (_controller.offset + delta).clamp(
        0,
        _controller.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  /// Плашки трека уходят под стрелки, а не обрезаются по их краю — здесь
  /// маскируем края градиентом в прозрачность вместо жёсткого кропа.
  /// Включается только после начала скролла (в исходном положении первая
  /// плашка ничем не перекрыта и обрезать её нечем), но ShaderMask остаётся
  /// в дереве всегда — если убирать его условно, ListView под ним
  /// пересоздаётся вместе со Scrollable и роняет уже начатый жест скролла.
  static const _edgeFadeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.07, 0.93, 1.0],
    colors: [
      Colors.transparent,
      Colors.black,
      Colors.black,
      Colors.transparent,
    ],
  );

  static const _noFadeGradient = LinearGradient(
    colors: [Colors.black, Colors.black],
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 346,
      right: 80,
      bottom: 24,
      height: 300,
      // Clip.none — превью юбилейного уровня выше обычной плитки (300 против
      // 240) и растёт вверх за пределы этой области, чтобы его собственный
      // ромб с номером остался на одной высоте с остальными (см.
      // _MilestonePreview).
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildTrack(),
          if (_showLeftArrow)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_left,
                  onTap: () => _scrollBy(-_tileExtent * 3),
                ),
              ),
            ),
          if (_nextMilestone != null)
            Positioned(
              right: 0,
              // Столько же места, сколько остаётся под обычной плиткой трека
              // (300 высотой минус её содержимое высотой 286) — так ромб
              // превью встаёт вровень с остальными, а не съезжает вниз.
              bottom: 14,
              child: _MilestonePreview(
                level: widget.season.levels[_nextMilestone! - 1],
                onTap: () => _scrollToMilestone(_nextMilestone!),
              ),
            ),
          Positioned(
            // Пока впереди есть непройденный юбилейный уровень, стрелка
            // сдвинута левее превью и ведёт прямиком к нему, а не листает
            // на фиксированный шаг.
            right: _nextMilestone != null ? 260 : 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(
                icon: Icons.chevron_right,
                onTap: _nextMilestone != null
                    ? () => _scrollToMilestone(_nextMilestone!)
                    : () => _scrollBy(_tileExtent * 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrack() {
    final levels = widget.season.levels;
    final items = [
      if (!widget.season.premiumOwned)
        PremiumTeaserCluster(onUnlock: widget.onUnlockPremium),
      for (var i = 0; i < levels.length; i++)
        RewardTile(
          level: levels[i],
          premiumOwned: widget.season.premiumOwned,
          currentXp: widget.season.currentXp,
          nextRequiredXp: i + 1 < levels.length
              ? levels[i + 1].requiredXp
              : null,
          onClaim: () => widget.onClaim(levels[i].number),
          onUnlockPremium: widget.onUnlockPremium,
        ),
    ];
    final listView = ListView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const _TrackSeparator(),
          items[i],
        ],
      ],
    );
    final gradient = _hasScrolled ? _edgeFadeGradient : _noFadeGradient;
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: listView,
    );
  }
}

/// Плавающее превью ближайшего непройденного юбилейного уровня (10, 20…) —
/// закреплено у правого края трека поверх обычных плиток, увеличено и
/// подсвечено оранжевой рамкой (#DA7128, не путать с зелёной "к клейму
/// готово"), пока сам уровень не проскроллен в начало. Юбилейные уровни
/// всегда легендарные (см. `BattlePassMockApi._rarityFor`), поэтому
/// градиент этой плитки золотой, без свитча по редкости.
class _MilestonePreview extends StatelessWidget {
  const _MilestonePreview({required this.level, required this.onTap});

  final BattlePassLevel level;
  final VoidCallback onTap;

  static const _accentColor = Color(0xFFDA7128);

  @override
  Widget build(BuildContext context) {
    final reward = level.freeReward;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RewardCarouselTile(
          asset: reward?.iconAsset ?? '',
          gradient: AppColors.rewardTileGoldGradient,
          badge: RewardBadgeKind.gift,
          borderColor: _accentColor,
          showGlow: true,
          onTap: onTap,
          width: 268,
          height: 268,
        ),
        const SizedBox(height: 12),
        Transform.rotate(
          angle: 0.785398, // 45°
          child: Container(
            width: 34,
            height: 34,
            // Уровень ещё не достигнут — тот же серый, что у непройденного
            // отрезка прогресс-бара под обычными плитками.
            decoration: const BoxDecoration(
              color: Color(0xFF4A4A52),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Transform.rotate(
              angle: -0.785398,
              child: Center(
                child: Text(
                  '${level.number}',
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
      ],
    );
  }
}

/// Стрелка-разделитель между плитками трека — тот же ассет, что и внутри
/// `PremiumTeaserCluster`, здесь используется между вообще всеми элементами.
/// Центрируется по высоте самой плитки (RewardCarouselTile, 240), а не по
/// всей колонке трека — иначе бейдж уровня снизу утягивает центр вниз.
/// `Align` (не `Padding`!) — ListView задаёт дочерним элементам жёсткую
/// (tight) высоту 300, и `Padding.deflate()` эту жёсткость сохраняет: любой
/// внутренний SizedBox/SvgPicture с фиксированной высотой в таком контексте
/// растягивается под оставшееся место вместо того, чтобы остаться компактным.
/// `Align` вместо этого явно ослабляет (`loosen()`) constraints ребёнка.
class _TrackSeparator extends StatelessWidget {
  const _TrackSeparator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 240,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/battle_pass/arrow.svg',
            width: 12,
            height: 20,
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: AppColors.buttonOverlayStrong,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}
