part of 'game_search_bloc.dart';

abstract class GameSearchState extends Equatable {
  const GameSearchState();

  @override
  List<Object> get props => [];
}

class GameSearchInitial extends GameSearchState {}

class GameSearchProcessing extends GameSearchState {}

class GameSearchError extends GameSearchState {}

class GameSearchComplete extends GameSearchState {
  final String gameId;

  const GameSearchComplete(this.gameId);

  @override
  List<Object> get props => [gameId];

  @override
  String toString() {
    return "GameSearchComplete($gameId)";
  }
}

class GameSearchAborting extends GameSearchState {}
