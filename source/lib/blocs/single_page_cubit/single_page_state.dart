part of 'single_page_cubit.dart';

class SinglePageState extends Equatable {
  final GameMode gameMode;
  final SavedGameInfo savedGameInfo;

  const SinglePageState(this.gameMode, this.savedGameInfo);

  factory SinglePageState.initial() {
    return SinglePageState(GameMode.onePuzzleEasy, null);
  }

  SinglePageState copyWith(
      {GameMode gameMode, bool isRatingGame, SavedGameInfo savedGameInfo}) {
    return SinglePageState(
        gameMode ?? this.gameMode, savedGameInfo ?? this.savedGameInfo);
  }

  @override
  List<Object> get props => [gameMode, savedGameInfo];

  @override
  String toString() {
    return "SinglePageState($gameMode, savedGameInfo: $savedGameInfo)";
  }
}

class SavedGameInfo extends Equatable {
  final GameMode gameMode;
  final int time;

  factory SavedGameInfo.empty() {
    return SavedGameInfo(gameMode: GameMode.none, time: -1);
  }

  SavedGameInfo({@required this.gameMode, @required this.time});

  @override
  List<Object> get props => [gameMode, time];
}
