import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/tab_navigation_cubit/tab_navigation_cubit.dart';
import 'package:sudoku_game/pages/competetive_page.dart';
import 'package:sudoku_game/pages/free_play_page.dart';

import 'rating_page.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => HomePage(), settings: RouteSettings(name: "HomePage"));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TabNavigationCubit _tabNavigationCubit = TabNavigationCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _tabNavigationCubit,
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            controller: _tabNavigationCubit.pageController,
            children: [
              CompetetivePage(),
              FreePlayPage(),
              RatingPage(),
              UserPage(),
            ],
          ),
          bottomNavigationBar:
              BlocBuilder<TabNavigationCubit, TabNavigationState>(
            bloc: _tabNavigationCubit,
            builder: (context, state) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: state.index,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.wifi_outlined),
                    label: "Competetive",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.timelapse),
                    label: "Free Play",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.stars),
                    label: "World Rating",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_rounded),
                    label: "Profile",
                  ),
                ],
                onTap: (index) {
                  _tabNavigationCubit.jumpToPage(index);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
