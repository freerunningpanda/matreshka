import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color screenBackground = Color(0xFF2D2E34);
  static const Color navOverlay = Color(0xB3151727); // rgba(21,23,39,0.7)

  static const Color textPrimary = Color(0xFFE9E9F3);
  static const Color textSecondary = Color(0xB2E9E9F3); // rgba(233,233,243,0.7)
  static const Color accentGold = Color(0xFFFFD149);

  static const Color buttonOverlayWeak = Color(0x0DE9E9F3); // 0.05
  static const Color buttonOverlayStrong = Color(0x1AE9E9F3); // 0.1

  static const Color progressRingTrack = Color(0x1AE9E9F3); // 0.1
  static const Color progressRingFill = Color(0x99E9E9F3); // 0.6
  static const Color textMuted = progressRingFill; // rgba(233,233,243,0.6)

  static const Color taskCardHeaderBg = Color(0x99353847); // #353847 @ 0.6
  static const Color taskCardBodyBg = Color(0x99212331); // #212331 @ 0.6
  static const Color taskChipBg = Color(0xFF232429);

  static const Color claimGreenTop = Color(0xFF56B877);
  static const Color claimGreenBottom = Color(0xFF449660);
  static const Color claimPurpleTop = Color(0xFF925CD8);
  static const Color claimPurpleBottom = Color(0xFF864AD4);

  static const Color glowGold = Color(0xFFFFB41C);
  static const Color glowShadow = Color(0x52FFB800); // rgba(255,184,0,0.32)

  static const Color timerText = Color(0x66E9E9F3); // rgba(233,233,243,0.4)
  static const Color eventTitleTop = Color(0xFFD63A26);
  static const Color eventTitleBottom = Color(0xFFEF6429);

  static const LinearGradient eventTitleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [eventTitleTop, eventTitleBottom],
  );

  static const Color itemTagText = Color(0xFF3C0B0B);
  static const Color itemTagGradientTop = Color(0xFFEFCB4C);
  static const Color itemTagGradientBottom = Color(0xFFF6743C);

  static const LinearGradient itemTagGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [itemTagGradientTop, itemTagGradientBottom],
  );

  /// Глянцевый блик поверх золотой кнопки (Rectangle 64755, blend "overlay").
  static const LinearGradient buttonShineGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    colors: [
      Color(0x00D9D9D9),
      Color(0x66C2C2C2),
      Color(0xFFA9A9A9),
      Color(0x668D8D8D),
      Color(0x00737373),
    ],
  );

  static const LinearGradient claimGreenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [claimGreenTop, claimGreenBottom],
  );

  static const LinearGradient claimPurpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [claimPurpleTop, claimPurpleBottom],
  );

  static const LinearGradient levelUpBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFA34E),
      Color(0xFFFFC847),
      Color(0xFFFFE383),
      Color(0xFFFFB51B),
      Color(0xFFFF7B5F),
    ],
    stops: [0.0, 0.37, 0.40, 0.73, 1.0],
  );
}
