import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AuthUser> _userSubscription;
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
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
    await _analytics.setUserId(event.userId);
    yield AuthAuthenticatedState(event.userId);
  }

  Stream<AuthState> _mapUnauthenticatedEventToState() async* {
    await _analytics.setUserId(null);
    yield AuthUnauthenticatedState();
  }

  @override
  Future<void> close() async {
    _logger.v("Closed.");
    await _userSubscription?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
