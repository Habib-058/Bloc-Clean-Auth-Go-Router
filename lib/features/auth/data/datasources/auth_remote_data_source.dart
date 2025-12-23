

import '../../../../core/exceptions/auth_exception.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource{
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));

    if(email == 'test@test.com' && password == '123456'){
      return UserModel(id: '1', email: 'test@test.com', name: 'Test User');
    }
    else{
      throw InvalidCredentialsException();
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 500));
  }

}