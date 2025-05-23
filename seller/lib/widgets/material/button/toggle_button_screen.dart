/*
* File : Toggle Button
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/theme/app_theme.dart';

class ToggleButtonScreen extends StatefulWidget {
  @override
  _ToggleButtonScreenState createState() => _ToggleButtonScreenState();
}

class _ToggleButtonScreenState extends State<ToggleButtonScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  List<bool> isSelected = [false, true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: theme.colorScheme.background,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: FxSpacing.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: FxSpacing.bottom(8),
                        child: FxText.titleSmall("Simple", fontWeight: 700),
                      ),
                      ToggleButtons(
                        splashColor: theme.colorScheme.primary.withAlpha(48),
                        fillColor: Colors.transparent,
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        children: const <Widget>[
                          Icon(Icons.format_bold),
                          Icon(Icons.format_italic),
                          Icon(Icons.link),
                        ],
                      ),
                      Container(
                        margin: FxSpacing.fromLTRB(0, 16, 0, 8),
                        child: FxText.titleSmall("Filled", fontWeight: 700),
                      ),
                      ToggleButtons(
                        splashColor: theme.colorScheme.primary.withAlpha(48),
                        color: theme.colorScheme.onBackground,
                        fillColor: theme.colorScheme.primary.withAlpha(48),
                        selectedBorderColor:
                            theme.colorScheme.primary.withAlpha(48),
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        children: const <Widget>[
                          Icon(Icons.format_bold),
                          Icon(Icons.format_italic),
                          Icon(Icons.link),
                        ],
                      ),
                      Container(
                        margin: FxSpacing.fromLTRB(0, 16, 0, 8),
                        child: FxText.titleSmall("Bordered", fontWeight: 600),
                      ),
                      ToggleButtons(
                        splashColor: theme.colorScheme.primary.withAlpha(48),
                        color: theme.colorScheme.onBackground,
                        fillColor: theme.colorScheme.primary.withAlpha(48),
                        borderWidth: 1,
                        borderColor: theme.colorScheme.onBackground,
                        selectedBorderColor: theme.colorScheme.primary,
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        children: const <Widget>[
                          Icon(Icons.format_bold),
                          Icon(Icons.format_italic),
                          Icon(Icons.link),
                        ],
                      ),
                      Container(
                        margin: FxSpacing.fromLTRB(0, 16, 0, 8),
                        child: FxText.titleSmall("Curved", fontWeight: 600),
                      ),
                      ToggleButtons(
                        splashColor: theme.colorScheme.primary.withAlpha(48),
                        color: theme.colorScheme.onBackground,
                        fillColor: theme.colorScheme.primary.withAlpha(48),
                        borderWidth: 1,
                        borderColor: theme.colorScheme.onBackground,
                        selectedBorderColor: theme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        children: const <Widget>[
                          Icon(Icons.format_bold),
                          Icon(Icons.format_italic),
                          Icon(Icons.link),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
