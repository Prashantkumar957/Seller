import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';

import '../theme/constant.dart';

class SoftButtons extends StatefulWidget {
  final String title;
  final double width;
  final Color? backgroundColor, fontColor;
  final IconData? iconData, prefixIcon;
  final Function()? onPressed;


  const SoftButtons({this.title = "", this.width = 150, this.prefixIcon, this.iconData, this.onPressed, this.backgroundColor, this.fontColor, super.key});

  @override
  State<SoftButtons> createState() => _SoftButtonsState();
}

class _SoftButtonsState extends State<SoftButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: FxButton.block(
        padding: FxSpacing.y(27),
        onPressed: widget.onPressed,
        backgroundColor: (widget.backgroundColor == null) ? Constant.softColors.violet.color : widget.backgroundColor,
        elevation: 0,
        borderRadiusAll: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...(widget.prefixIcon != null) ? [
              Icon(
                widget.prefixIcon,
                size: 23,
                color: (widget.fontColor == null) ? Constant.softColors.violet.onColor : widget.fontColor,
              ),
              FxSpacing.width(5),
            ] : [],
            FxText.bodySmall(widget.title.toUpperCase(),
                fontWeight: 700,
                color: (widget.fontColor == null) ? Constant.softColors.violet.onColor : widget.fontColor,
                letterSpacing: 0.5),
            FxSpacing.width(8),
            Icon(
              (widget.iconData != null) ? widget.iconData : FeatherIcons.chevronRight,
              size: 18,
              color: (widget.fontColor == null) ? Constant.softColors.violet.onColor : widget.fontColor,
            )
          ],
        ),
      ),
    );
  }
}