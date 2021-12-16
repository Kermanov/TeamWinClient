part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthAuthenticatedState extends AuthState {
  final String userId;

  const AuthAuthenticatedState(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthUnauthenticatedState extends AuthState {}

class AuthUnknownState extends AuthState {}
