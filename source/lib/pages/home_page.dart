import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/bottom_navigation_cubit/bottom_navigation_cubit.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => HomePage(), settings: RouteSettings(name: "HomePage"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationCubit(),
      child: Scaffold(
          body: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          return state.page;
        },
      ), bottomNavigationBar:
              BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
                  builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.index,
          items: [
            for (var item in state.items)
              BottomNavigationBarItem(
                  icon: Icon(item.iconData), label: item.title)
          ],
          onTap: (index) {
            context.read<BottomNavigationCubit>().setIndex(index);
          },
        );
      })),
    );
  }
}
