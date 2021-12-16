import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:easy_logger/easy_logger.dart';

import 'app.dart';
import 'constants/shared_preferences_constants.dart';
import 'helpers/ads_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  EasyLocalization.logger.enableLevels = [LevelMessages.warning];
  await EasyLocalization.ensureInitialized();
  AdsHelper.init();
  Logger.level = Level.warning;
  var themeMode = await getThemeMode();
  runApp(EasyLocalization(
    useOnlyLangCode: true,
    supportedLocales: [Locale('en'), Locale('uk'), Locale('ru')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),
    child: App(authRepository: AuthRepository(), themeMode: themeMode),
  ));
}

Future<ThemeMode> getThemeMode() async {
  var themeMode = ThemeMode.system;
  var prefs = await SharedPreferences.getInstance();
  var themeModeIndex = prefs.getInt(SharedPreferencesConstants.themeModeKey);
  if (themeModeIndex != null) {
    themeMode = ThemeMode.values[themeModeIndex];
  }
  return themeMode;
}
