import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Таймер + заголовок ивента ("+" фрейм узла "Info bar", id 1:1312) —
/// рядом с кольцом уровня. Дедлайн — статичный мок (см. README): сам ивент
/// "Дай пять!" сторонний по отношению к боевому пропуску, вне схемы данных
/// этого задания, но обратный отсчёт тикает по-настоящему.
class EventTimerBanner extends StatelessWidget {
  const EventTimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 513,
      top: 56,
      width: 439,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CountdownTimer(),
          SizedBox(height: 8),
          _EventTitle(),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  const _CountdownTimer();

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late final DateTime _deadline;
  late Duration _remaining;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _deadline = DateTime.now().add(
      const Duration(days: 15, hours: 12, minutes: 42),
    );
    _remaining = _deadline.difference(DateTime.now());
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = _deadline.difference(DateTime.now());
      setState(() => _remaining = left.isNegative ? Duration.zero : left);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 32,
          color: AppColors.timerText,
        ),
        const SizedBox(width: 14),
        Text(
          '$daysд $hoursч $minutesм',
          style: const TextStyle(
            fontFamily: 'Geologica',
            fontWeight: FontWeight.w500,
            fontSize: 26,
            height: 1.2,
            letterSpacing: -0.26,
            color: AppColors.timerText,
          ),
        ),
      ],
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Дай пять!',
      style: TextStyle(
        fontFamily: 'Geologica',
        fontWeight: FontWeight.w600,
        fontSize: 48,
        height: 0.93,
        letterSpacing: -0.48,
        foreground: Paint()
          ..shader = AppColors.eventTitleGradient.createShader(
            const Rect.fromLTWH(0, 0, 1, 45),
          ),
      ),
    );
  }
}
