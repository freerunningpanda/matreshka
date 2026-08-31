import 'package:flutter/material.dart';

import '../../exports.dart';

/// [AppColors] отвечает за цветовую палитру приложения.
/// Для дневной темы.
class AppColors extends BaseColors<AppColors> {
  /// Конструктор
  AppColors() : super(mainColors: const _MainColors());

  @override
  ThemeExtension<AppColors> copyWith() => AppColors();

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return AppColors();
  }
}

class _MainColors extends MainColors {
  const _MainColors()
    : super(
        screenBackground: const Color(0xFF2D2E34),
        navOverlay: const Color(0xB3151727),
        textPrimary: const Color(0xFFE9E9F3),
        textSecondary: const Color(0xB2E9E9F3),
        accentGold: const Color(0xFFFFD149),
        buttonOverlayWeak: const Color(0x0DE9E9F3),
        buttonOverlayStrong: const Color(0x1AE9E9F3),
        progressRingTrack: const Color(0x1AE9E9F3),
        progressRingFill: const Color(0x99E9E9F3),
        taskCardHeaderBg: const Color(0x99353847),
        taskCardBodyBg: const Color(0x99212331),
        taskChipBg: const Color(0xFF232429),
        tasksScreenBackground: const Color(0xFF1B131C),
        claimGreenTop: const Color(0xFF56B877),
        claimGreenBottom: const Color(0xFF449660),
        claimPurpleTop: const Color(0xFF925CD8),
        claimPurpleBottom: const Color(0xFF864AD4),
        claimXpButtonTop: const Color(0x6655B675),
        claimXpButtonBottom: const Color(0x66449761),
        claimXpText: const Color(0xFF68C286),
        claimReadyBorder: const Color(0xFF3DDC6B),
        milestoneDiamondMaxLevel: const Color(0xFFD137DF),
        milestonePreviewAccent: const Color(0xFFDA7128),
        milestonePreviewGlow: const Color(0xFFE23600),
        trackNodeDefault: const Color(0xFF4A4A52),
        trackNodeReached: const Color(0xFFE5484D),
        dashGradientMid: const Color(0xFF5D5D6D),
        glowGold: const Color(0xFFFFB41C),
        glowShadow: const Color(0x52FFB800),
        timerText: const Color(0x66E9E9F3),
        countdownPillText: const Color(0xFF18191F),
        eventTitleTop: const Color(0xFFD63A26),
        eventTitleBottom: const Color(0xFFEF6429),
        itemTagText: const Color(0xFF3C0B0B),
        itemTagGradientTop: const Color(0xFFEFCB4C),
        itemTagGradientBottom: const Color(0xFFF6743C),
        buttonShineStart: const Color(0x00D9D9D9),
        buttonShineSoft: const Color(0x66C2C2C2),
        buttonShineCore: const Color(0xFFA9A9A9),
        buttonShineFade: const Color(0x668D8D8D),
        buttonShineEnd: const Color(0x00737373),
        levelUpBorderOrange: const Color(0xFFFFA34E),
        levelUpBorderYellow: const Color(0xFFFFC847),
        levelUpBorderLight: const Color(0xFFFFE383),
        levelUpBorderAmber: const Color(0xFFFFB51B),
        levelUpBorderCoral: const Color(0xFFFF7B5F),
        rewardTileGrayDark: const Color(0xFF1A1B20),
        rewardTileGrayMid: const Color(0xFF3B3E48),
        rewardTileGrayLight: const Color(0xFF5C5F68),
        rewardTileBlueDark: const Color(0xFF15213A),
        rewardTileBlueMid: const Color(0xFF3C7C97),
        rewardTileBlueLight: const Color(0xFF5C9EB3),
        rewardTilePurpleDark: const Color(0xFF2C1440),
        rewardTilePurpleMid: const Color(0xFF5A1A6A),
        rewardTilePurpleLight: const Color(0xFFC63F9E),
        rewardTileGoldDark: const Color(0xFF2A1608),
        rewardTileGoldMid: const Color(0xFF5C2E0A),
        rewardTileGoldLight: const Color(0xFFE87A1E),
        unlockStickerBg: const Color(0x4CE29432),
        unlockStickerTextShadow: const Color(0xFFFF5C00),
        endedNoticeFlatBg: const Color(0x9975531B),
        endedNoticeSheenTransparent: const Color(0x00C8A66F),
        endedNoticeSheenHighlight: const Color(0x4DC8A66F),
        quantityChipBg: const Color(0x8C000000),
        appColorWhite: Colors.white,
        appColorBlack: Colors.black,
        appColorTransparent: Colors.transparent,
      );
}
