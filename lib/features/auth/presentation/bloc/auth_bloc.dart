import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/auth_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await checkAuthUseCase(NoParams());

    await result.fold(
          (left) {
        emit(AuthUnauthenticated());
      },
          (right) async {
        if (right) {
          final userResult = await getCurrentUserUseCase(NoParams());
          await userResult.fold(
                (l) {
              emit(AuthUnauthenticated());
            },
                (r) {
              if (r != null) {
                emit(AuthAuthenticated(userEntity: r));
              } else {
                emit(AuthUnauthenticated());
              }
            },
          );
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future _onAuthLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold((l){
      String message = 'Auth error';
      if(l is InvalidCredentialsFailure){
        message = 'Wrong email or password';
      }
      else if(l is ServerFailure){
        message = 'Server failure';
      }
      emit(AuthError(message: message));
    }, (r){
      emit(AuthAuthenticated(userEntity: r));
    });
  }

  Future _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold((l){
      emit(AuthError(message: 'Logout error'));
    }, (r){
      emit(AuthUnauthenticated());
    });
  }
}