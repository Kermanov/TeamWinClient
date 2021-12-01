import 'package:flutter/material.dart';
import 'package:sudoku_game/blocs/rating_bloc/rating_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/rating_repository.dart';
import 'package:sudoku_game/widgets/rating.dart';

class RatingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RatingPageState();
  }
}

class _RatingPageState extends State<RatingPage>
    with AutomaticKeepAliveClientMixin<RatingPage> {
  RatingRepository _ratingRepository;
  List<RatingBloc> _duelBlocs;
  List<RatingBloc> _solvingBlocs;

  @override
  void initState() {
    _ratingRepository = RatingRepository();
    _duelBlocs = [
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.onePuzzleEasy,
          ratingType: RatingType.duel),
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.onePuzzleMedium,
          ratingType: RatingType.duel),
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.onePuzzleHard,
          ratingType: RatingType.duel),
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.threePuzzles,
          ratingType: RatingType.duel),
    ];
    _solvingBlocs = [
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.onePuzzleEasy,
          ratingType: RatingType.solving),
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.onePuzzleMedium,
          ratingType: RatingType.solving),
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.onePuzzleHard,
          ratingType: RatingType.solving),
      RatingBloc(
          ratingRepository: _ratingRepository,
          gameMode: GameMode.threePuzzles,
          ratingType: RatingType.solving),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Rating"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [Tab(text: "Duel"), Tab(text: "Solving")],
          ),
        ),
        body: TabBarView(
          children: [
            DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: AppBar(
                    bottom: TabBar(
                      tabs: [
                        Tab(text: "Easy"),
                        Tab(text: "Medium"),
                        Tab(text: "Hard"),
                        Tab(text: "All"),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                    children: _duelBlocs.map((bloc) {
                  return Rating(ratingBloc: bloc);
                }).toList()),
              ),
            ),
            DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: AppBar(
                    bottom: TabBar(
                      tabs: [
                        Tab(text: "Easy"),
                        Tab(text: "Medium"),
                        Tab(text: "Hard"),
                        Tab(text: "All"),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                    children: _solvingBlocs.map((bloc) {
                  return Rating(ratingBloc: bloc);
                }).toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
