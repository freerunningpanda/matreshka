import 'package:get_it/get_it.dart';

import '../exports.dart';
import '../theme/exports.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // Инициализация темы.
  _initTheme();

  // Инициализация Battle Pass.
  _initBattlePass();

  // Инициализация задач.
  _initTasks();
}

void _initTheme() {
  sl
    // Theme.
    ..registerLazySingleton<AppTheme>(
      () => AppTheme(appColors: sl(), appTypography: sl()),
    )
    ..registerLazySingleton<AppColors>(AppColors.new)
    ..registerLazySingleton<AppTypography>(AppTypography.new);
}

void _initBattlePass() {
  sl
    ..registerLazySingleton<BattlePassMockApi>(BattlePassMockApi.new)
    ..registerLazySingleton<BattlePassRepository>(
      () => BattlePassRepositoryImpl(mockApi: sl()),
    )
    ..registerLazySingleton(() => GetSeason(sl()))
    ..registerLazySingleton(() => ClaimReward(sl()))
    ..registerLazySingleton(() => ClaimAllRewards(sl()))
    ..registerFactory<BattlePassCubit>(
      () => BattlePassCubit(
        getSeason: sl(),
        claimReward: sl(),
        claimAllRewards: sl(),
      ),
    );
}

void _initTasks() {
  sl
    ..registerLazySingleton<TasksMockApi>(TasksMockApi.new)
    ..registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(mockApi: sl()),
    )
    ..registerLazySingleton(() => GetTasks(sl()))
    ..registerFactory<TasksCubit>(() => TasksCubit(getTasks: sl()));
}
