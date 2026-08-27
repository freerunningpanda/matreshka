import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/season.dart';
import 'reward_tile.dart';

class RewardsTrack extends StatefulWidget {
  const RewardsTrack({required this.season, required this.onClaim, super.key});

  final BattlePassSeason season;
  final void Function(int levelNumber) onClaim;

  @override
  State<RewardsTrack> createState() => _RewardsTrackState();
}

class _RewardsTrackState extends State<RewardsTrack> {
  final _controller = ScrollController();
  static const double _tileExtent = 170;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
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
    final target =
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 346,
      right: 80,
      bottom: 24,
      height: 300,
      child: Row(
        children: [
          _ArrowButton(
            icon: Icons.chevron_left,
            onTap: () => _scrollBy(-_tileExtent * 3),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.season.levels.length,
              itemBuilder: (context, index) {
                final level = widget.season.levels[index];
                return RewardTile(
                  level: level,
                  premiumOwned: widget.season.premiumOwned,
                  onClaim: () => widget.onClaim(level.number),
                );
              },
            ),
          ),
          _ArrowButton(
            icon: Icons.chevron_right,
            onTap: () => _scrollBy(_tileExtent * 3),
          ),
        ],
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
