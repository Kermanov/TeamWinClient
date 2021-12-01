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
  StreamSubscription<AuthUser> _userSubscription;
  Logger _logger;

  AuthBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(AuthUnknownState()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
    _userSubscription = _authRepository.user.listen((user) {
      if (user != null) {
        add(AuthAuthenticatedEvent(user.id));
      } else {
        add(AuthUnauthenticatedEvent());
      }
    });
  }

  @override
  Stream<Transition<AuthEvent, AuthState>> transformEvents(
    Stream<AuthEvent> events,
    TransitionFunction<AuthEvent, AuthState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! AuthAuthenticatedEvent);

    final debounceStream = events
        .where((event) => event is AuthAuthenticatedEvent)
        .debounceTime(Duration(milliseconds: 1000));

    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthAuthenticatedEvent) {
      yield* _mapAuthenticatedEventToState(event);
    } else if (event is AuthUnauthenticatedEvent) {
      yield* _mapUnauthenticatedEventToState();
    } else if (event is AuthSignOutRequested) {
      await _authRepository.signOut();
    }
  }

  Stream<AuthState> _mapAuthenticatedEventToState(
      AuthAuthenticatedEvent event) async* {
    yield AuthAuthenticatedState(event.userId);
  }

  Stream<AuthState> _mapUnauthenticatedEventToState() async* {
    yield AuthUnauthenticatedState();
  }

  @override
  Future<void> close() async {
    _logger.v("Instance closed.");
    await _userSubscription?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
