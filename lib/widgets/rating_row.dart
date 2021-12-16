import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/auth/auth_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/rating_model.dart';

class RatingRow extends StatelessWidget {
  final RatingModel ratingModel;
  final RatingType ratingType;

  const RatingRow({@required this.ratingModel, @required this.ratingType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 55,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 46,
                      child: Text(
                        getPlaceString(ratingModel.place),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Flexible(
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Text(
                            ratingModel.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: state is AuthAuthenticatedState &&
                                      state.userId == ratingModel.id
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    ratingModel.countryCode != null
                        ? Text(
                            getFlagEmoji(ratingModel.countryCode),
                            style: TextStyle(fontSize: 18),
                            maxLines: 1,
                          )
                        : Container(),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              Text(
                ratingValueToString(ratingModel.value, ratingType),
                style: TextStyle(fontSize: 18),
                maxLines: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
