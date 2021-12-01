import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/pages/duel_page.dart';
import 'package:sudoku_game/pages/single_page.dart';
import 'package:sudoku_game/pages/user_page.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationItem {
  IconData iconData;
  String title;

  BottomNavigationItem(this.iconData, this.title);
}

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  static List<BottomNavigationItem> _items = [
    BottomNavigationItem(Icons.people_outline, "Duel"),
    BottomNavigationItem(Icons.person_outline, "Single"),
    BottomNavigationItem(Icons.account_box_rounded, "Profile")
  ];

  static List<Widget> _pages = [DuelPage(), SinglePage(), UserPage()];

  BottomNavigationCubit() : super(BottomNavigationState(_items, 0, _pages[0]));

  void setIndex(int index) {
    emit(BottomNavigationState(_items, index, _pages[index]));
  }
}
