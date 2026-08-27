import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../cubit/tasks_cubit.dart';

/// Минимальная реализация по ТЗ: пустой экран с кнопкой "Назад".
/// Слои domain/data/cubit уже готовы принять реальный контент экрана "Задания".
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksCubit>(
      create: (_) => sl<TasksCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B131C),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
