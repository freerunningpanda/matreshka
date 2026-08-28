/// Экран "Задания" в этом задании — минимальная заглушка (см. README): один
/// мок-таск для тизер-карточки на главном экране БП (узел "Tasks_Main_BP",
/// id 1:1266 в Figma), список на самом экране "Задания" не разбирался.
class TasksMockApi {
  Map<String, dynamic> fetchTasks() => const {
    'premium_owned': false,
    'premium_xp_buff_active': false,
    'tasks': <Map<String, dynamic>>[
      {
        'id': 1,
        'title': 'Используйте определенный предмет (Энергетик) 10 раз.',
        'progress_current': 3,
        'progress_target': 5,
        'reward_xp': 25,
        'completed': false,
        'claimed': false,
      },
    ],
  };
}
