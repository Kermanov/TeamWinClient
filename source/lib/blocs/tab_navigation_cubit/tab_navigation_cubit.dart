import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';

part 'tab_navigation_state.dart';

class TabNavigationCubit extends Cubit<TabNavigationState> {
  final PageController pageController = PageController();
  Logger _logger;

  TabNavigationCubit() : super(TabNavigationState(0)) {
    pageController.addListener(() {
      int currentPage = pageController.page.round();
      if (currentPage != state.index) {
        emit(TabNavigationState(currentPage));
      }
    });

    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  void jumpToPage(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onChange(Change<TabNavigationState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }
}
