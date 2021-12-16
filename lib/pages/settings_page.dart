import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';
import 'package:sudoku_game/widgets/modal_selector.dart';

class SettingsPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => SettingsPage(),
      settings: RouteSettings(name: "SettingsPage"),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 15,
              top: 15,
              child: CustomIconButton(
                iconData: Icons.arrow_back,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "settings".tr(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "language".tr(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    _getLanguageCodeName(
                                        context.locale.languageCode),
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              var locale = await showModalSelector(
                                context: context,
                                items: _getLanguageOptions(
                                    context.supportedLocales),
                                selectedValue: context.locale,
                                title: Text("language_selector_title".tr()),
                              );
                              if (locale != null) {
                                context.setLocale(locale);
                              }
                            },
                          ),
                          BlocBuilder<ThemeModeCubit, ThemeModeState>(
                            builder: (context, state) {
                              return InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "theme".tr(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        _getThemeModeName(state.themeMode),
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  var theme = await showModalSelector(
                                    context: context,
                                    items: _getThemeOptions(),
                                    selectedValue: state.themeMode,
                                    title: Text("theme_selector_title".tr()),
                                  );
                                  if (theme != null) {
                                    context
                                        .read<ThemeModeCubit>()
                                        .saveTheme(theme);
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageCodeName(String languageCode) {
    var languages = {"en": "English", "ru": "Русский", "uk": "Українська"};
    return languages[languageCode];
  }

  List<ModalSelectorItem<Locale>> _getLanguageOptions(
      List<Locale> supportedLocales) {
    return supportedLocales.map((locale) {
      return ModalSelectorItem(
        child: Text(
          _getLanguageCodeName(locale.languageCode),
          style: TextStyle(fontSize: 16),
        ),
        value: Locale(locale.languageCode),
      );
    }).toList();
  }

  String _getThemeModeName(ThemeMode themeMode) {
    var names = {
      ThemeMode.dark: "dark_theme",
      ThemeMode.light: "light_theme",
      ThemeMode.system: "system_theme",
    };
    return names[themeMode].tr();
  }

  List<ModalSelectorItem<ThemeMode>> _getThemeOptions() {
    return [ThemeMode.light, ThemeMode.dark]
        .map((e) => ModalSelectorItem(
            child: Text(_getThemeModeName(e), style: TextStyle(fontSize: 16)),
            value: e))
        .toList();
  }
}
