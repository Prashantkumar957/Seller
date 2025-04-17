import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Spinners {
  OverlayState? overlayState;
  BuildContext? currContext;

  OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.black54,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  });

  Spinners({required BuildContext context}) {
    currContext = context;
  }

  void showSpinner() {
    overlayState = Overlay.of(currContext!);
    overlayState?.insert(overlayEntry);
  }

  void hideSpinner() {
    overlayEntry.remove();
  }

  void customSpinner(OverlayEntry spinnerUI) {
    overlayEntry = spinnerUI;
  }

  Future<void> showAlert(String alertTitle, String alertBody, CoolAlertType type) async {
    CoolAlert.show(context: currContext!, type: type, title: alertTitle, text: alertBody);

    // return showAnimatedDialog<void>(
    //   context: currContext!,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    //     return ClassicGeneralDialogWidget(
    //       titleText: alertTitle,
    //       contentText: alertBody,
    //       positiveText: "OK",
    //       negativeText: "",
    //       onPositiveClick: () {
    //         Navigator.of(context).pop();
    //         Timer.periodic(Duration(seconds: 1), (timer) {
    //           timer.cancel();
    //           SystemChrome.setSystemUIOverlayStyle(
    //             SystemUiOverlayStyle(
    //               statusBarColor: Colors.transparent,
    //               systemNavigationBarColor: Colors.black87,
    //               statusBarIconBrightness: Brightness.dark,
    //             ),
    //           );
    //         });
    //       },
    //     );
    //   },
    //   animationType: DialogTransitionType.fadeScale,
    //   curve: Curves.fastOutSlowIn,
    //   duration: const Duration(seconds: 1),
    // );
  }
}
