import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ranepa_timetable/localizations.dart';
import 'package:ranepa_timetable/themes.dart';
import 'package:ranepa_timetable/widget_templates.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  static const ROUTE = "/about";

  Widget _buildGuyIconContent(
    BuildContext context,
    TextTheme textTheme,
    String name,
    String url,
    String image, {
    String descriptionLeft,
    String descriptionRight,
    String singleStr,
  }) =>
      Container(
        height: 220,
        child: GestureDetector(
          onTap: () => openUrl("https://vk.com/$url"),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: textTheme.title.color,
                    image: DecorationImage(
                      image: AssetImage('assets/images/$image.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: textTheme.title.color,
                      width: 4.0,
                    ),
                  ),
                ),
              ),
              Container(height: 20),
              RichText(
                text: TextSpan(
                  text: '$name\n',
                  style: textTheme.title,
                  children: <TextSpan>[
                    TextSpan(
                      text: '"$url"',
                      style: textTheme.body2,
                    ),
                  ],
                ),
              ),
              Container(height: 10),
              Expanded(
                child: Center(
                  child: singleStr != null
                      ? AutoSizeText(
                          singleStr,
                          style: textTheme.subtitle,
                          textAlign: TextAlign.center,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          verticalDirection: VerticalDirection.down,
                          children: <Widget>[
                            Flexible(
                              child: AutoSizeText(
                                descriptionLeft,
                                style: textTheme.subtitle,
                                textAlign: TextAlign.right,
                                minFontSize: 2,
                                maxLines: descriptionLeft.split('\n').length,
                                softWrap: false,
                              ),
                            ),
                            Container(width: 4),
                            Flexible(
                              child: AutoSizeText(
                                descriptionRight,
                                style: textTheme.subtitle,
                                textAlign: TextAlign.left,
                                maxLines: descriptionRight.split('\n').length,
                                minFontSize: 2,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildGuyIcon(
    BuildContext context,
    TextTheme textTheme,
    String name,
    String url,
    String image,
    Orientation orientation, {
    String descriptionLeft,
    String descriptionRight,
    String singleStr,
  }) =>
      orientation == Orientation.portrait
          ? Flexible(
              child: _buildGuyIconContent(
              context,
              textTheme,
              name,
              url,
              image,
              descriptionRight: descriptionRight,
              descriptionLeft: descriptionLeft,
              singleStr: singleStr,
            ))
          : Container(
              width: 130,
              child: _buildGuyIconContent(
                context,
                textTheme,
                name,
                url,
                image,
                descriptionRight: descriptionRight,
                descriptionLeft: descriptionLeft,
                singleStr: singleStr,
              ));

  List<Widget> _buildGuys(
    BuildContext context,
    TextTheme textTheme,
    Orientation orientation,
  ) =>
      <Widget>[
        _buildGuyIcon(
          context,
          textTheme,
          'Вадим',
          'overveigh',
          'vadim',
          orientation,
          descriptionLeft: 'IOS',
          descriptionRight: 'разработчик\nтeстировщик',
        ),
        _buildGuyIcon(
          context,
          textTheme,
          'Николай',
          'cooloneofficial',
          'coolone',
          orientation,
          descriptionLeft: 'Flutter\nAndroid',
          descriptionRight: 'разработчик',
        ),
        _buildGuyIcon(
          context,
          textTheme,
          'Александр',
          'xr.aleks01',
          'xr',
          orientation,
          singleStr: 'Креативный\nдиректор',
        ),
      ];

  List<Widget> _buildLogoText(
    BuildContext context,
    TextTheme textTheme,
    Orientation orientation,
  ) =>
      <Widget>[
        Padding(
          padding: const EdgeInsets.all(20),
          child: WidgetTemplates.buildLogo(
            Theme.of(context),
            color: textTheme.title.color,
          ),
        ),
        orientation == Orientation.landscape
            ? Container(
                width: 200,
                child: AutoSizeText(
                  AppLocalizations.of(context).introWelcomeDescription,
                  style: textTheme.title,
                  textAlign: TextAlign.center,
                ))
            : AutoSizeText(
                AppLocalizations.of(context).introWelcomeDescription,
                style: textTheme.title,
                textAlign: TextAlign.center,
              ),
      ];

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final textTheme = (currentTheme.brightness == Brightness.dark &&
            currentTheme.accentColor !=
                Themes.themes[ThemeIds.DARK.index].accentColor
        ? Theme.of(context).accentTextTheme
        : Theme.of(context).primaryTextTheme);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(AppLocalizations.of(context).about),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/coolone_logo.svg',
              color: textTheme.title.color,
            ),
            onPressed: () => openUrl('http://coolone.ru/'),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/github.svg',
              color: textTheme.title.color,
            ),
            onPressed: () =>
                openUrl('https://github.com/CoolONEOfficial/ranepa_timetable'),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => Container(
              padding: EdgeInsets.all(10),
              color: Theme.of(context).primaryColor,
              child: orientation == Orientation.portrait
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: _buildLogoText(
                                    context, textTheme, orientation),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: _buildGuys(context, textTheme, orientation),
                        ),
                      ],
                    )
                  : Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _buildLogoText(
                            context, textTheme, orientation)
                          ..addAll(_buildGuys(context, textTheme, orientation)),
                      ),
                    ),
            ),
      ),
    );
  }

  void openUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
  }
}
