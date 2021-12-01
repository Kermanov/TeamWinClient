import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cure/signalr.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku_game/constants/api_constants.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:logger/logger.dart' as logger;

part 'game_search_event.dart';

part 'game_search_state.dart';

class GameSearchBloc extends Bloc<GameSearchEvent, GameSearchState> {
  HubConnection _hubConnection;
  logger.Logger _logger;

  GameSearchBloc() : super(GameSearchInitial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<GameSearchState> mapEventToState(GameSearchEvent event) async* {
    if (event is GameSearchStarted && state is GameSearchInitial) {
      yield* _mapGameSearchStartedToState(event);
    } else if (event is _GameSearchGameFound && state is GameSearchProcessing) {
      yield GameSearchComplete(event.gameId);
    } else if (event is GameSearchAbort && state is GameSearchProcessing) {
      yield* _mapGameSearchAbortToState();
    } else if (event is GameSearchReset && state is GameSearchComplete) {
      yield GameSearchInitial();
    }
  }

  Stream<GameSearchState> _mapGameSearchStartedToState(
      GameSearchStarted event) async* {
    try {
      yield GameSearchProcessing();
      _hubConnection = createHubConnection(ApiConstants.matchmakerHubUrl);
      await _hubConnection.startAsync();
      _hubConnection.on("GameFound", _onGameFound);
      if (event.gameType == GameType.duel) {
        await _hubConnection.sendAsync("FindDuelGame", [event.gameMode.index]);
      } else if (event.gameType == GameType.single) {
        await _hubConnection
            .sendAsync("CreateSinglePlayerGame", [event.gameMode.index]);
      }
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      await _hubConnection?.stopAsync();
      yield GameSearchError();
    }
  }

  Stream<GameSearchState> _mapGameSearchAbortToState() async* {
    try {
      yield GameSearchAborting();
      await _hubConnection.invokeAsync("RemoveFromQueue");
      await _hubConnection?.stopAsync();
      yield GameSearchInitial();
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield GameSearchError();
    }
  }

  Future<void> _onGameFound(List<dynamic> args) async {
    add(_GameSearchGameFound(args[0]));
  }

  @override
  Future<void> close() async {
    _logger.v("Instance closed.");
    if (state is GameSearchProcessing) {
      await _hubConnection.invokeAsync("RemoveFromQueue");
    }
    await _hubConnection?.stopAsync();
    return super.close();
  }

  @override
  void onTransition(Transition<GameSearchEvent, GameSearchState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
