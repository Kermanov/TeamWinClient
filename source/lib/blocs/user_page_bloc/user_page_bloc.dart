import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_game/models/user_model.dart';
import 'package:sudoku_game/repositories/user_repository.dart';

part 'user_page_event.dart';
part 'user_page_state.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final UserRepository userRepository;

  UserPageBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(UserPageInitial());

  @override
  Stream<UserPageState> mapEventToState(
    UserPageEvent event,
  ) async* {
    if (event is UserPageFetchData) {
      try {
        yield UserPageLoading();
        var userData = await userRepository.getCurrentUser();
        yield UserDataFetched(userData);
      } on Exception {
        yield UserPageError();
      }
    }
  }
}
