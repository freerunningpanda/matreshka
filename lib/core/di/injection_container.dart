import 'package:get_it/get_it.dart';

import '../../features/battle_pass/data/mock/battle_pass_mock_api.dart';
import '../../features/battle_pass/data/repositories/battle_pass_repository_impl.dart';
import '../../features/battle_pass/domain/repositories/battle_pass_repository.dart';
import '../../features/battle_pass/domain/usecases/claim_all_rewards.dart';
import '../../features/battle_pass/domain/usecases/claim_reward.dart';
import '../../features/battle_pass/domain/usecases/get_season.dart';
import '../../features/battle_pass/presentation/cubit/battle_pass_cubit.dart';
import '../../features/tasks/data/mock/tasks_mock_api.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  _initBattlePass();
  _initTasks();
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
