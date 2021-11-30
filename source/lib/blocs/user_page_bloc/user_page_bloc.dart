import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/models/user_model.dart';
import 'package:sudoku_game/repositories/user_repository.dart';

part 'user_page_event.dart';
part 'user_page_state.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final UserRepository userRepository;
  Logger _logger;

  UserPageBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(UserPageInitial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<UserPageState> mapEventToState(
    UserPageEvent event,
  ) async* {
    if (event is UserPageFetchData) {
      try {
        yield UserPageLoading();
        var userData = await userRepository.getCurrentUser();
        yield UserDataFetched(userData);
      } on Exception catch (ex) {
        _logger.w(ex.toString());
        yield UserPageError();
      }
    }
  }

  @override
  void onTransition(Transition<UserPageEvent, UserPageState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
