import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ranepa_timetable/about.dart';
import 'package:ranepa_timetable/intro.dart';
import 'package:ranepa_timetable/localizations.dart';
import 'package:ranepa_timetable/prefs.dart';
import 'package:ranepa_timetable/themes.dart';
import 'package:ranepa_timetable/timetable.dart';
import 'package:ranepa_timetable/widget_templates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseWidget extends StatelessWidget {
  Widget buildBase(BuildContext context, SharedPreferences prefs) {
    return Timetable(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  image: AssetImage('assets/images/icon-foreground.png'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(AppLocalizations.of(context).timetable),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context).prefs),
              onTap: () => Navigator.popAndPushNamed(context, Prefs.ROUTE),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(AppLocalizations.of(context).about),
              onTap: () => Navigator.popAndPushNamed(context, About.ROUTE),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.close),
              title: Text(AppLocalizations.of(context).close),
              onTap: () => SystemNavigator.pop(),
            ),
          ],
        ),
      ),
      prefs: prefs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetTemplates.buildFutureBuilder<SharedPreferences>(
      context,
      loading: Container(),
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final prefs = snapshot.data;
        return StreamBuilder<int>(
          stream: themeIdBloc.stream,
          initialData:
              prefs.getInt(PrefsIds.THEME_ID) ?? Themes.DEFAULT_THEME_ID.index,
          builder: (context, snapshot) {
            final themeId = snapshot.data;
            return MaterialApp(
              builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child),
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: [
                SupportedLocales.en,
                SupportedLocales.ru,
              ],
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context).title,
              theme: Themes.themes[themeId],
              routes: <String, WidgetBuilder>{
                Prefs.ROUTE: (context) => Prefs(),
                About.ROUTE: (context) => About(),
              },
              home: Builder(
                builder: (context) => prefs.getInt(
                            PrefsIds.PRIMARY_SEARCH_ITEM_PREFIX + PrefsIds.ITEM_ID) ==
                        null
                    ? Intro(base: buildBase(context, prefs), prefs: prefs)
                    : buildBase(context, prefs),
              ),
            );
          },
        );
      },
    );
  }
}

class SupportedLocales {
  static const Locale en = const Locale('en', 'US');
  static const Locale ru = const Locale('ru', 'RU');
}

final themeIdBloc = StreamController<int>.broadcast();

Future main() async {
  return runApp(BaseWidget());
}
