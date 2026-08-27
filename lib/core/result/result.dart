import 'package:equatable/equatable.dart';

sealed class Result<T> {
  const Result();

  factory Result.success({required T data}) = Success<T>;

  factory Result.failure(Failure failure) = ResultFailure<T>;

  void fold({
    required void Function(Success<T> success) onSuccess,
    required void Function(ResultFailure<T> failure) onFailure,
  }) {
    final self = this;
    switch (self) {
      case Success<T>():
        onSuccess(self);
      case ResultFailure<T>():
        onFailure(self);
    }
  }
}

final class Success<T> extends Result<T> {
  const Success({required this.data});

  final T data;
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;
}

class Failure extends Equatable {
  const Failure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
