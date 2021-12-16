part of 'rating_page_bloc.dart';

class RatingPageState extends Equatable {
  final GameMode gameMode;
  final RatingType ratingType;
  final bool isError;

  const RatingPageState(
      {@required this.gameMode,
      @required this.ratingType,
      this.isError = false});

  factory RatingPageState.initial() {
    return RatingPageState(
        gameMode: GameMode.none, ratingType: RatingType.duel);
  }

  RatingPageState copyWith(
      {GameMode gameMode, RatingType ratingType, bool isError}) {
    return RatingPageState(
      gameMode: gameMode ?? this.gameMode,
      ratingType: ratingType ?? this.ratingType,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object> get props => [gameMode, ratingType, isError];
}
