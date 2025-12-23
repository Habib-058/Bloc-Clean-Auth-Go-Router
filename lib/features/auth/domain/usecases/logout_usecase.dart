
import 'package:dartz/dartz.dart';

import '../../../../core/errors/auth_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class LogoutUseCase implements UseCase<void,NoParams>{
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
