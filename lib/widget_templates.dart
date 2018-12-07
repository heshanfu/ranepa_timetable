import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ranepa_timetable/localizations.dart';

class WidgetTemplates {
  static Widget buildPreferenceButton(BuildContext context,
      {@required String title,
      @required String description,
      @required VoidCallback onPressed,
      Widget rightWidget}) {
    var rowChildren;
    rowChildren = <Widget>[
      Expanded(
          child: ListBody(
        children: <Widget>[
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
        ],
      )),
    ];

    if (rightWidget != null) rowChildren.add(rightWidget);

    return FlatButton(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Row(children: rowChildren)),
      onPressed: onPressed,
    );
  }

  static Widget buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Container(height: 5),
          Text(
            AppLocalizations.of(context).loading,
            style: Theme.of(context).textTheme.subtitle,
          )
        ],
      ),
    );
  }
}
