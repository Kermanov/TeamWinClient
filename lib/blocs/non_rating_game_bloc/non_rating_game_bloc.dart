import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sudoku_game/blocs/board_cubit/board_cubit.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/solved_board_model.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';
import 'package:logger/logger.dart' as logger;

part 'non_rating_game_event.dart';
part 'non_rating_game_state.dart';

class SingleNonRatingGameResult extends Equatable {
  final int time;
  final GameMode gameMode;

  const SingleNonRatingGameResult(this.time, this.gameMode);

  @override
  List<Object> get props => [time, gameMode];
}

class NonRatingGameBloc extends Bloc<NonRatingGameEvent, NonRatingGameState> {
  final SingleNonRatingGameRepository gameRepository;
  Map<int, SolvedBoardModel> _boards = {};
  Map<int, List<int>> _mutableValues = {};
  Map<int, List<List<int>>> _hints = {};
  Map<int, List<int>> _allValues = {};
  GameMode gameMode;
  TimerCubit timerCubit;
  StreamSubscription timerSubscription;
  logger.Logger _logger;

  NonRatingGameBloc(
      {@required this.gameMode,
      @required this.gameRepository,
      @required this.timerCubit})
      : assert(gameMode != null),
        assert(gameRepository != null),
        assert(timerCubit != null),
        super(NonRatingGameInitial()) {
    timerSubscription = timerCubit.stream.listen((state) {
      if (state is TimerTimeChanged) {
        add(_NonRatingGameTimeChanged(state.milliseconds));
      }
    });
    if (gameMode == GameMode.none) {
      add(NonRatingGameLoadPuzzle());
    } else {
      add(NonRatingGameGetPuzzle(gameMode));
    }
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<NonRatingGameState> mapEventToState(
    NonRatingGameEvent event,
  ) async* {
    if (event is NonRatingGameGetPuzzle) {
      yield* _mapGameGetPuzzleToState(event);
    } else if (event is NonRatingGameLoadPuzzle) {
      yield* _mapGameLoadPuzzleToState();
    } else if (event is _NonRatingGameTimeChanged) {
      yield* _mapGameTimeChangedToState(event);
    } else if (event is NonRatingGameBoardChanged) {
      yield* _mapGameBoardChangedToState(event);
    }
  }

  Stream<NonRatingGameState> _mapGameGetPuzzleToState(
      NonRatingGameGetPuzzle event) async* {
    yield NonRatingGameLoading();
    try {
      var boards = await gameRepository.getNewPuzzle(event.gameMode);
      for (var board in boards) {
        _boards[board.id] = board;
        _mutableValues[board.id] = List<int>.filled(81, 0);
        _hints[board.id] = List.generate(81, (_) => <int>[]);
        _allValues[board.id] = board.boardList;
      }
      await gameRepository.clearSavedData();
      var futures = [
        gameRepository.saveGameMode(gameMode),
        gameRepository.saveInitialPuzzle(_boards.values.toList()),
        gameRepository.saveUserSolution(_mutableValues),
        gameRepository.saveUserHints(_hints),
        gameRepository.saveTime(0)
      ];
      await Future.wait(futures);
      yield NonRatingGamePuzzleRetrieved(
          _boards.values
              .map((board) =>
                  BoardData(id: board.id, initialValues: board.boardList))
              .toList(),
          event.gameMode);
      timerCubit.start();
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      await gameRepository.clearSavedData();
      yield NonRatingGameError();
    }
  }

  Stream<NonRatingGameState> _mapGameLoadPuzzleToState() async* {
    try {
      gameMode = gameRepository.loadGameMode();
      var boards = gameRepository.loadInitialPuzzle();
      for (var board in boards) {
        _boards[board.id] = board;
      }
      _mutableValues = gameRepository.loadUserSolution();
      _hints = gameRepository.loadUserHints();
      for (var board in _boards.values) {
        _allValues[board.id] =
            _getAllValues(board.boardList, _mutableValues[board.id]);
      }
      var time = gameRepository.loadTime();
      yield NonRatingGamePuzzleRetrieved(
          _boards.values
              .map((board) => BoardData(
                    id: board.id,
                    initialValues: board.boardList,
                    filledValues: _mutableValues[board.id],
                    hints: _hints[board.id],
                  ))
              .toList(),
          gameMode);
      timerCubit.start(time);
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield NonRatingGameError();
    }
  }

  Stream<NonRatingGameState> _mapGameTimeChangedToState(
      _NonRatingGameTimeChanged event) async* {
    await gameRepository.saveTime(event.time);
  }

  Stream<NonRatingGameState> _mapGameBoardChangedToState(
      NonRatingGameBoardChanged event) async* {
    if (event.changedBoard.allValues != null) {
      _allValues[event.changedBoard.id] = event.changedBoard.allValues;
    }
    if (event.changedBoard.filledValues != null) {
      _mutableValues[event.changedBoard.id] = event.changedBoard.filledValues;
    }
    if (event.changedBoard.hints != null) {
      _hints[event.changedBoard.id] = event.changedBoard.hints;
    }
    if (_isSolved) {
      if (timerCubit.state is TimerTimeChanged) {
        timerCubit.stop();
        await gameRepository.clearSavedData();
        yield NonRatingGameFinished(SingleNonRatingGameResult(
            (timerCubit.state as TimerTimeChanged).milliseconds, gameMode));
      }
    } else {
      await gameRepository.saveUserSolution(_mutableValues);
      await gameRepository.saveUserHints(_hints);
    }
  }

  bool get _isSolved {
    return _boards.values
        .every((board) => listEquals(board.solutionList, _allValues[board.id]));
  }

  List<int> _getAllValues(List<int> initialValues, List<int> filledValues) {
    return List.generate(81, (index) {
      return initialValues[index] == 0
          ? filledValues[index]
          : initialValues[index];
    });
  }

  @override
  Future<void> close() async {
    _logger.v("Closed.");
    await timerSubscription.cancel();
    return super.close();
  }

  @override
  void onTransition(
      Transition<NonRatingGameEvent, NonRatingGameState> transition) {
    if (transition.event is! _NonRatingGameTimeChanged) {
      _logger.d(transition.toString());
    } else {
      _logger.v(transition.toString());
    }
    super.onTransition(transition);
  }
}
