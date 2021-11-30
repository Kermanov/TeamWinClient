part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus authStatus;

  const AuthState._({this.authStatus = AuthStatus.unknown});

  const AuthState.unknown() : this._();

  const AuthState.authenticated()
      : this._(authStatus: AuthStatus.authenticated);

  const AuthState.unauthenticated()
      : this._(authStatus: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [authStatus];
}
