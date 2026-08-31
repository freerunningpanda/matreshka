// Единая точка импорта для файлов lib/core/**: вместо набора относительных
// путей в каждом файле — один `import '.../exports.dart';` (тот же приём,
// что и у lib/features/exports.dart).

// Core
export 'result/result.dart';

// Battle Pass — data/domain/presentation (нужны injection_container.dart)
export '../features/battle_pass/data/mock/battle_pass_mock_api.dart';
export '../features/battle_pass/data/repositories/battle_pass_repository_impl.dart';
export '../features/battle_pass/domain/repositories/battle_pass_repository.dart';
export '../features/battle_pass/domain/usecases/claim_all_rewards.dart';
export '../features/battle_pass/domain/usecases/claim_reward.dart';
export '../features/battle_pass/domain/usecases/get_season.dart';
export '../features/battle_pass/presentation/cubit/battle_pass_cubit.dart';

// Tasks — data/domain/presentation (нужны injection_container.dart/app_router.dart)
export '../features/tasks/data/mock/tasks_mock_api.dart';
export '../features/tasks/data/repositories/tasks_repository_impl.dart';
export '../features/tasks/domain/repositories/tasks_repository.dart';
export '../features/tasks/domain/usecases/get_tasks.dart';
export '../features/tasks/presentation/cubit/tasks_cubit.dart';
export '../features/tasks/presentation/screens/tasks_screen.dart';
