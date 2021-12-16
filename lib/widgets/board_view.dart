import 'package:flutter/material.dart';
import 'package:sudoku_game/blocs/board_cubit/board_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'board.dart';
import 'board_input.dart';

class BoardView extends StatefulWidget {
  final List<BoardData> boards;
  final void Function(ChangedBoardData) onBoardChanges;

  BoardView({@required this.boards, this.onBoardChanges})
      : assert(boards != null);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final List<BoardCubit> cubits = [];

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    for (var board in widget.boards) {
      cubits.add(
          BoardCubit(boardData: board, onBoardChanges: widget.onBoardChanges));
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var cubit in cubits) {
      cubit.close();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return false;
            },
            child: PageView(
              controller: _pageController,
              children: widget.boards
                  .map((board) => Padding(
                        padding: EdgeInsets.all(8),
                        child: Board(
                          boardCubit: cubits[widget.boards.indexOf(board)],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        widget.boards.length > 1
            ? Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.boards.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      dotColor:
                          Theme.of(context).colorScheme.primary.withAlpha(64),
                      activeDotColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: BoardInput(
            onNumberSelected: (number) {
              cubits[_pageController.page.round()].numberSelected(number);
            },
            onhintModeChanged: (hintMode) {
              for (var cubit in cubits) {
                cubit.setHintMode(hintMode);
              }
            },
          ),
        ),
      ],
    );
  }
}
