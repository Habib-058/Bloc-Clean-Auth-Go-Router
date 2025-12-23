
import 'package:dartz/dartz.dart';

import '../errors/auth_failures.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure,Type>> call(Params params);
}

class NoParams {}