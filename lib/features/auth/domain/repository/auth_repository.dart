
import 'package:dartz/dartz.dart';

import '../../../../core/errors/auth_failures.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure,void>> logout();

  Future<Either<Failure,UserEntity?>> getCurrentUser();

  Future<Either<Failure,bool>> isAuthenticated();
}