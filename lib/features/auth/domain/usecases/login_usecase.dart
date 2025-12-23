
import 'package:dartz/dartz.dart';

import '../../../../core/errors/auth_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity,LoginParams>{
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(params) async {
    return await repository.login(email: params.email, password: params.password);
  }
}

class LoginParams{
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}