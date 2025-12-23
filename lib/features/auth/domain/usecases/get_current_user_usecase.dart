import 'package:dartz/dartz.dart';

import '../../../../core/errors/auth_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity?,NoParams>{
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}