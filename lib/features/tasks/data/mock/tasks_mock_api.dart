/// Экран "Задания" в этом задании — минимальная заглушка (см. README): пустой список.
/// Слой данных уже разведён под будущее расширение (несколько сценариев, как в макете).
class TasksMockApi {
  Map<String, dynamic> fetchTasks() => const {
    'premium_owned': false,
    'premium_xp_buff_active': false,
    'tasks': <Map<String, dynamic>>[],
  };
}
