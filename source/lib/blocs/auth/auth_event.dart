part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthAuthenticatedEvent extends AuthEvent {
  final String userId;

  const AuthAuthenticatedEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthUnauthenticatedEvent extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}
