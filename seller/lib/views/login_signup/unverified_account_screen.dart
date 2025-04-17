import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutx/styles/app_theme.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:seller/views/login_signup/login_screen.dart';

import '../../images.dart';
import '../../theme/constant.dart';
import '../intro_slider_screen.dart';

class UnVerifiedAccount extends StatefulWidget {
  final String accountStatus, adminEmail;
  const UnVerifiedAccount(this.accountStatus, this.adminEmail, {super.key});

  @override
  State<UnVerifiedAccount> createState() => _UnVerifiedAccountState();
}

class _UnVerifiedAccountState extends State<UnVerifiedAccount> {

  late String statusMsg;
  @override
  void initState() {
    super.initState();
    switch(widget.accountStatus) {
      case '0' :
        statusMsg = 'Your account is pending for approval.\nOnce approved you can access the app.';
        break;
      case '2' :
        statusMsg = "Your account has been suspended";
        break;
      default:
        statusMsg = "Your account is on hold";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: FxSpacing.fromLTRB(
              20, FxSpacing.safeAreaTop(context) + 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FxContainer(
                padding: FxSpacing.xy(48, 20),
                color: theme.colorScheme.primaryContainer,
                borderRadiusAll: 8,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image(
                  fit: BoxFit.fill,
                  height: 300,
                  image: AssetImage(Images.shoppingSplash),
                ),
              ),
              // FxSpacing.height(40),
              // FxText.displaySmall(
              //   'Find your next \nClothes here',
              //   fontWeight: 700,
              //   textAlign: TextAlign.center,
              // ),
              FxSpacing.height(20),
              FxText.bodyMedium(
                statusMsg,
                xMuted: true,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
              FxSpacing.height(40),
              FxContainer(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                color: Constant.softColors.violet.color,
                child: Text(
                  "Login via another account",
                  style: TextStyle(
                    color: Constant.softColors.violet.onColor,
                  ),
                ),
              ),
              FxSpacing.height(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    color: CupertinoColors.black,
                  ),
                  Text(
                    "OR",
                  ),
                  Divider(
                    color: CupertinoColors.black,
                  ),
                ],
              ),
              FxSpacing.height(10),
              FxContainer(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                onTap: () async {
                  final Email email = Email(
                    body: '',
                    subject: 'Account Activation',
                    recipients: [widget.adminEmail],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email);
                },
                color: Constant.softColors.violet.color,
                child: Text(
                  "Contact Admin",
                  style: TextStyle(
                    color: Constant.softColors.violet.onColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
