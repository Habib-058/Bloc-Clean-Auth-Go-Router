
import 'package:dartz/dartz.dart';

import '../../../../core/errors/auth_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class CheckAuthUseCase implements UseCase<bool,NoParams>{
  final AuthRepository repository;

  CheckAuthUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticated();
  }
}