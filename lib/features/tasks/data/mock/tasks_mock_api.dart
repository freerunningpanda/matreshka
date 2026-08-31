/// Экран "Задания" в этом задании — минимальная заглушка (см. README): один
/// мок-таск для тизер-карточки на главном экране БП (узел "Tasks_Main_BP",
/// id 1:1266 в Figma), список на самом экране "Задания" не разбирался.
class TasksMockApi {
  Map<String, dynamic> fetchTasks(bool premiumOwned) => {
    'premium_owned': premiumOwned,
    'premium_xp_buff_active': false,
    'tasks': <Map<String, dynamic>>[
      premiumOwned ? _completedTask : _activeTask,
    ],
  };

  static const _activeTask = {
    'id': 1,
    'title': 'Используйте определенный предмет (Энергетик) 10 раз.',
    'progress_current': 3,
    'progress_target': 5,
    'reward_xp': 25,
    'completed': false,
    'claimed': false,
  };

  // Узел "Tasks_Main_BP" для сценария "премиум куплен / награда" (node-id
  // 1-1324 в Figma): тот же таск, но уже выполнен и ждёт клейма — отсюда
  // другой набор чисел (прогресс 5/5, xp x100).
  static const _completedTask = {
    'id': 1,
    'title': 'Используйте определенный предмет (Энергетик) 10 раз.',
    'progress_current': 5,
    'progress_target': 5,
    'reward_xp': 100,
    'completed': true,
    'claimed': false,
  };
}
