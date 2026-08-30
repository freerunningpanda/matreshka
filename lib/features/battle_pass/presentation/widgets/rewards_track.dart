import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/level.dart';
import '../../domain/entities/season.dart';
import 'premium_teaser_cluster.dart';
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

  double get _leadingOffset =>
      widget.season.premiumOwned ? 0 : PremiumTeaserCluster.width;

  /// Ширина первого элемента списка — стрелка "назад" появляется, только
  /// когда он целиком уходит за левый край экрана.
  double get _firstItemExtent =>
      widget.season.premiumOwned ? _tileExtent : PremiumTeaserCluster.width / 3;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  void _onScroll() {
    final showLeftArrow = _controller.offset >= _firstItemExtent;
    final hasScrolled = _controller.offset > 0;
    if (showLeftArrow != _showLeftArrow || hasScrolled != _hasScrolled) {
      setState(() {
        _showLeftArrow = showLeftArrow;
        _hasScrolled = hasScrolled;
      });
    }
  }

  @override
  void didUpdateWidget(covariant RewardsTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.season.seasonId != widget.season.seasonId ||
        oldWidget.season.currentLevel != widget.season.currentLevel) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
    }
  }

  void _scrollToCurrent() {
    if (!_controller.hasClients) return;
    // Пока премиум не куплен, трек должен открываться с самого начала —
    // с тизером премиум-наград, а не сразу проскроленным к текущему уровню.
    if (!widget.season.premiumOwned) return;
    final target =
        _leadingOffset +
        (widget.season.currentLevel - 2).clamp(0, widget.season.levels.length) *
            _tileExtent;
    _controller.animateTo(
      target.clamp(0, _controller.position.maxScrollExtent),
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
      child: Stack(
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
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(
                icon: Icons.chevron_right,
                onTap: () => _scrollBy(_tileExtent * 3),
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
          nextReached: i + 1 < levels.length
              ? levels[i + 1].state != LevelState.locked
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
