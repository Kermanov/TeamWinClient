import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/theme_mode_cubit/theme_mode_cubit.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ThemeModeCubit>()
        .setPlatformBrightness(MediaQuery.of(context).platformBrightness);
    return Material(color: Theme.of(context).colorScheme.background);
  }
}
