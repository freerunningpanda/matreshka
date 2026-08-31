import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exports.dart';

/// Минимальная реализация по ТЗ: пустой экран с кнопкой "Назад".
/// Слои domain/data/cubit уже готовы принять реальный контент экрана "Задания".
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors.mainColors;

    return BlocProvider<TasksCubit>(
      create: (_) => sl<TasksCubit>(),
      child: Scaffold(
        backgroundColor: colors.tasksScreenBackground,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: AppPadding.allPadding24,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back, color: colors.appColorWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
