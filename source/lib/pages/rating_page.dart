import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/blocs/rating_bloc/rating_bloc.dart';
import 'package:sudoku_game/blocs/rating_page_bloc/rating_page_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/rating_page_repository.dart';
import 'package:sudoku_game/repositories/rating_repository.dart';
import 'package:sudoku_game/widgets/modal_selector.dart';
import 'package:sudoku_game/widgets/value_selector.dart';
import 'package:sudoku_game/widgets/rating_row.dart';

import 'info_page.dart';

class RatingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RatingPageState();
  }
}

class _RatingPageState extends State<RatingPage>
    with AutomaticKeepAliveClientMixin<RatingPage> {
  RatingBloc _ratingBloc;
  RatingPageBloc _ratingPageBloc;
  ScrollController _scrollController = ScrollController();
  double _scrollThreshold = 200.0;
  Future<void> _initPageBlocFuture;

  Future<void> _initPageBloc() async {
    _ratingBloc = RatingBloc(ratingRepository: RatingRepository());
    _ratingPageBloc = RatingPageBloc(
      ratingBloc: _ratingBloc,
      repository: RatingPageRepository(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );
    _ratingPageBloc.add(RatingPageLoadSettings());
  }

  @override
  void initState() {
    _initPageBlocFuture = _initPageBloc();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: Text(
                    "World Rating",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder<void>(
                future: _initPageBlocFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BlocListener<RatingPageBloc, RatingPageState>(
                      bloc: _ratingPageBloc,
                      listener: (context, state) {
                        _ratingBloc.add(
                            RatingRefresh(state.gameMode, state.ratingType));
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BlocBuilder<RatingPageBloc,
                                        RatingPageState>(
                                      bloc: _ratingPageBloc,
                                      buildWhen: (previous, current) {
                                        return previous.gameMode !=
                                            current.gameMode;
                                      },
                                      builder: (context, state) {
                                        return ValueSelector<GameMode>(
                                          width: 110,
                                          title: Text("Game Mode"),
                                          options: getGameModeOptions(),
                                          selectedValue: state.gameMode,
                                          onValueSelected: (value) {
                                            _ratingPageBloc.add(
                                                RatingPageSaveGameModeSettings(
                                                    value));
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(width: 20),
                                    BlocBuilder<RatingPageBloc,
                                        RatingPageState>(
                                      bloc: _ratingPageBloc,
                                      buildWhen: (previous, current) {
                                        return previous.ratingType !=
                                            current.ratingType;
                                      },
                                      builder: (context, state) {
                                        return ValueSelector<RatingType>(
                                          width: 130,
                                          title: Text("Rating Type"),
                                          options: [
                                            ModalSelectorItem(
                                              child: Text("Duel Rating"),
                                              value: RatingType.duel,
                                            ),
                                            ModalSelectorItem(
                                              child: Text("Best time"),
                                              value: RatingType.solving,
                                            ),
                                          ],
                                          selectedValue: state.ratingType,
                                          onValueSelected: (value) {
                                            _ratingPageBloc.add(
                                                RatingPageSaveRatingTypeSettings(
                                                    value));
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    BlocBuilder<RatingPageBloc,
                                        RatingPageState>(
                                      bloc: _ratingPageBloc,
                                      builder: (context, state) {
                                        return Text(
                                          state.ratingType == RatingType.duel
                                              ? "Duel Rating"
                                              : "Best Time",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  color: Colors.black54,
                                  height: 1,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<RatingBloc, RatingState>(
                              bloc: _ratingBloc,
                              builder: (context, state) {
                                if (state is RatingInitial ||
                                    state is RatingLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (state is RatingDataLoaded) {
                                  return RefreshIndicator(
                                      onRefresh: () {
                                        _ratingBloc.add(RatingRefresh(
                                            _ratingPageBloc.state.gameMode,
                                            _ratingPageBloc.state.ratingType));
                                        return Future.delayed(Duration.zero);
                                      },
                                      child: ListView.builder(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return RatingRow(
                                              ratingModel:
                                                  state.ratingData[index],
                                              ratingType: _ratingPageBloc
                                                  .state.ratingType);
                                        },
                                        controller: _scrollController,
                                        itemCount: state.ratingData.length,
                                      ));
                                } else if (state is RatingError) {
                                  return Center(child: Text("Error."));
                                }
                                return Container();
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 15,
          top: 15,
          child: IconButton(
            icon: Icon(Icons.info_outline),
            iconSize: 32,
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (_) => InfoPage(
                    message:
                        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim."),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _ratingBloc.add(RatingFetch(
          _ratingPageBloc.state.gameMode, _ratingPageBloc.state.ratingType));
    }
  }
}
