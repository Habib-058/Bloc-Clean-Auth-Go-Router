
import 'package:equatable/equatable.dart';

import '../../domain/entity/user_entity.dart';

abstract class AuthState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthAuthenticated extends AuthState{
  final UserEntity userEntity;

  AuthAuthenticated({required this.userEntity});

  @override
  List<Object?> get props => [userEntity];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState{
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
