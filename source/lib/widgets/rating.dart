import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/rating_bloc/rating_bloc.dart';
import 'package:sudoku_game/widgets/rating_row.dart';

class Rating extends StatefulWidget {
  final RatingBloc ratingBloc;

  Rating({@required this.ratingBloc});

  @override
  State<StatefulWidget> createState() {
    return _RatingState();
  }
}

class _RatingState extends State<Rating> {
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget.ratingBloc.add(RatingFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingBloc, RatingState>(
      bloc: widget.ratingBloc,
      builder: (context, state) {
        if (state is RatingInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RatingDataLoaded) {
          return RefreshIndicator(
              onRefresh: () {
                widget.ratingBloc.add(RatingRefresh());
                return Future.delayed(Duration(milliseconds: 500), () {});
              },
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RatingRow(
                      ratingModel: state.ratingData[index],
                      ratingType: widget.ratingBloc.ratingType);
                },
                controller: _scrollController,
                itemCount: state.ratingData.length,
              ));
        } else if (state is RatingError) {
          return Center(child: Text("Error."));
        } else {
          return Container();
        }
      },
    );
  }
}
