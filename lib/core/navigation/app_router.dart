import 'package:flutter/material.dart';

import '../exports.dart';

abstract final class AppRouter {
  static Future<void> toTasks(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const TasksScreen()));

  static void back(BuildContext context) => Navigator.of(context).pop();
}
