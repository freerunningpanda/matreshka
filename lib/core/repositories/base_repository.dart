import '../result/result.dart';

abstract class BaseRepository {
  Future<Result<T>> execute<T>(
    Future<T> Function() action,
    Failure failure,
  ) async {
    try {
      return Result.success(data: await action());
    } catch (e) {
      return Result.failure(Failure('${failure.error}: $e'));
    }
  }
}
