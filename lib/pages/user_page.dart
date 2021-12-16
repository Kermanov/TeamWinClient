import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/auth/auth_bloc.dart';
import 'package:sudoku_game/blocs/user_page_bloc/user_page_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/user_stats_item_model.dart';
import 'package:sudoku_game/pages/profile_update_page.dart';
import 'package:sudoku_game/pages/settings_page.dart';
import 'package:sudoku_game/repositories/user_repository.dart';
import 'package:sudoku_game/widgets/context_menu.dart';
import 'package:sudoku_game/widgets/country_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';
import 'package:sudoku_game/widgets/error.dart';
import 'package:sudoku_game/widgets/text_divider.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin<UserPage> {
  UserPageBloc _userPageBloc;

  @override
  void initState() {
    _userPageBloc = UserPageBloc(userRepository: UserRepository());
    _userPageBloc.add(UserPageFetchData());
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _userPageBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UserPageBloc, UserPageState>(
      bloc: _userPageBloc,
      builder: (context, state) {
        return Stack(
          children: [
            state.hasData
                ? Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.userModel.name,
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              state.userModel.country != null
                                  ? CountryWidget(state.userModel.country)
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DefaultTabController(
                          length: state.userStats.keys.length,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                  height: 48,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[3],
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Theme(
                                      data: ThemeData(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                      ),
                                      child: TabBar(
                                        indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(64),
                                        ),
                                        labelColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        tabs: state.userStats.keys
                                            .map((e) => Tab(
                                                  text: getGameModeName(e),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                    children: state.userStats.values
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Stats(
                                              stats: e,
                                            ),
                                          ),
                                        )
                                        .toList()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            state.isLoading
                ? Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(strokeWidth: 6),
                    ),
                  )
                : Container(),
            state.isError
                ? ErrorMessageWithIcon(message: "error.get_data_error".tr())
                : Container(),
            Positioned(
              right: 15,
              top: 15,
              child: Row(
                children: [
                  CustomIconButton(
                    iconData: Icons.refresh,
                    onTap: () {
                      _userPageBloc.add(UserPageFetchData());
                    },
                  ),
                  CustomIconButton(
                    iconData: Icons.more_vert,
                    onTap: () {
                      showContextMenu(
                          context: context, items: getContextMenuItems(state));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> getContextMenuItems(UserPageState state) {
    var items = [
      ContextMenuItem(
        child: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 5),
            Text("settings".tr(), style: TextStyle(fontSize: 16)),
          ],
        ),
        onTap: () async {
          Navigator.pop(context);
          await Navigator.push(context, SettingsPage.route());
        },
      ),
      ContextMenuItem(
        child: Row(
          children: [
            Icon(Icons.exit_to_app),
            SizedBox(width: 5),
            Text("log_out".tr(), style: TextStyle(fontSize: 16)),
          ],
        ),
        onTap: () {
          context.read<AuthBloc>().add(AuthSignOutRequested());
        },
      )
    ];
    if (state.hasData) {
      items.insert(
          0,
          ContextMenuItem(
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 5),
                Text("edit_profile".tr(), style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  ProfileUpdatePage.route(_userPageBloc, state.userModel));
            },
          ));
    }
    return items;
  }

  @override
  bool get wantKeepAlive => true;
}

class Stats extends StatelessWidget {
  final UserStatsItem stats;

  Stats({@required this.stats});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.surface.withAlpha(182),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatsRow(
              name: "stats.total_games".tr(),
              value: stats.totalGamesStarted.toString(),
            ),
            StatsRow(
              name: "stats.best_time".tr(),
              value: stats.solvingTime != null
                  ? formatTime(stats.solvingTime)
                  : "--",
            ),
            TextDivider(text: "game_type.duel".tr()),
            StatsRow(
              name: "stats.games_started".tr(),
              value: stats.duelGamesStarted.toString(),
            ),
            StatsRow(
              name: "stats.games_won".tr(),
              value: stats.duelGamesWon.toString(),
            ),
            StatsRow(
              name: "stats.win_rate".tr(),
              value: stats.duelGameWinsPercent != null
                  ? "${stats.duelGameWinsPercent}%"
                  : "--",
            ),
            StatsRow(
              name: "stats.rating".tr(),
              value: stats.duelRating?.toString() ?? "--",
            ),
            TextDivider(text: "game_type.single".tr()),
            StatsRow(
              name: "stats.games_started".tr(),
              value: stats.singleGamesStarted.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  final String name;
  final String value;

  StatsRow({@required this.name, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
