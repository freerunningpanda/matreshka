import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Карточка-тизер "Задания" на главном экране БП (Tasks-компонент из макета).
/// Полноценный контент задания — вне скоупа задания (см. README), поэтому
/// карточка сведена к переходу на экран "Задания".
class TasksTeaserCard extends StatelessWidget {
  const TasksTeaserCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 346,
      top: 130,
      width: 400,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Задания',
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
