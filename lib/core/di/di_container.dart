
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';



class DependencyInjection {
  final serviceLocator = GetIt.instance;
  Future init() async {
    serviceLocator.registerFactory(
          () => AuthBloc(
        loginUseCase: serviceLocator(),
        logoutUseCase: serviceLocator(),
        getCurrentUserUseCase: serviceLocator(),
        checkAuthUseCase: serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton(() => LoginUseCase(repository: serviceLocator()));
    serviceLocator.registerLazySingleton(() => LogoutUseCase(repository: serviceLocator()));
    serviceLocator.registerLazySingleton(() => GetCurrentUserUseCase(repository: serviceLocator()));
    serviceLocator.registerLazySingleton(() => CheckAuthUseCase(repository: serviceLocator()));


    serviceLocator.registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImpl(
            authRemoteDataSource: serviceLocator(),
            authLocalDataSource: serviceLocator()

        )
    );

    serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
    serviceLocator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences: serviceLocator()));

    final sharedPreferences = await SharedPreferences.getInstance();
    serviceLocator.registerLazySingleton(() => sharedPreferences);
  }
}

