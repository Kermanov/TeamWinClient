import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/blocs/rating_100_bloc/rating_100_bloc.dart';
import 'package:sudoku_game/blocs/rating_page_bloc/rating_page_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/rating_page_repository.dart';
import 'package:sudoku_game/repositories/rating_repository.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';
import 'package:sudoku_game/widgets/error.dart';
import 'package:sudoku_game/widgets/modal_selector.dart';
import 'package:sudoku_game/widgets/value_selector.dart';
import 'package:sudoku_game/widgets/rating_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/themes/theme.dart';

import 'info_page.dart';

class RatingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RatingPageState();
  }
}

class _RatingPageState extends State<RatingPage>
    with AutomaticKeepAliveClientMixin<RatingPage> {
  Rating100Bloc _ratingBloc;
  RatingPageBloc _ratingPageBloc;
  ScrollController _scrollController = ScrollController();
  Future<void> _initPageBlocFuture;

  Future<void> _initPageBloc() async {
    _ratingBloc = Rating100Bloc(ratingRepository: RatingRepository());
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
    super.initState();
  }

  @override
  void dispose() {
    _ratingBloc.close();
    _ratingPageBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<void>(
      future: _initPageBlocFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocListener<RatingPageBloc, RatingPageState>(
            bloc: _ratingPageBloc,
            listener: (context, state) {
              _ratingBloc.add(GetRating(state.gameMode, state.ratingType));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Center(
                  child: Text(
                    "rating_page_title".tr(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<RatingPageBloc, RatingPageState>(
                            bloc: _ratingPageBloc,
                            buildWhen: (previous, current) {
                              return previous.gameMode != current.gameMode;
                            },
                            builder: (context, state) {
                              return ValueSelector<GameMode>(
                                title: Text(
                                  "rating_difficulty_selector".tr(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                options: getGameModeOptions(),
                                selectedValue: state.gameMode,
                                onValueSelected: (value) {
                                  _ratingPageBloc.add(
                                      RatingPageSaveGameModeSettings(value));
                                },
                              );
                            },
                          ),
                          SizedBox(width: 16),
                          BlocBuilder<RatingPageBloc, RatingPageState>(
                            bloc: _ratingPageBloc,
                            buildWhen: (previous, current) {
                              return previous.ratingType != current.ratingType;
                            },
                            builder: (context, state) {
                              return ValueSelector<RatingType>(
                                title: Text(
                                  "rating_type_selector".tr(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                options: [
                                  ModalSelectorItem(
                                    child: Text(
                                      "rating_type.duel".tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: RatingType.duel,
                                  ),
                                  ModalSelectorItem(
                                    child: Text(
                                      "rating_type.best_time".tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: RatingType.solving,
                                  ),
                                ],
                                selectedValue: state.ratingType,
                                onValueSelected: (value) {
                                  _ratingPageBloc.add(
                                      RatingPageSaveRatingTypeSettings(value));
                                },
                              );
                            },
                          ),
                          Spacer(),
                          CustomIconButton(
                            iconData: Icons.info_outline,
                            iconColor: Theme.of(context).colorScheme.onPrimary,
                            size: 48,
                            padding: 2,
                            onTap: () {
                              showInfoPage(
                                context: context,
                                message: "info.rating".tr(),
                                title: "rating_page_title".tr(),
                              );
                            },
                          ),
                          BlocBuilder<Rating100Bloc, Rating100State>(
                            bloc: _ratingBloc,
                            builder: (context, state) {
                              return CustomIconButton(
                                iconData: Icons.refresh,
                                iconColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                size: 48,
                                padding: 2,
                                onTap: state is! RatingLoading
                                    ? () {
                                        _ratingBloc.add(GetRating(
                                            _ratingPageBloc.state.gameMode,
                                            _ratingPageBloc.state.ratingType));
                                      }
                                    : null,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<Rating100Bloc, Rating100State>(
                    bloc: _ratingBloc,
                    buildWhen: (_, state) {
                      return state is RatingDataLoaded;
                    },
                    builder: (context, state) {
                      if (state is RatingDataLoaded) {
                        if (state.ratingData.calibrationGamesLeft != null) {
                          return Text(
                            "calibration_games_message".tr(args: [
                              state.ratingData.calibrationGamesLeft.toString()
                            ]),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ),
                SizedBox(height: 4),
                BlocBuilder<Rating100Bloc, Rating100State>(
                  bloc: _ratingBloc,
                  buildWhen: (_, state) {
                    return state is RatingDataLoaded;
                  },
                  builder: (context, state) {
                    if (state is RatingDataLoaded &&
                        state.ratingData.currentPlace != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .accent
                                .withAlpha(128),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.accent,
                            ),
                          ),
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 16),
                              Text(
                                getPlaceString(
                                    state.ratingData.currentPlace.place),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                state.ratingData.currentPlace.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              state.ratingData.currentPlace.countryCode != null
                                  ? Text(
                                      getFlagEmoji(state
                                          .ratingData.currentPlace.countryCode),
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : Container(),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  ratingValueToString(
                                      state.ratingData.currentPlace.value,
                                      _ratingPageBloc.state.ratingType),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    children: [
                      BlocBuilder<Rating100Bloc, Rating100State>(
                        bloc: _ratingBloc,
                        buildWhen: (_, state) {
                          return state is RatingDataLoaded ||
                              state is RatingError;
                        },
                        builder: (context, state) {
                          if (state is RatingDataLoaded) {
                            if (state.ratingData.ratings.isEmpty) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: Text(
                                    "no_records_yet".tr(),
                                    style: TextStyle(fontSize: 17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RatingRow(
                                    ratingModel:
                                        state.ratingData.ratings[index],
                                    ratingType:
                                        _ratingPageBloc.state.ratingType);
                              },
                              controller: _scrollController,
                              itemCount: state.ratingData.ratings.length,
                            );
                          }
                          return Container();
                        },
                      ),
                      BlocBuilder<Rating100Bloc, Rating100State>(
                        bloc: _ratingBloc,
                        builder: (context, state) {
                          if (state is RatingLoading) {
                            return Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                ),
                              ),
                            );
                          } else if (state is RatingError) {
                            return ErrorMessageWithIcon(
                              message: "error.get_data_error".tr(),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
