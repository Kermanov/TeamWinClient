import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AuthStatus> _statusSubscription;
  Logger _logger;

  AuthBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(AuthState.unknown()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
    _statusSubscription = _authRepository.status
        .listen((status) => add(AuthStateChanged(status)));
  }

  @override
  Stream<Transition<AuthEvent, AuthState>> transformEvents(
    Stream<AuthEvent> events,
    TransitionFunction<AuthEvent, AuthState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! AuthStateChanged);

    final debounceStream = events
        .where((event) => event is AuthStateChanged)
        .debounceTime(Duration(milliseconds: 1000));

    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStateChanged) {
      yield _mapAuthStateChangedToState(event);
    } else if (event is AuthSignOutRequested) {
      await _authRepository.signOut();
    }
  }

  AuthState _mapAuthStateChangedToState(AuthStateChanged event) {
    return event.status == AuthStatus.authenticated
        ? AuthState.authenticated()
        : AuthState.unauthenticated();
  }

  @override
  Future<void> close() async {
    _logger.v("Instance closed.");
    await _statusSubscription?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
