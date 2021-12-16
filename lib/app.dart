import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/auth/auth_bloc.dart';
import 'package:sudoku_game/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:sudoku_game/blocs/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:sudoku_game/pages/home_page.dart';
import 'package:sudoku_game/pages/login_page.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:sudoku_game/pages/splash_page.dart';
import 'package:sudoku_game/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;
  final ThemeMode themeMode;

  App({@required this.authRepository, @required this.themeMode})
      : assert(authRepository != null),
        assert(themeMode != null);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) => ConnectivityBloc(),
          ),
          BlocProvider(
            create: (context) => ThemeModeCubit(themeMode: themeMode),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        return MaterialApp(
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: _analytics)
          ],
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          builder: (context, child) {
            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticatedState) {
                  _navigator.pushAndRemoveUntil<void>(
                      HomePage.route(), (route) => false);
                } else if (state is AuthUnauthenticatedState) {
                  _navigator.pushAndRemoveUntil<void>(
                      LoginPage.route(), (route) => false);
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => SplashPage.route(),
        );
      },
    );
  }
}
