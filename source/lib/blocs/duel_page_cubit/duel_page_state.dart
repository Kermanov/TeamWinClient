part of 'duel_page_cubit.dart';

class DuelPageState extends Equatable {
  final GameMode gameMode;

  const DuelPageState(this.gameMode);

  @override
  List<Object> get props => [gameMode];
}
