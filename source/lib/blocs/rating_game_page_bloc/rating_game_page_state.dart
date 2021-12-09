part of 'rating_game_page_bloc.dart';

class RatingGamePageState extends Equatable {
  final GameMode duelGameMode;
  final GameMode singleGameMode;
  final bool isError;

  const RatingGamePageState(
      {@required this.duelGameMode,
      @required this.singleGameMode,
      this.isError = false});

  factory RatingGamePageState.initial() {
    return RatingGamePageState(
        duelGameMode: GameMode.none, singleGameMode: GameMode.none);
  }

  RatingGamePageState copyWith(
      {GameMode duelGameMode, GameMode singleGameMode, bool isError}) {
    return RatingGamePageState(
      duelGameMode: duelGameMode ?? this.duelGameMode,
      singleGameMode: singleGameMode ?? this.singleGameMode,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object> get props => [duelGameMode, singleGameMode, isError];
}
