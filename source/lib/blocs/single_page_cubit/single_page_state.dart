part of 'single_page_cubit.dart';

class SinglePageState extends Equatable {
  final GameMode gameMode;
  final bool isRatingGame;
  final bool isSaveAvailable;

  const SinglePageState(this.gameMode, this.isRatingGame, this.isSaveAvailable);

  SinglePageState copyWith(
      {GameMode gameMode, bool isRatingGame, bool isSaveAvailable}) {
    return SinglePageState(
        gameMode ?? this.gameMode,
        isRatingGame ?? this.isRatingGame,
        isSaveAvailable ?? this.isSaveAvailable);
  }

  @override
  List<Object> get props => [gameMode, isRatingGame, isSaveAvailable];
}
