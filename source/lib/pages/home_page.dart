import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/tab_navigation_cubit/tab_navigation_cubit.dart';

import 'duel_page.dart';
import 'rating_page.dart';
import 'single_page.dart';
import 'user_page.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => HomePage(), settings: RouteSettings(name: "HomePage"));
  }

  final TabNavigationCubit _tabNavigationCubit = TabNavigationCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _tabNavigationCubit,
      child: Scaffold(
        body: PageView(
          controller: _tabNavigationCubit.pageController,
          children: [
            DuelPage(),
            SinglePage(),
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
                  icon: Icon(Icons.people_outline),
                  label: "Duel",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: "Single",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.stars),
                  label: "Rating",
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
    );
  }
}
