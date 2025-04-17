import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

Widget AdditionalDetailsTile(String title, String description, IconData icon, ThemeData theme) {
  return Row(
    children: [
      FxContainer(
        padding: EdgeInsets.all(5),
        color: theme.colorScheme.primaryContainer,
        child: Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      FxSpacing.width(10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.titleMedium(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          FxText.titleMedium(
            description,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    ],
  );
}
