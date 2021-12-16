import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku_game/blocs/tab_navigation_cubit/tab_navigation_cubit.dart';
import 'package:sudoku_game/pages/play_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/widgets/animated_background.dart';

import 'rating_page.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => HomePage(),
      settings: RouteSettings(name: "HomePage"),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  final TabNavigationCubit _tabNavigationCubit = TabNavigationCubit();
  final List<Widget> _pages = [
    PlayPage(),
    RatingPage(),
    UserPage(),
  ];

  List<BottomNavigationBarItem> get _tabs => [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.gamepad),
          label: "tab.play".tr(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars),
          label: "tab.rating".tr(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box_rounded),
          label: "tab.profile".tr(),
        ),
      ];

  Future<void> _setCurrentScreen(int index) {
    var screenName = _pages[index].runtimeType.toString();
    return _analytics.setCurrentScreen(screenName: screenName);
  }

  @override
  void initState() {
    _setCurrentScreen(_tabNavigationCubit.state.index);
    super.initState();
  }

  @override
  void dispose() {
    _tabNavigationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _tabNavigationCubit,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.background,
            ),
            AnimatedBackground(),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: PageView(
                controller: _tabNavigationCubit.pageController,
                physics: new NeverScrollableScrollPhysics(),
                children: _pages,
              ),
              bottomNavigationBar: SizedBox(
                height: 75,
                child: BlocConsumer<TabNavigationCubit, TabNavigationState>(
                  bloc: _tabNavigationCubit,
                  listener: (context, state) async {
                    await _setCurrentScreen(state.index);
                  },
                  builder: (context, state) {
                    return BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: state.index,
                      items: _tabs,
                      onTap: (index) {
                        _tabNavigationCubit.jumpToPage(index);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
