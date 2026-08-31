import 'package:equatable/equatable.dart';

import '../exports.dart';

abstract class UseCase<T, Params> {
  const UseCase();

  Future<Result<T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
