import 'dart:ui';

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
    this.highlightMaxLevelMilestone = false,
    this.hideGiftBadge = false,
    this.simplifyMilestonePreview = false,
    this.startScrolledToEnd = false,
    this.showSeasonEndTeaser = false,
    this.showSeasonEndTeaserRequiresPremium = false,
    this.highlightedLevelNumber,
    this.hideMilestonePremiumBadge = false,
    this.hideCarouselPremiumBadge = false,
    this.goldGradientLevelNumber,
    super.key,
  });

  final BattlePassSeason season;
  final void Function(int levelNumber) onClaim;
  final VoidCallback onUnlockPremium;

  /// Трек открывается сразу у последнего элемента списка — только в
  /// сценарии "Конец наград (Куплен премиум)" (см. battle_pass_screen.dart).
  /// Явный флаг, а не вывод из season (например season.levels.every
  /// (claimed)): season здесь та же, что у premiumUnlockedWithReward
  /// (тот же seasonId/currentLevel), где скроллить к концу не нужно.
  final bool startScrolledToEnd;

  /// Ромб плавающего превью юбилейного уровня красится в
  /// AppColors.milestoneDiamondMaxLevel вместо обычного серого — только в
  /// сценарии "Макс. уровень / Много наград" (см. battle_pass_screen.dart).
  final bool highlightMaxLevelMilestone;

  /// Значок подарка убран у всех обычных плиток трека — только в сценарии
  /// "Премиум куплен / награда" (см. battle_pass_screen.dart).
  final bool hideGiftBadge;

  /// У плавающего превью юбилейного уровня убрана корона (premium.svg), а
  /// рамка всегда белая (#E9E9F3, 4px) вместо оранжевой "к клейму готово" —
  /// независимо от того, забран сам уровень или нет. Только в сценарии
  /// "Battle Pass завершен" (см. battle_pass_screen.dart).
  final bool simplifyMilestonePreview;

  /// Карточка "следующий сезон" в самом конце трека (после последнего
  /// уровня) — только в сценариях "Конец наград (Куплен/Не куплен
  /// премиум)" (см. battle_pass_screen.dart).
  final bool showSeasonEndTeaser;

  /// Текст карточки "следующий сезон" — "нужна прокачка" вместо "откроются
  /// после уровня N". Только в сценарии "Конец наград (Не куплен премиум)"
  /// (см. battle_pass_screen.dart).
  final bool showSeasonEndTeaserRequiresPremium;

  /// Номер уровня, чья плитка получает рамку 4px solid #E9E9F3 и значок
  /// подарка независимо от hideGiftBadge — точечно 97-й уровень в сценарии
  /// "Конец наград (Куплен премиум)" (см. battle_pass_screen.dart). `null`
  /// (по умолчанию) — ни одна плитка не подсвечена.
  final int? highlightedLevelNumber;

  /// Плавающее превью юбилейного уровня — без короны (premium.svg), но с
  /// обычным (не всегда белым) цветом рамки, в отличие от
  /// simplifyMilestonePreview. Только в сценарии "Конец наград (Куплен
  /// премиум)" (см. battle_pass_screen.dart).
  final bool hideMilestonePremiumBadge;

  /// Значок короны (premium.svg) убран у всех элементов карусели — обычных
  /// плиток трека и премиум-тизера в начале (PremiumTeaserCluster). Только
  /// в сценарии "Конец наград (Не куплен премиум)" (см.
  /// battle_pass_screen.dart).
  final bool hideCarouselPremiumBadge;

  /// Номер уровня, чья плитка красится в rewardTileGoldGradient независимо
  /// от rarity/премиум-апгрейда — точечно 100-й уровень сценария "Конец
  /// наград (Не куплен премиум)" (см. battle_pass_screen.dart): его rarity
  /// и так 'legendary' (золотой), но premiumOwned: false перекрашивает его
  /// в фиолетовый "тут премиум" без этого оверрайда. `null` (по умолчанию)
  /// — ни одна плитка не переопределена.
  final int? goldGradientLevelNumber;

  @override
  State<RewardsTrack> createState() => _RewardsTrackState();
}

class _RewardsTrackState extends State<RewardsTrack> {
  final _controller = ScrollController();

  // Реальный шаг между соседними уровнями в списке: ширина плитки (242,
  // RewardCarouselTile.width по умолчанию) плюс ширина разделителя-стрелки
  // между ними (~12, см. _TrackSeparator/_LevelTrackNode._diamondStride в
  // reward_tile.dart — те же 254). Заниженное значение почти не заметно на
  // первом прыжке (к 10-му уровню), но накапливается с каждым следующим
  // юбилейным — к 40-му промах достигал (254-170)*39 ≈ 3276px, и прыжок
  // останавливался далеко до цели.
  static const double _tileExtent = 254;

  bool _showLeftArrow = false;
  bool _showRightArrow = true;
  bool _hasScrolled = false;
  int? _nextMilestone;

  /// Ширина первого элемента списка — стрелка "назад" появляется, только
  /// когда он целиком уходит за левый край экрана.
  double get _firstItemExtent =>
      widget.season.premiumOwned ? _tileExtent : PremiumTeaserCluster.width / 3;

  /// Смещение скролла, на котором начинается плитка уровня — та же
  /// приближённая арифметика, что уже использует `_scrollToCurrent`.
  double _offsetForLevel(int levelNumber) {
    final leading = widget.season.premiumOwned
        ? 0.0
        : PremiumTeaserCluster.width;
    return leading + (levelNumber - 1) * _tileExtent;
  }

  /// Половина разницы между шириной вьюпорта и шагом плитки — на столько
  /// _scrollToMilestone недокручивает от _offsetForLevel, чтобы плитка
  /// вставала по центру, а не впритык к левому краю. Тот же порог нужен и
  /// здесь: иначе после центрированного прыжка на уровень m «пройденным»
  /// он не считается (offset после прыжка меньше offsetForLevel(m)), ромб
  /// предпросмотра залипает и дальнейшие прыжки не работают.
  double get _viewportHalfGap {
    if (!_controller.hasClients) return 0;
    return (_controller.position.viewportDimension - _tileExtent) / 2;
  }

  double _centeredOffsetForLevel(int levelNumber) =>
      _offsetForLevel(levelNumber) - _viewportHalfGap;

  /// Идёт программный прыжок скролла (_scrollToCurrent) — на время самой
  /// анимации превью юбилейного уровня не пересчитывается вовсе, а не
  /// мелькает по каждому пройденному уровню (10, 20…) на пути к цели. Только
  /// у "Конец наград (Куплен премиум)" (см. RewardsTrack.startScrolledToEnd)
  /// прыжок достаточно длинный, чтобы это было заметно — у остальных
  /// сценариев короткий прыжок ни один порог юбилейного уровня не пересекает,
  /// так что флаг для них по факту не влияет на видимый результат.
  bool _isAutoScrolling = false;

  /// Ближайший ещё не пройденный юбилейный уровень (10, 20, 30…) — пока он
  /// не проскроллен в начало трека, к нему ведут стрелка вправо и оверлей.
  int? _computeNextMilestone() {
    if (_isAutoScrolling) return null;
    final maxLevel = widget.season.levels.length;
    // Центрированный порог последнего уровня физически недостижим — под
    // ним нет содержимого, чтобы дотянуть его до середины вьюпорта, и
    // список упирается в maxScrollExtent раньше. Без клампа порог остаётся
    // недостижим сколько ни скролль — превью 40-го уровня зависает навсегда
    // и закрывает собой финальную плитку. Клампим порог до реально
    // доступного конца скролла: дошли до конца — уровень пройден.
    final maxScrollExtent = _controller.hasClients
        ? _controller.position.maxScrollExtent
        : double.infinity;
    int? candidate;
    for (var m = 10; m <= maxLevel; m += 10) {
      final threshold = _centeredOffsetForLevel(m).clamp(0, maxScrollExtent);
      if (_controller.offset < threshold) {
        candidate = m;
        break;
      }
    }
    if (candidate == null) return null;
    // Превью только что было скрыто (весь трек пройден или конец
    // автоскролла) — при обратном скролле оно не должно вспыхивать сразу же
    // по достижении 100, 99 или 98 уровня: сначала должен показаться 97-й.
    // Порог самого найденного кандидата (100) при этом не трогаем — иначе
    // вместо него возвращался бы более ранний юбилейный уровень (10), у
    // которого порог тоже пройден. Только в сценарии "Конец наград (Куплен
    // премиум)" (см. showSeasonEndTeaser) — там это реально происходит
    // (startScrolledToEnd долистывает до самого конца).
    if (widget.showSeasonEndTeaser &&
        _nextMilestone == null &&
        _controller.offset >=
            _centeredOffsetForLevel(97).clamp(0, maxScrollExtent)) {
      return null;
    }
    return candidate;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrent();
      if (mounted) {
        setState(() {
          _nextMilestone = _computeNextMilestone();
          _showRightArrow = !_atScrollEnd;
        });
      }
    });
  }

  /// Правый край списка физически достигнут — стрелка вправо (та, что ведёт
  /// дальше по треку, а не к юбилейному уровню — см. build) дальше скроллить
  /// уже некуда, поэтому прячется.
  bool get _atScrollEnd =>
      _controller.hasClients &&
      _controller.offset >= _controller.position.maxScrollExtent - 1;

  void _onScroll() {
    final showLeftArrow = _controller.offset >= _firstItemExtent;
    final showRightArrow = !_atScrollEnd;
    final hasScrolled = _controller.offset > 0;
    final nextMilestone = _computeNextMilestone();
    if (showLeftArrow != _showLeftArrow ||
        showRightArrow != _showRightArrow ||
        hasScrolled != _hasScrolled ||
        nextMilestone != _nextMilestone) {
      setState(() {
        _showLeftArrow = showLeftArrow;
        _showRightArrow = showRightArrow;
        _hasScrolled = hasScrolled;
        _nextMilestone = nextMilestone;
      });
    }
  }

  @override
  void didUpdateWidget(covariant RewardsTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.season.seasonId != widget.season.seasonId ||
        oldWidget.season.currentLevel != widget.season.currentLevel ||
        oldWidget.startScrolledToEnd != widget.startScrolledToEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
    }
  }

  void _scrollToCurrent() {
    if (!_controller.hasClients) return;
    // Пока премиум не куплен, трек должен открываться с самого начала —
    // с тизером премиум-наград, а не сразу проскроленным вперёд. Кроме
    // startScrolledToEnd ("Конец наград" — и с премиумом, и без): туда
    // нужно долистать до конца независимо от того, куплен премиум или нет.
    if (!widget.season.premiumOwned && !widget.startScrolledToEnd) return;
    // "Конец наград" — сразу к последнему элементу; иначе — смещаемся
    // только к 2-му, тизера уже нет, но и к текущему уровню, который может
    // быть далеко, сразу прыгать не нужно.
    final target = widget.startScrolledToEnd
        ? _controller.position.maxScrollExtent
        : _tileExtent;
    // Только у startScrolledToEnd прыжок достаточно длинный, чтобы по пути
    // пересечь пороги нескольких юбилейных уровней подряд — без подавления
    // превью мелькало бы "10, 20, 30…" за одну 500-мс анимацию. У короткого
    // прыжка (_tileExtent) порог первого уровня всё равно не пересекается,
    // так что для остальных сценариев подавлять нечего — флаг не трогаем.
    if (widget.startScrolledToEnd) _isAutoScrolling = true;
    _controller
        .animateTo(
          target.clamp(0, _controller.position.maxScrollExtent),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        )
        .then((_) {
          if (!mounted) return;
          if (widget.startScrolledToEnd) {
            // maxScrollExtent сразу после animateTo — ещё не окончательное
            // значение (см. _settleAtEnd), а у длинного трека с большим
            // ведущим виджетом (PremiumTeaserCluster) может застрять
            // заниженным — одного jumpTo(maxScrollExtent) недостаточно.
            _settleAtEnd();
            return;
          }
          setState(() {
            _isAutoScrolling = false;
            _nextMilestone = _computeNextMilestone();
          });
        });
  }

  /// maxScrollExtent, прочитанный сразу после animateTo, — лишь оценка:
  /// SliverList без itemExtent экстраполирует её по уже построенным
  /// (видимым + в пределах cacheExtent) детям, а не по всем ~100 плиткам
  /// трека сразу. У "Не куплен премиум" самый первый построенный элемент —
  /// PremiumTeaserCluster шириной 676 вместо обычных ~254 — сильно
  /// перекашивает эту оценку, и она застревает заниженной: ClampingScroll
  /// Physics каждый кадр обрезает офсет по текущей (ещё не окончательной)
  /// оценке, а раз офсет не растёт — Sliver не строит следующих детей, и
  /// оценка не уточняется дальше. Поэтому коррекция не одноразовая: прыгаем
  /// на текущий maxScrollExtent и на следующем кадре проверяем, вырос ли
  /// он — пока растёт, кадр за кадром достраиваются новые плитки; как
  /// только два кадра подряд дают одно и то же значение, конец
  /// действительно достигнут.
  void _settleAtEnd([double? previousExtent]) {
    if (!mounted || !_controller.hasClients) {
      _isAutoScrolling = false;
      return;
    }
    final extent = _controller.position.maxScrollExtent;
    _controller.jumpTo(extent);
    if (previousExtent != null && extent <= previousExtent + 0.5) {
      setState(() {
        _isAutoScrolling = false;
        _nextMilestone = _computeNextMilestone();
      });
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _settleAtEnd(extent));
  }

  void _scrollToMilestone(int levelNumber) {
    if (!_controller.hasClients) return;
    // Целевая плитка встаёт примерно по центру видимой области трека, а не
    // впритык к её левому краю (см. _centeredOffsetForLevel — тот же порог
    // использует _computeNextMilestone, иначе после прыжка ромб предпросмотра
    // не продвигается дальше).
    final target = _centeredOffsetForLevel(levelNumber);
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

  /// Тот же левый fade, что у `_edgeFadeGradient`, но без правого — только
  /// для карточки "следующий сезон" (см. showSeasonEndTeaser) на самом конце
  /// трека: она последний элемент, дальше скроллить некуда, поэтому её
  /// рамка не должна частично гаснуть у правого края.
  static const _leftOnlyFadeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.07],
    colors: [Colors.transparent, Colors.black],
  );

  /// Расстояние от правого края трека до середины стрелки, ведущей к
  /// юбилейному уровню (см. её же `right`/паддинг ниже в build) — начиная
  /// отсюда плитки уже не должны рендериться вовсе.
  static double get _milestoneArrowMidpoint => _MilestonePreview._cardSize + 55;

  /// Плитки трека гаснут (alpha 0) уже на середине стрелки, а не жёстко
  /// подрезаются под неё — те же стопы, что и обычный `_edgeFadeGradient`,
  /// но правый край выражен в пикселях от `_milestoneArrowMidpoint`, а не
  /// фиксированным процентом ширины трека.
  Gradient _trackFadeGradient(double width) {
    if (_nextMilestone == null) {
      if (!_hasScrolled) return _noFadeGradient;
      if (widget.showSeasonEndTeaser && _atScrollEnd) {
        return _leftOnlyFadeGradient;
      }
      return _edgeFadeGradient;
    }
    const transitionWidth = 150.0;
    final fadeEndStop = 1 - _milestoneArrowMidpoint / width;
    final fadeStartStop =
        1 - (_milestoneArrowMidpoint + transitionWidth) / width;
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [
        0.0,
        _hasScrolled ? 0.07 : 0.0,
        fadeStartStop.clamp(0.0, 1.0),
        fadeEndStop.clamp(0.0, 1.0),
      ],
      colors: const [
        Colors.transparent,
        Colors.black,
        Colors.black,
        Colors.transparent,
      ],
    );
  }

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
          if (_nextMilestone != null)
            // Плитки трека, которые превью юбилейного уровня перекрывает
            // собой, не подрезаются жёстко — сами гаснут (alpha 0) уже на
            // середине стрелки (см. _trackFadeGradient), а блюр здесь лишь
            // смягчает переход между чёткими плитками и уже погасшими:
            // сам невидим по краям зоны и виден только в середине перехода.
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: _milestoneArrowMidpoint + 150,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  stops: [0.0, 0.35, 0.7, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                ).createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          if (_showLeftArrow)
            Positioned(
              // На одной линии со стрелкой к юбилейному уровню — обе
              // стрелки трека должны стоять на одной высоте.
              left: 0,
              top: _MilestonePreview.cardCenterY - 32,
              child: _ArrowButton(
                icon: Icons.chevron_left,
                onTap: () => _scrollBy(-_tileExtent * 3),
              ),
            ),
          if (_nextMilestone != null)
            Positioned(
              right: 0,
              // Столько же места, сколько остаётся под обычной плиткой трека
              // (300 высотой минус её содержимое высотой 286) — так ромб
              // превью встаёт вровень с остальными, а не съезжает вниз.
              bottom: _MilestonePreview._bottomMargin,
              child: _MilestonePreview(
                level: widget.season.levels[_nextMilestone! - 1],
                onTap: () => _scrollToMilestone(_nextMilestone!),
                diamondColor: widget.highlightMaxLevelMilestone
                    ? AppColors.milestoneDiamondMaxLevel
                    : null,
                simplified: widget.simplifyMilestonePreview,
                hidePremiumBadge: widget.hideMilestonePremiumBadge,
              ),
            ),
          if (_nextMilestone != null)
            Positioned(
              // Превью юбилейного уровня растёт вверх от общей нижней линии
              // трека (см. _MilestonePreview) — стрелка должна указывать на
              // его собственный центр, а не на центр всей 300-высокой
              // области, иначе она указывает заметно ниже самой карточки.
              //
              // 13px — горизонтальный отступ между самой кнопкой (не рамкой
              // Positioned) и превью: ширина карточки превью + 13 минус
              // собственный горизонтальный паддинг _ArrowButton (8), на
              // который её видимый круг уже отступает от границ Positioned.
              right: _MilestonePreview._cardSize + 13 - 8,
              top: _MilestonePreview.cardCenterY - 32,
              child: _ArrowButton(
                icon: Icons.chevron_right,
                onTap: () => _scrollToMilestone(_nextMilestone!),
              ),
            )
          else if (_showRightArrow)
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
        PremiumTeaserCluster(
          onUnlock: widget.onUnlockPremium,
          hidePremiumBadge: widget.hideCarouselPremiumBadge,
        ),
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
          hideGiftBadge: widget.hideGiftBadge,
          highlighted: widget.highlightedLevelNumber == levels[i].number,
          hidePremiumBadge: widget.hideCarouselPremiumBadge,
          gradientOverride: widget.goldGradientLevelNumber == levels[i].number
              ? AppColors.rewardTileGoldGradient
              : null,
        ),
      if (widget.showSeasonEndTeaser)
        _SeasonEndTeaser(
          maxLevel: levels.length,
          requiresPremium: widget.showSeasonEndTeaserRequiresPremium,
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
    return ShaderMask(
      shaderCallback: (bounds) =>
          _trackFadeGradient(bounds.width).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: listView,
    );
  }
}

/// Плавающее превью ближайшего непройденного юбилейного уровня (10, 20…) —
/// закреплено у правого края трека поверх обычных плиток, увеличено и
/// подсвечено оранжевой рамкой (#DA7128, не путать с зелёной "к клейму
/// готово") с отдельным по цвету свечением (#E23600, blur 45.1 — по спеке
/// из Figma), пока сам уровень не проскроллен в начало. Фон карточки —
/// обычный тёмно-серый (как у прочих плиток), градиент по редкости здесь
/// не показателен: акцент даёт корона + рамка + свечение, а не заливка.
class _MilestonePreview extends StatelessWidget {
  const _MilestonePreview({
    required this.level,
    required this.onTap,
    this.diamondColor,
    this.simplified = false,
    this.hidePremiumBadge = false,
  });

  final BattlePassLevel level;
  final VoidCallback onTap;

  /// Переопределяет цвет ромба ниже (по умолчанию — обычный серый
  /// _defaultDiamondColor); см. RewardsTrack.highlightMaxLevelMilestone.
  final Color? diamondColor;

  /// См. RewardsTrack.simplifyMilestonePreview — без короны, рамка всегда
  /// белая независимо от claimed.
  final bool simplified;

  /// Убирает только корону (premium.svg), не трогая цвет рамки — в отличие
  /// от `simplified`, которая меняет и то и другое разом. Только в сценарии
  /// "Конец наград (Куплен премиум)" (см.
  /// RewardsTrack.hideMilestonePremiumBadge).
  final bool hidePremiumBadge;

  static const _accentColor = Color(0xFFDA7128);
  static const _glowColor = Color(0xFFE23600);
  static const _defaultDiamondColor = Color(0xFF4A4A52);

  /// Заливка карточки — тёмно-серый вверху, переходящий в тот же оранжевый,
  /// что и рамка, ближе к низу (за ящиком), а не ровный серый фон и не
  /// сплошной оранжевый на весь фон.
  static const _cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1B20), _accentColor],
  );

  static const _cardSize = 268.0;
  static const _spacer = 12.0;
  static const _diamondSize = 34.0;
  static const _bottomMargin = 14.0;

  /// Вертикальный центр самой карточки (без ромба) в координатах области
  /// трека высотой 300 — карточка растёт вверх от общей нижней линии
  /// (`bottom: _bottomMargin`), поэтому её центр заметно выше середины
  /// всей 300-высокой области. Используется, чтобы стрелка-подсказка
  /// указывала на центр карточки, а не терялась ниже неё.
  static double get cardCenterY {
    const columnHeight = _cardSize + _spacer + _diamondSize;
    const columnBottom = 300 - _bottomMargin;
    const columnTop = columnBottom - columnHeight;
    return columnTop + _cardSize / 2;
  }

  @override
  Widget build(BuildContext context) {
    final reward = level.freeReward;
    // Уже забранный юбилейный уровень (просто ещё не проскроленный мимо —
    // см. RewardsTrack._computeNextMilestone) показывается как обычная
    // забранная плитка: притушен, done.svg вместо короны/подарка в углу,
    // рамка #E9E9F3 4px без свечения вместо оранжевого "к клейму готово" —
    // и, в отличие от остального контента, не тускнеет вместе с ним.
    final claimed = level.state == LevelState.claimed;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RewardCarouselTile(
          asset: reward?.iconAsset ?? '',
          gradient: _cardGradient,
          badge: RewardBadgeKind.premium,
          showBadge: !claimed && !simplified && !hidePremiumBadge,
          borderColor: (claimed || simplified)
              ? AppColors.textPrimary
              : _accentColor,
          borderIgnoresOpacity: claimed,
          showGlow: !claimed,
          glowColor: _glowColor,
          glowBlurRadius: 45.1,
          glowSpreadRadius: 0,
          claimed: claimed,
          onTap: onTap,
          width: _cardSize,
          height: _cardSize,
        ),
        const SizedBox(height: _spacer),
        Transform.rotate(
          angle: 0.785398, // 45°
          child: Container(
            width: _diamondSize,
            height: _diamondSize,
            // Уровень ещё не достигнут — тот же серый, что у непройденного
            // отрезка прогресс-бара под обычными плитками (если не
            // переопределён diamondColor — см. выше).
            decoration: BoxDecoration(
              color: diamondColor ?? _defaultDiamondColor,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
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

/// Карточка "следующий сезон" в самом конце трека (см.
/// RewardsTrack.showSeasonEndTeaser) — колонка той же высоты, что и обычная
/// плитка (карточка 240 + отступ 12 + ряд ромбов 34 = 286), чтобы встать в
/// ряд с остальными элементами ListView без отдельного позиционирования.
class _SeasonEndTeaser extends StatelessWidget {
  const _SeasonEndTeaser({
    required this.maxLevel,
    this.requiresPremium = false,
  });

  final int maxLevel;

  /// См. RewardsTrack.showSeasonEndTeaserRequiresPremium — меняет текст
  /// карточки на "нужна прокачка" вместо "откроются после уровня N".
  final bool requiresPremium;

  /// Уровень-ориентир следующего "сезона" наград, показанный в конце
  /// прерывистого сегмента — по референсу из Figma.
  static const _nextSeasonLevel = 120;

  @override
  Widget build(BuildContext context) {
    // Тот же левый отступ (21), что у видимой карточки обычной плитки
    // (RewardCarouselTile: left:21 внутри бокса 242 шириной) — иначе
    // расстояние от _TrackSeparator до рамки тизера меньше, чем между ним
    // и обычной плиткой. Правый отступ той же величины — буфер под наклон
    // (kRewardTileSkewAngle): сам Transform не резервирует под сдвиг место
    // в layout, а это последний элемент списка — без запаса справа
    // maxScrollExtent заканчивается раньше, чем скошенный правый край рамки
    // на самом деле дорисован, и его обрезает Viewport.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TeaserCard(maxLevel: maxLevel, requiresPremium: requiresPremium),
          const SizedBox(height: 12),
          _TeaserTrackRow(
            nextLevel: maxLevel + 1,
            finalLevel: _nextSeasonLevel,
          ),
        ],
      ),
    );
  }
}

class _TeaserCard extends StatelessWidget {
  const _TeaserCard({required this.maxLevel, this.requiresPremium = false});

  final int maxLevel;
  final bool requiresPremium;

  @override
  Widget build(BuildContext context) {
    // Тот же наклон, что у остальных плиток трека (kRewardTileSkewAngle) —
    // рамка наклонена вместе с фоном, текст внутри контрнаклонён отдельным
    // слоем, чтобы остаться прямым (см. RewardCarouselTile/_ClaimButton).
    // Высота самой рамки (184) и отступ сверху (28) — те же, что у видимой
    // карточки обычной плитки (RewardCarouselTile.cardHeight = height-56 =
    // 240-56=184, top:28 внутри общего слота высотой 240).
    return SizedBox(
      height: 240,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.skewX(kRewardTileSkewAngle),
            child: Container(
              width: 439,
              height: 184,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.progressRingFill,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.skewX(-kRewardTileSkewAngle),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                      height: 1.35,
                      letterSpacing: -0.26,
                      color: AppColors.textMuted,
                    ),
                    children: requiresPremium
                        ? [
                            TextSpan(text: 'Награды $maxLevel+ уровней '),
                            const TextSpan(text: 'доступны только\nс '),
                            const TextSpan(
                              text: 'прокачкой',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ]
                        : [
                            const TextSpan(
                              text: 'Награды откроются после прохождения ',
                            ),
                            TextSpan(
                              text: '$maxLevel уровня',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Прерывистый сегмент трека от `nextLevel` (сразу за последним реальным
/// уровнем — его собственный ромб рисует сам RewardTile, здесь не
/// дублируется) до `finalLevel`, по дизайну: сплошная линия к `nextLevel`
/// (продолжает линию последнего реального уровня — сам он её не дорисовывает,
/// см. RewardTile.nextRequiredXp — у последнего уровня трека всегда null),
/// затем зазор, ряд коротких равных чёрточек вместо промежуточных ромбов (их
/// слишком много, чтобы рисовать каждый — тот же язык, что у
/// _ProgressDashes в tasks_teaser_card.dart) и ещё один зазор перед
/// финальным ромбом.
class _TeaserTrackRow extends StatelessWidget {
  const _TeaserTrackRow({required this.nextLevel, required this.finalLevel});

  final int nextLevel;
  final int finalLevel;

  static const _color = Color(0xFF4A4A52);

  /// Ширины чёрточек пунктира: крайние — короткие, три средних — длиннее и
  /// одного размера между собой (см. дизайн).
  static const _dashWidths = [20.0, 32.0, 32.0, 32.0, 20.0];

  /// Толщина линии — та же, что у обычных соединительных линий трека, см.
  /// _LevelTrackNode._lineThickness в reward_tile.dart (там она приватная,
  /// значение продублировано).
  static const _lineThickness = 10.0;

  /// border-image-source пунктира по дизайну: linear-gradient(90deg,
  /// #2D2E34 0%, #5D5D6D 50%, #2D2E34 100%) — сплошной градиент через весь
  /// ряд чёрточек (не у каждой свой), поэтому рисуется одним ShaderMask
  /// поверх всего Row, а не покраской отдельных Container.
  static const _dashGradient = LinearGradient(
    colors: [Color(0xFF2D2E34), Color(0xFF5D5D6D), Color(0xFF2D2E34)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Расстояние от левого края этого виджета до ПРАВОГО (видимого) края ромба
  /// настоящего последнего уровня (100), чью исходящую линию сам он не
  /// рисует — RewardTile.nextRequiredXp у последнего уровня трека всегда
  /// null: половина его собственного слота (242/2=121) минус половина
  /// диагонали ромба (34·√2/2≈24.04, тот же _diamondHalfSpan, что в
  /// reward_tile.dart) + ширина стрелки-разделителя между элементами списка
  /// (12, см. _TrackSeparator) + левый отступ этого виджета под рамку
  /// карточки (21, см. _SeasonEndTeaser). Останавливается у края ромба, а не
  /// у его центра — этот виджет красится позже (выше по z) реального тайла,
  /// поэтому линия до центра перекрывала бы цифры номера. +6 сверху —
  /// скруглённые углы ромба (borderRadius:6) немного "срезают" его острый
  /// кончик, без запаса между линией и видимым краем оставался зазор.
  static const _backReach = 121.0 - 24.04 + 12.0 + 21.0 + 6.0;

  /// Промежуток между видимыми краями соседних ромбов у обычного сегмента
  /// трека (99→100 и т.п.): _diamondStride − 2·_diamondHalfSpan ≈
  /// 254 − 48.08 ≈ 205.92 (те же константы, что в reward_tile.dart). Обе
  /// линии этого ряда (100→101 и 101→120) — той же длины, несмотря на то что
  /// вторая символически пропускает уровни 102-119.
  static const _standardSegmentGap = 205.92;

  /// Видимая (в пределах этого виджета) часть ведущей линии к 101-му — вместе
  /// с _backReach должна давать _standardSegmentGap.
  static const _leadingLineWidth = _standardSegmentGap - _backReach;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 439,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -_backReach,
            top: (34 - _lineThickness) / 2,
            width: _backReach,
            height: _lineThickness,
            child: const ColoredBox(color: _color),
          ),
          Row(
            children: [
              const SizedBox(
                width: _leadingLineWidth,
                child: ColoredBox(
                  color: _color,
                  child: SizedBox(height: _lineThickness),
                ),
              ),
              _TeaserDiamond(number: nextLevel),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => _dashGradient.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < _dashWidths.length; i++) ...[
                      if (i > 0) const SizedBox(width: 10),
                      Container(
                        width: _dashWidths[i],
                        height: _lineThickness,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            _lineThickness / 2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _TeaserDiamond(number: finalLevel),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeaserDiamond extends StatelessWidget {
  const _TeaserDiamond({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45°
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _TeaserTrackRow._color,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Transform.rotate(
          angle: -0.785398,
          child: Center(
            child: Padding(
              // Трёхзначные уровни (100+) не помещаются в ромб на полный
              // fontSize — сжимаем, а не обрезаем цифры (см. тот же приём в
              // _LevelTrackNode, reward_tile.dart).
              padding: const EdgeInsets.symmetric(horizontal: 3),
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
            width: 84,
            height: 84,
            child: Icon(icon, color: Colors.white, size: 56),
          ),
        ),
      ),
    );
  }
}
