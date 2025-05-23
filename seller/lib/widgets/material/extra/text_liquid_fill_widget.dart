/*
* File : Text Liquid Fill
* Version : 1.0.0
* */

import 'package:seller/widgets/custom/text_liquid_fill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/theme/app_theme.dart';

class TextLiquidFillWidget extends StatefulWidget {
  @override
  _TextLiquidFillWidgetState createState() => _TextLiquidFillWidgetState();
}

class _TextLiquidFillWidgetState extends State<TextLiquidFillWidget> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
            backgroundColor: Colors.black,
            body: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(FeatherIcons.chevronLeft),
                  ),
                ),
                TextLiquidFill(
                    text: "FLUTTER",
                    loadDuration: Duration(seconds: 15),
                    waveDuration: Duration(milliseconds: 600),
                    waveColor: Colors.blue,
                    textStyle: FxTextStyle.displaySmall(
                      fontWeight: 800,
                    )),
                TextLiquidFill(
                    text: "UIKIT",
                    loadDuration: Duration(seconds: 15),
                    waveDuration: Duration(milliseconds: 700),
                    waveColor: Colors.red,
                    textStyle: FxTextStyle.displaySmall(
                      fontWeight: 800,
                    )),
                TextLiquidFill(
                    text: "LIQUID",
                    loadDuration: Duration(seconds: 15),
                    waveDuration: Duration(milliseconds: 800),
                    waveColor: Colors.green,
                    textStyle: FxTextStyle.displaySmall(
                      fontWeight: 800,
                    )),
                TextLiquidFill(
                    text: "EFFECT",
                    loadDuration: Duration(seconds: 15),
                    waveDuration: Duration(milliseconds: 900),
                    waveColor: Colors.yellow,
                    textStyle: FxTextStyle.displaySmall(
                      fontWeight: 800,
                    )),
              ],
            )));
  }
}
