part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChanged extends AuthEvent {
  final AuthStatus status;

  const AuthStateChanged(this.status);

  @override
  List<Object> get props => [status];
}

class AuthSignOutRequested extends AuthEvent {}
