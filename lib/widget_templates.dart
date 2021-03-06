import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ranepa_timetable/localizations.dart';
import 'package:ranepa_timetable/search.dart';
import 'package:ranepa_timetable/timetable.dart';
import 'package:ranepa_timetable/timetable_icons.dart';

class WidgetTemplates {
  static Widget buildPreferenceButton(BuildContext context,
      {@required String title,
      @required String description,
      VoidCallback onPressed,
      Widget rightWidget,
      Widget bottomWidget}) {
    var expandedChildren = <Widget>[
      Text(
        title,
        style: Theme.of(context).textTheme.subhead,
      ),
      Container(
        height: 2,
      ),
      Text(
        description,
        style: Theme.of(context).textTheme.caption,
      ),
    ];

    if (bottomWidget != null) expandedChildren.add(bottomWidget);

    var rowChildren = <Widget>[
      Expanded(child: ListBody(children: expandedChildren)),
    ];

    if (rightWidget != null) rowChildren.add(rightWidget);

    return FlatButton(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Row(children: rowChildren)),
      onPressed: onPressed ?? () {},
    );
  }

  static Widget _buildNotification(
          BuildContext context, String text, Widget widget) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget,
            Container(height: 20),
            Text(
              text,
              style: Theme.of(context).textTheme.title,
            )
          ],
        ),
      );

  static Widget _buildIconNotification(BuildContext context, String text,
          [IconData icon]) =>
      _buildNotification(
        context,
        text,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Icon(icon, size: 140),
        ),
      );

  static Widget buildLoadingNotification(BuildContext context) =>
      _buildNotification(
        context,
        AppLocalizations.of(context).loading,
        CircularProgressIndicator(),
      );

  static Widget buildErrorNotification(BuildContext context, String error) =>
      _buildIconNotification(context, error, Icons.error);

  static Widget buildNetworkErrorNotification(
          BuildContext context) =>
      _buildNotification(
        context,
        AppLocalizations.of(context).noNetworkConnection,
        RawMaterialButton(
          onPressed: () => timetableFutureBuilderBloc.add(null),
          child: Icon(
            Icons.refresh,
            size: 100,
          ),
          shape: CircleBorder(),
          padding: const EdgeInsets.all(30),
        ),
      );

  static Widget buildNoCacheNotification(
      BuildContext context) =>
      _buildNotification(
        context,
        AppLocalizations.of(context).noCache,
        RawMaterialButton(
          onPressed: () => timetableFutureBuilderBloc.add(null),
          child: Icon(
            Icons.cached,
            size: 100,
          ),
          shape: CircleBorder(),
          padding: const EdgeInsets.all(30),
        ),
      );

  static SvgPicture buildLogo(ThemeData theme, {
    Color color,
  }) =>
      SvgPicture.asset(
        'assets/images/logo.svg',
        color: color == null ? theme.accentTextTheme.title.color : color,
        width: 150,
        height: 150,
      );

  static Widget buildFreeDayNotification(
      BuildContext context, SearchItem searchItem) {
    IconData icon;
    switch (searchItem.typeId) {
      case SearchItemTypeId.Teacher:
        icon = TimetableIcons.confetti;
        break;
      case SearchItemTypeId.Group:
        icon = TimetableIcons.beer;
        break;
    }

    return _buildIconNotification(
        context, AppLocalizations.of(context).freeDay, icon);
  }

  static Widget buildFutureBuilder<T>(
    BuildContext context, {
    @required Future future,
    @required AsyncWidgetBuilder<T> builder,
    Widget loading,
    Widget error,
  }) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext _, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return loading ??
                  WidgetTemplates.buildLoadingNotification(context);
              break;
            case ConnectionState.done:
              if (snapshot.hasError)
                return error ??
                    WidgetTemplates.buildErrorNotification(
                        context, snapshot.error ?? "Unknown");
              return builder(context, snapshot);
          }
        });
  }
}
