# Юные помощники

## Overview

Flutter-приложение **Юные помощники** (`com.orlan.yassistantsMobile`) — мобильный клиент для платформы YAssistants.
Включает чаты, видеозвонки, задачи, новости, сторис, онбординг, систему SOS, геолокацию и push-уведомления.

- **Dart SDK:** ^3.6.0
- **Min Android:** API 26 (Android 8.0)
- **Min iOS:** 13.0+
- **Локаль по умолчанию:** Russian (ru_RU)
- **Базовый размер дизайна:** 374x812px (portrait only)

---

## Quick Start

```bash
# Установка зависимостей
make get                  # flutter clean && flutter pub get
make force-get            # удаляет pubspec.lock + flutter clean + pub get

# Кодогенерация (auto_route, flutter_gen, intl)
make gen                  # dart run build_runner build --delete-conflicting-outputs
make watch                # dart run build_runner watch --delete-conflicting-outputs
make clean-gen            # dart run build_runner clean

# iOS
make pod-install          # cd ios && pod install --repo-update && pod update
make build-ios            # flutter build ios --config-only --release

# Сборки
make build-android-dev    # flutter build apk (dev)
make build-android-prod   # flutter build appbundle (prod)
make build-ios-prod       # flutter build ios --release (prod)

# Линтинг
make dart-fix             # dart fix --apply
```

---

## Предварительные требования

### Yandex Maps API Key

Перед запуском проекта необходимо прописать `YANDEX_MAPS_KEY` в конфигурационных файлах платформ:

**Android** — `android/local.properties`:
```
YANDEX_MAPS_KEY=ваш_api_ключ
```

**iOS** — `ios/Flutter/Secrets.xcconfig`:
```
YANDEX_MAPS_KEY=ваш_api_ключ
```

> Оба файла исключены из git. Ключ можно получить в [Кабинете разработчика Яндекса](https://developer.tech.yandex.ru/).

---

## Запуск проекта (DEV / PROD)

Проект требует явного указания окружения при запуске. Конфигурация передаётся через `--dart-define`.

**DEV:**
```
--dart-define-from-file=environment/dev.json
```

**PROD:**
```
--dart-define-from-file=environment/prod.json
```

### CLI (flutter run)

```bash
# DEV
flutter run --dart-define-from-file=environment/dev.json

# PROD
flutter run --dart-define-from-file=environment/prod.json
```

---

## Сборка релизных и дебажных версий (Makefile)

### Android

| Команда | Тип | Окружение | Артефакт |
|---|---|---|---|
| `make build-android-dev` | Debug APK | `dev` | `build/app/outputs/flutter-apk/` |
| `make build-android-prod` | Release AAB | `prod` | `build/app/outputs/bundle/release/` |

```bash
# Debug APK — для ручного тестирования (dev-окружение)
make build-android-dev

# Release AAB — для публикации в Google Play (prod-окружение)
make build-android-prod
```

> **Release AAB** требует настроенного `android/key.properties` с подписью.

### iOS

| Команда | Тип | Окружение | Описание |
|---|---|---|---|
| `make build-ios` | Config-only | — | Только конфигурирует проект (без архива) |
| `make build-ios-dev` | Release | `dev` | Полная сборка для архивирования в Xcode. Для тестирования. |
| `make build-ios-prod` | Release | `prod` | Полная сборка для архивирования в Xcode. Для релиза. |

```bash
# Конфигурация iOS-проекта (без сборки архива)
make build-ios

# Release-сборка для prod — используй перед архивированием через Xcode
make build-ios-prod
```

> После `make build-ios-prod` открой Xcode → **Product → Archive** для публикации в App Store.

---

## Архитектура

### Clean Architecture + Feature-Based Organization

Проект реализует трёхслойную **Clean Architecture** с разделением на фичи:

```
lib/
├── main.dart                 # Точка входа, инициализация
├── app.dart                  # Корневой виджет (MaterialApp.router)
├── core/                     # Общий слой (shared across features)
│   ├── core.dart             # Единый экспорт-файл (~730 строк)
│   ├── dependencies/         # DI-контейнер (GetIt)
│   ├── features/             # Core-фичи (auth, user, tasks, sos, ...)
│   └── utils/                # Утилиты, хелперы, сеть, ошибки
├── features/                 # Независимые фичи (calls, chats, news, ...)
├── l10n/                     # ARB-файлы локализации
├── generated/                # Сгенерированный код (intl, routing)
└── packages/                 # Локальные пакеты (flutter_screen_lock)
```

### Три слоя каждой фичи

```
feature/
├── domain/
│   ├── entities/         # Бизнес-модели (extends Equatable)
│   ├── repositories/     # Абстрактные интерфейсы репозиториев
│   └── usecases/         # Бизнес-логика (extends UseCase<Type, Params>)
├── data/
│   ├── models/           # DTO (extends Entity, fromJson/toJson)
│   ├── repositories/     # Реализация репозиториев (extends BaseRepository)
│   └── datasources/      # Remote (API) и Local (cache) источники
└── presentation/
    ├── bloc/             # BLoC/Cubit (state management)
    ├── screens/          # Экраны
    └── widgets/          # UI-компоненты
```

---

## Фичи проекта

### Core-фичи (`lib/core/features/`)
Общие для всего приложения:

| Фича | Описание |
|-------|----------|
| **app** | Роутер, навигация, глобальные стейты (AppDataBloc) |
| **auth** | Аутентификация (логин, регистрация, верификация телефона) |
| **user** | Профиль, настройки, навыки |
| **social** | Менторы, друзья, доверенные лица |
| **main** | Главный экран, карты, геолокация |
| **tasks** | Управление задачами (adult + child) |
| **notifications** | Локальные уведомления |
| **remote_notifications** | Push-уведомления (FCM) |
| **websocket** | Real-time через Centrifugo |
| **theme** | Тема, цвета, типографика |
| **deep_links** | Deep linking |
| **sos** | Экстренный SOS |

### Feature-фичи (`lib/features/`)
Самостоятельные модули:

| Фича | Описание |
|-------|----------|
| **calls** | Видео/аудио звонки (LiveKit + WebRTC) |
| **chats** | Мессенджер |
| **news** | Лента новостей |
| **onboarding** | Онбординг |
| **reviews** | Отзывы/оценки |
| **stories** | Сторис |

---

## Ключевые паттерны и подходы

### State Management — BLoC

Весь стейт управляется через `flutter_bloc`. Паттерн:

```dart
// bloc.dart
class SosBloc extends Bloc<SosEvent, SosState> {
  SosBloc({required CreateAlarm createAlarm, ...})
      : _createAlarm = createAlarm,
        super(const AlarmInitial()) {
    on<CreateAlarmEvent>(_onCreateAlarm);
    on<GetAlarmEvent>(_onGetAlarm);
    add(const GetAlarmEvent()); // начальное событие
  }

  typedef _Emit = Emitter<SosState>;

  Future<void> _onCreateAlarm(CreateAlarmEvent event, _Emit emit) async {
    emit(const AlarmLoading());
    final result = await _createAlarm(CreateAlarmParams(...));
    result.fold(
      onSuccess: (s) => emit(AlarmCreated(alarmId: s.data)),
      onFailure: (f) => emit(AlarmError(message: f.failure.error)),
    );
  }
}

// event.dart
abstract class SosEvent {
  const SosEvent();
}
final class CreateAlarmEvent extends SosEvent { ... }

// state.dart
abstract class SosState extends Equatable {
  const SosState();
  @override
  List<Object?> get props => [];
}
class AlarmLoading extends SosState { const AlarmLoading(); }
class AlarmCreated extends SosState { ... }
```

**Конвенции BLoC:**
- `typedef _Emit = Emitter<State>` для краткости
- Начальное событие добавляется в конструкторе через `add()`
- Все стейты — `abstract class ... extends Equatable`
- Все события и стейты — `final class` или `abstract class`
- `result.fold(onSuccess:, onFailure:)` для обработки результатов

### Dependency Injection — GetIt

Единый DI-контейнер в `lib/core/dependencies/injection_container.dart`:

```dart
final sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  _initAuth();
  _initUser();
  _initTasks();
  // ... 13+ секций инициализации
}

void _initAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(requestHandler: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(localDatasource: sl(), remoteDatasource: sl()),
    )
    ..registerFactory<AuthBloc>(
      () => AuthBloc(signIn: sl(), logout: sl(), checkAuth: sl()),
    );
}
```

**Конвенции DI:**
- `registerLazySingleton` — для datasources, repositories, services
- `registerFactory` — для BLoC/Cubit (новый инстанс каждый раз)
- `registerLazySingletonAsync` — для async-сервисов (SharedPreferences)
- Цепочка `..` для группировки регистраций одной фичи

### Навигация — auto_route

```dart
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    authRouters.routers,
    navigationRouters.routers,
  ];
}
```

Роутеры разбиты по модулям: `AuthRouters`, `NavigationRouters`, `TasksRouters`, `ChatsRouters` и т.д.
Сгенерированный файл: `app_router.gr.dart` (~60+ маршрутов).

### Сетевой слой — Dio

Три инстанса Dio с разными конфигурациями:
1. **Main Dio** — основные запросы
2. **Refresh Token Dio** — обновление токена
3. **Retry Dio** — повторные запросы

**Цепочка интерсепторов:**
1. `RetryInterceptor` — автоповтор с backoff
2. `AppInterceptor` — проверка соединения
3. `RefreshTokenInterceptor` — обновление токена при 401
4. `TokenInterceptor` — инъекция auth-заголовков
5. `TalkerDioLogger` — логирование запросов

**Обработка запросов:**
```dart
class RequestHandler {
  Future<T> sendRequest<T>(Future<Response<dynamic>> request, {Converter?}) async {
    // Выполняет запрос, парсит response, маппит ошибки в BaseException
  }
}
```

### Result Type

Собственный sealed-class для результатов:

```dart
sealed class Result<T> {
  FutureOr<void> fold({
    required FutureOr<void> Function(Success<T>) onSuccess,
    required FutureOr<void> Function(FailureResult<T>) onFailure,
  });
}
```

### Entity → Model паттерн

```dart
// Domain: Entity (чистая модель)
class Alarm extends Equatable {
  const Alarm({required this.id, required this.status, ...});
  final String id;
  final AlarmStatus status;
  @override
  List<Object?> get props => [id, status, ...];
}

// Data: Model (DTO, наследует Entity)
final class AlarmModel extends Alarm {
  const AlarmModel({required super.id, required super.status, ...});

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
    id: json['id'] as String,
    status: AlarmStatus.fromName(json['status'] as String),
  );
}
```

**Конвенции моделей:**
- Entity — `extends Equatable`, `const` конструктор
- Model — `final class`, `extends Entity`, `factory fromJson()`
- Нет freezed/built_value — ручная сериализация
- `factory Entity.empty()` для начальных значений

### BaseRepository

```dart
abstract class BaseRepository {
  Future<Result<T>> execute<T>(Future<T> Function() action, Failure failure) async {
    try {
      return Result.success(data: await action());
    } on BaseException catch (e, st) {
      return Result.failure(_logError(failure, e, st));
    }
  }
}
```

### UseCase

```dart
abstract class UseCase<UseCaseType, Params> {
  Future<Result<UseCaseType>> call(Params params);
}

abstract class StreamUseCase<UseCaseType, Params> {
  Stream<UseCaseType> call(Params params);
}

// Для use case без параметров
final class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
```

---

## Импорты

Единый экспорт-файл `core.dart` покрывает всё:

```dart
import 'package:yassistants_mobile/core/core.dart';
```

Содержит ~730 строк экспортов — все пакеты, фичи, утилиты.
**Всегда используй этот импорт** вместо прямых импортов отдельных файлов.

---

## Тема и UI

### Theme

```dart
// Доступ к цветам
Theme.of(context).appColors.backgroundColors.backgroundPrimary
// Доступ к типографике
Theme.of(context).appTypography

// Определение через ThemeData extensions
extension AppThemeExtension on ThemeData {
  BaseColors get appColors => extension<AppColors>()!;
}
```

### Responsive Design

`flutter_screenutil` с базой 374x812:

```dart
16.w    // адаптивная ширина
16.h    // адаптивная высота
16.sp   // адаптивный шрифт
16.r    // адаптивный радиус
```

### Кастомные виджеты

`AppButton*` (brand, secondary, tertiary), `AppTextField`, `AppSnackbar`, `AppBottomSheet*`, `AppProgressIndicator`.

---

## Кодогенерация

| Генератор | Что генерирует | Файлы |
|-----------|---------------|-------|
| `auto_route_generator` | Маршруты | `*.gr.dart` |
| `flutter_gen` | Ассеты, шрифты | `lib/core/utils/gen/` |
| `intl` (Flutter Intl) | Локализация | `lib/generated/` |

**Запуск:** `make gen` или `dart run build_runner build --delete-conflicting-outputs`

Сгенерированные файлы исключены из git (`.gitignore`) и анализатора (`analysis_options.yaml`).

---

## Локализация

ARB-файл: `lib/l10n/intl_en.arb`
Генерация: через Flutter Intl IDE plugin

```dart
S.of(context).cancel    // "Отменить"
S.of(context).save      // "Сохранить"
```

---

## Логирование

Используется `talker_flutter`:
- `TalkerBlocObserver` — логирование BLoC-событий/стейтов
- `TalkerDioLogger` — логирование HTTP-запросов
- `TalkerRouteObserver` — логирование навигации

---

## Real-time

- **WebSocket:** Centrifugo через `centrifuge: ^0.17.0`
- Отдельные WebSocket BLoC для каждой фичи: `TasksWebsocketBloc`, `ReviewsWebsocketBloc`, `CallsWebsocketBloc`, `SOSWebsocketBloc`
- **Звонки:** LiveKit + WebRTC + CallKit

---

## Последовательность запуска (main.dart)

1. `runZonedGuarded()` — перехват ошибок → Firebase Crashlytics
2. `WidgetsFlutterBinding.ensureInitialized()`
3. Firebase background message handler
4. `FirebaseHelper.initFirebase()`
5. `MyHttpOverrides()` — кастомные HTTP overrides
6. `initDependencyInjection()` — регистрация всех сервисов
7. `sl.allReady()` — ожидание async-зависимостей
8. `DeepLinkNavigationService.initialize()`
9. Portrait-only ориентация
10. Прозрачные system bars
11. `TalkerBlocObserver` регистрация
12. `runApp(App(router: sl(), talker: sl()))`

---

## Линтинг

Базовый конфиг: `very_good_analysis` (строгие правила).
Игнорируются: `one_member_abstracts`, `avoid_dynamic_calls`, `no_runtimetype_tostring`.

---

## Как добавить новую фичу

1. **Создай структуру:**
   ```
   lib/features/my_feature/
   ├── domain/
   │   ├── entities/my_entity.dart
   │   ├── repositories/my_repository.dart
   │   └── usecases/get_my_data.dart
   ├── data/
   │   ├── models/my_entity_model.dart
   │   ├── repositories/my_repository_impl.dart
   │   └── datasources/my_remote_datasource.dart
   └── presentation/
       ├── bloc/my_bloc/
       │   ├── my_bloc.dart
       │   ├── my_event.dart
       │   └── my_state.dart
       ├── screens/my_screen.dart
       └── widgets/
   ```

2. **Domain:** Entity (`extends Equatable`), Repository (abstract), UseCase (`extends UseCase<T, Params>`)

3. **Data:** Model (`extends Entity`, `fromJson`), Repository impl (`extends BaseRepository`), Datasource

4. **Presentation:** BLoC с событиями/стейтами, экраны, виджеты

5. **DI:** Зарегистрируй зависимости в `injection_container.dart` — новая секция `_initMyFeature()`

6. **Routing:** Добавь маршруты в соответствующий `*Routers` класс, запусти `make gen`

7. **Exports:** Добавь экспорты в `core.dart`

---

## Важно при работе с проектом

- **Не редактируй `*.gr.dart`, `*.g.dart`, файлы в `generated/`** — они перегенерируются
- **Один импорт:** используй `import 'package:yassistants_mobile/core/core.dart';`
- **BLoC, не Cubit:** для сложных фичей используй полноценный BLoC (event-driven)
- **Все модели вручную:** нет freezed — `fromJson`/`toJson` пишутся руками
- **`final class`** для моделей и событий, `abstract class` для стейтов и интерфейсов
- **`const` конструкторы** везде где возможно
- **Result.fold()** для обработки результатов в BLoC-хендлерах
- **BaseRepository.execute()** для оборачивания вызовов в data-слое
- **Тесты:** пока не написаны, но архитектура готова к unit-тестированию
