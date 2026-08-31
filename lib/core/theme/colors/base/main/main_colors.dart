import 'package:flutter/material.dart';

/// [MainColors] - основные цвета приложения.
abstract class MainColors {
  /// Создаёт экземпляр [MainColors].
  const MainColors({
    required this.screenBackground,
    required this.navOverlay,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentGold,
    required this.buttonOverlayWeak,
    required this.buttonOverlayStrong,
    required this.progressRingTrack,
    required this.progressRingFill,
    required this.taskCardHeaderBg,
    required this.taskCardBodyBg,
    required this.taskChipBg,
    required this.tasksScreenBackground,
    required this.claimGreenTop,
    required this.claimGreenBottom,
    required this.claimPurpleTop,
    required this.claimPurpleBottom,
    required this.claimXpButtonTop,
    required this.claimXpButtonBottom,
    required this.claimXpText,
    required this.claimReadyBorder,
    required this.milestoneDiamondMaxLevel,
    required this.milestonePreviewAccent,
    required this.milestonePreviewGlow,
    required this.trackNodeDefault,
    required this.trackNodeReached,
    required this.dashGradientMid,
    required this.glowGold,
    required this.glowShadow,
    required this.timerText,
    required this.countdownPillText,
    required this.eventTitleTop,
    required this.eventTitleBottom,
    required this.itemTagText,
    required this.itemTagGradientTop,
    required this.itemTagGradientBottom,
    required this.buttonShineStart,
    required this.buttonShineSoft,
    required this.buttonShineCore,
    required this.buttonShineFade,
    required this.buttonShineEnd,
    required this.levelUpBorderOrange,
    required this.levelUpBorderYellow,
    required this.levelUpBorderLight,
    required this.levelUpBorderAmber,
    required this.levelUpBorderCoral,
    required this.rewardTileGrayDark,
    required this.rewardTileGrayMid,
    required this.rewardTileGrayLight,
    required this.rewardTileBlueDark,
    required this.rewardTileBlueMid,
    required this.rewardTileBlueLight,
    required this.rewardTilePurpleDark,
    required this.rewardTilePurpleMid,
    required this.rewardTilePurpleLight,
    required this.rewardTileGoldDark,
    required this.rewardTileGoldMid,
    required this.rewardTileGoldLight,
    required this.unlockStickerBg,
    required this.unlockStickerTextShadow,
    required this.endedNoticeFlatBg,
    required this.endedNoticeSheenTransparent,
    required this.endedNoticeSheenHighlight,
    required this.quantityChipBg,
    required this.appColorWhite,
    required this.appColorBlack,
    required this.appColorTransparent,
  });

  /// Фон экрана Battle Pass.
  final Color screenBackground;

  /// Затемнение поверх левой панели навигации.
  final Color navOverlay;

  /// Основной цвет текста.
  final Color textPrimary;

  /// Вторичный (приглушённый) цвет текста.
  final Color textSecondary;

  /// Акцентный золотой цвет.
  final Color accentGold;

  /// Слабая заливка поверх кнопок (hover/overlay).
  final Color buttonOverlayWeak;

  /// Сильная заливка поверх кнопок (hover/overlay), совпадает с
  /// [progressRingTrack] по значению, но используется в другом контексте.
  final Color buttonOverlayStrong;

  /// Непройденный (фоновый) отрезок кольцевого прогресс-бара.
  final Color progressRingTrack;

  /// Заполненный отрезок кольцевого прогресс-бара.
  final Color progressRingFill;

  /// Фон заголовка карточки задания.
  final Color taskCardHeaderBg;

  /// Фон тела карточки задания.
  final Color taskCardBodyBg;

  /// Фон чипа задания.
  final Color taskChipBg;

  /// Фон экрана заданий (TasksScreen).
  final Color tasksScreenBackground;

  /// Верхний цвет зелёного градиента кнопки "Забрать".
  final Color claimGreenTop;

  /// Нижний цвет зелёного градиента кнопки "Забрать".
  final Color claimGreenBottom;

  /// Верхний цвет фиолетового градиента кнопки "Забрать".
  final Color claimPurpleTop;

  /// Нижний цвет фиолетового градиента кнопки "Забрать".
  final Color claimPurpleBottom;

  /// Верхний цвет градиента кнопки "Забрать опыт" тизера заданий.
  final Color claimXpButtonTop;

  /// Нижний цвет градиента кнопки "Забрать опыт" тизера заданий.
  final Color claimXpButtonBottom;

  /// Цвет текста кнопки "Забрать опыт".
  final Color claimXpText;

  /// Рамка плитки, готовой к клейму.
  final Color claimReadyBorder;

  /// Цвет ромба превью юбилейного уровня на макс. уровне сезона.
  final Color milestoneDiamondMaxLevel;

  /// Акцентный цвет карточки превью юбилейного уровня.
  final Color milestonePreviewAccent;

  /// Цвет свечения карточки превью юбилейного уровня.
  final Color milestonePreviewGlow;

  /// Цвет непройденного узла трека наград (ромб/линия).
  final Color trackNodeDefault;

  /// Цвет пройденного узла трека наград.
  final Color trackNodeReached;

  /// Средний стоп градиента пунктирной линии тизера "следующий сезон".
  final Color dashGradientMid;

  /// Золотой цвет свечения/рамки.
  final Color glowGold;

  /// Тень золотого свечения.
  final Color glowShadow;

  /// Цвет текста таймера обратного отсчёта.
  final Color timerText;

  /// Цвет текста таймера в плашке BattlePassEndedNotice.
  final Color countdownPillText;

  /// Верхний цвет градиента заголовка события.
  final Color eventTitleTop;

  /// Нижний цвет градиента заголовка события.
  final Color eventTitleBottom;

  /// Цвет текста тега предмета.
  final Color itemTagText;

  /// Верхний цвет градиента тега предмета.
  final Color itemTagGradientTop;

  /// Нижний цвет градиента тега предмета.
  final Color itemTagGradientBottom;

  /// Начальный (прозрачный) стоп глянцевого блика кнопки.
  final Color buttonShineStart;

  /// Мягкий стоп глянцевого блика кнопки.
  final Color buttonShineSoft;

  /// Пиковый (самый яркий) стоп глянцевого блика кнопки.
  final Color buttonShineCore;

  /// Затухающий стоп глянцевого блика кнопки.
  final Color buttonShineFade;

  /// Конечный (прозрачный) стоп глянцевого блика кнопки.
  final Color buttonShineEnd;

  /// Оранжевый стоп рамки уровня повышения (border-image).
  final Color levelUpBorderOrange;

  /// Жёлтый стоп рамки уровня повышения.
  final Color levelUpBorderYellow;

  /// Светлый стоп рамки уровня повышения (только в levelUpBorderGradient).
  final Color levelUpBorderLight;

  /// Янтарный стоп рамки уровня повышения.
  final Color levelUpBorderAmber;

  /// Коралловый стоп рамки уровня повышения.
  final Color levelUpBorderCoral;

  /// Тёмный стоп серого градиента плитки трека (common).
  final Color rewardTileGrayDark;

  /// Средний стоп серого градиента плитки трека.
  final Color rewardTileGrayMid;

  /// Светлый стоп серого градиента плитки трека.
  final Color rewardTileGrayLight;

  /// Тёмный стоп синего градиента плитки трека (rare).
  final Color rewardTileBlueDark;

  /// Средний стоп синего градиента плитки трека.
  final Color rewardTileBlueMid;

  /// Светлый стоп синего градиента плитки трека.
  final Color rewardTileBlueLight;

  /// Тёмный стоп фиолетового градиента плитки трека (epic).
  final Color rewardTilePurpleDark;

  /// Средний стоп фиолетового градиента плитки трека.
  final Color rewardTilePurpleMid;

  /// Светлый стоп фиолетового градиента плитки трека.
  final Color rewardTilePurpleLight;

  /// Тёмный стоп золотого градиента плитки трека (legendary).
  final Color rewardTileGoldDark;

  /// Средний стоп золотого градиента плитки трека.
  final Color rewardTileGoldMid;

  /// Светлый стоп золотого градиента плитки трека.
  final Color rewardTileGoldLight;

  /// Фон плашки "Получи всё сразу!" премиум-тизера.
  final Color unlockStickerBg;

  /// Тень текста плашки "Получи всё сразу!" премиум-тизера.
  final Color unlockStickerTextShadow;

  /// Сплошная заливка карточки BattlePassEndedNotice.
  final Color endedNoticeFlatBg;

  /// Прозрачные стопы диагонального блика карточки BattlePassEndedNotice.
  final Color endedNoticeSheenTransparent;

  /// Видимый стоп диагонального блика карточки BattlePassEndedNotice.
  final Color endedNoticeSheenHighlight;

  /// Фон чипа количества награды на плитке карусели.
  final Color quantityChipBg;

  /// Белый цвет приложения.
  final Color appColorWhite;

  /// Чёрный цвет приложения.
  final Color appColorBlack;

  /// Прозрачный цвет приложения.
  final Color appColorTransparent;
}
