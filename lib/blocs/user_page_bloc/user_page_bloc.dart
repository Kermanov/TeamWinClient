import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/user_model.dart';
import 'package:sudoku_game/models/user_stats_item_model.dart';
import 'package:sudoku_game/repositories/user_repository.dart';

part 'user_page_event.dart';
part 'user_page_state.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final UserRepository userRepository;
  Logger _logger;

  UserPageBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(UserPageState.initial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<UserPageState> mapEventToState(
    UserPageEvent event,
  ) async* {
    if (event is UserPageFetchData) {
      yield* _mapFetchDataEventToState();
    }
  }

  Stream<UserPageState> _mapFetchDataEventToState() async* {
    yield state.copyWith(isLoading: true, isError: false);
    try {
      var futures = [
        userRepository.getCurrentUser(),
        userRepository.getCurrentUserStats()
      ];
      var results = await Future.wait(futures);
      yield state.copyWith(
        isLoading: false,
        isError: false,
        userModel: results[0],
        userStats: results[1],
      );
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield state.copyWith(
        isError: true,
        isLoading: false,
        userModel: UserModel.empty(),
        userStats: Map<GameMode, UserStatsItem>(),
      );
    }
  }

  @override
  void onTransition(Transition<UserPageEvent, UserPageState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
