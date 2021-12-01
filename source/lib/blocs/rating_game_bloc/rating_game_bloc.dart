import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cure/signalr.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_game/blocs/board_cubit/board_cubit.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/constants/api_constants.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/board_model.dart';
import 'package:sudoku_game/models/game_result_model.dart';
import 'package:sudoku_game/models/player_info_model.dart';
import 'package:logger/logger.dart' as logger;

part 'rating_game_event.dart';

part 'rating_game_state.dart';

class RatingGameBloc extends Bloc<RatingGameEvent, RatingGameState> {
  final String gameId;
  final TimerCubit timerCubit;
  Map<int, BoardModel> _boards = {};
  List<PlayerInfo> _playersInfo = [];
  HubConnection _hubConnection;
  logger.Logger _logger;

  RatingGameBloc({@required this.gameId, @required this.timerCubit})
      : assert(gameId != null),
        super(GameInitial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<RatingGameState> mapEventToState(RatingGameEvent event) async* {
    if (event is GameReadyToStart) {
      yield* _mapGameReadyToStartToState();
    } else if (event is _GameStarted) {
      yield* _mapGameStartedToState(event);
    } else if (event is _OpponentCompletionPercentRetrieved) {
      yield GameOpponentCompletionPercentRetrieved(event.completionPercent);
    } else if (event is _GameResultRetrieved) {
      yield* _mapGameResultRetrievedToState(event);
    } else if (event is GameSendProgress) {
      yield* _mapGameSendProgressToState(event);
    } else if (event is _GameTimeExpired) {
      yield* _mapGameTimeExpiredToState(event);
    } else if (event is _PlayersInfoRetrieved) {
      yield* _mapPlayersInfoRetrievedToState(event);
    } else if (event is _GameAborted) {
      yield* _mapGameAbortedToState();
    }
  }

  Stream<RatingGameState> _mapGameReadyToStartToState() async* {
    yield GameWaiting();
    try {
      _hubConnection = createHubConnection(ApiConstants.gameHubUrl);
      await _hubConnection.startAsync();
      _hubConnection.on("GameStarted", _onGameStarted);
      _hubConnection.on(
          "OpponentCompletionPercent", _onOpponentCompletionPercentChanged);
      _hubConnection.on("GameResult", _onGameFinished);
      _hubConnection.on("GameTimeExpired", _onGameTimeExpired);
      _hubConnection.on("PlayersInfo", _onPlayersInfo);
      _hubConnection.on("GameAborted", _onGameAborted);
      await _hubConnection.sendAsync("GameInit", [gameId]);
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      _hubConnection?.stopAsync();
      yield GameError();
    }
  }

  Stream<RatingGameState> _mapGameStartedToState(_GameStarted event) async* {
    for (var board in event.boards) {
      _boards[board.id] = board;
    }
    yield GamePuzzlesRetrieved(List<BoardData>.from(event.boards.map(
        (board) => BoardData(id: board.id, initialValues: board.boardList))));
    yield GamePlayersInfoRetrieved(_playersInfo);
  }

  Stream<RatingGameState> _mapGameResultRetrievedToState(
      _GameResultRetrieved event) async* {
    await _hubConnection.stopAsync();
    timerCubit.stop();
    yield GameFinished(
        event.gameResult.copyWith(oldRating: _playersInfo[0].rating));
  }

  Stream<RatingGameState> _mapGameSendProgressToState(
      GameSendProgress event) async* {
    _boards[event.changedBoard.id] = BoardModel(
        id: event.changedBoard.id, boardList: event.changedBoard.allValues);
    await _hubConnection.sendAsync("UpdateProgress",
        [gameId, _boards.values.map((board) => board.toJson()).toList()]);
  }

  Stream<RatingGameState> _mapPlayersInfoRetrievedToState(
      _PlayersInfoRetrieved event) async* {
    _playersInfo = event.playersInfo;
  }

  Stream<RatingGameState> _mapGameTimeExpiredToState(
      _GameTimeExpired event) async* {
    timerCubit.stop();
    yield GameFinished(GameResult(
        isVictory: false,
        newRating: event.newRating,
        oldRating: _playersInfo[0].rating,
        message: "Game time expired."));
  }

  Stream<RatingGameState> _mapGameAbortedToState() async* {
    yield GameAborted();
  }

  void _onGameStarted(List<dynamic> args) {
    timerCubit.start();
    var boards = List<BoardModel>.from(
        args[0].map((board) => BoardModel.fromJson(board)));
    add(_GameStarted(boards));
  }

  void _onOpponentCompletionPercentChanged(List<dynamic> args) {
    add(_OpponentCompletionPercentRetrieved(args[0]));
  }

  void _onGameFinished(List<dynamic> args) {
    add(_GameResultRetrieved(GameResult.fromJson(args[0])));
  }

  void _onGameTimeExpired(List<dynamic> args) {
    add(_GameTimeExpired(args[0]));
  }

  void _onPlayersInfo(List<dynamic> args) {
    var playersInfo = List<PlayerInfo>.from(
        args[0].map((playerInfo) => PlayerInfo.fromJson(playerInfo)));
    add(_PlayersInfoRetrieved(playersInfo));
  }

  void _onGameAborted(List<dynamic> args) {
    add(_GameAborted());
  }

  @override
  Future<void> close() async {
    _logger.v("Closed.");
    await _hubConnection?.stopAsync();
    return super.close();
  }

  @override
  void onTransition(Transition<RatingGameEvent, RatingGameState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
