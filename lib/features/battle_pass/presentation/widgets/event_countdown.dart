import 'dart:async';

import 'package:flutter/widgets.dart';

/// Дедлайн ивента "Дай пять!" — мок (см. README), общий для EventTimerBanner
/// и BattlePassEndedNotice: вычисляется один раз за сессию (lazy top-level
/// final), а не заново в каждом виджете — иначе их таймеры расходились бы
/// на доли секунды между собой при каждом отдельном mount.
final DateTime eventCountdownDeadline = DateTime.now().add(
  const Duration(days: 15, hours: 12, minutes: 42),
);

/// Тикающий остаток времени до [eventCountdownDeadline] в формате
/// "XXд YYч ZZм" — обновляется раз в секунду.
class EventCountdownText extends StatefulWidget {
  const EventCountdownText({required this.style, super.key});

  final TextStyle style;

  @override
  State<EventCountdownText> createState() => _EventCountdownTextState();
}

class _EventCountdownTextState extends State<EventCountdownText> {
  late Duration _remaining;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _remaining = eventCountdownDeadline.difference(DateTime.now());
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = eventCountdownDeadline.difference(DateTime.now());
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
    return Text('$daysд $hoursч $minutesм', style: widget.style);
  }
}
