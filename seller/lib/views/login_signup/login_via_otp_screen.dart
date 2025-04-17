import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/controllers/login_signup/login_via_otp_controller.dart';
import 'package:seller/theme/app_theme.dart';

import '../../theme/constant.dart';

class LoginViaOtpScreen extends StatefulWidget {
  LoginViaOtpScreen({Key? key}) : super(key: key);

  @override
  _LoginViaOtpScreenState createState() => _LoginViaOtpScreenState();
}

class _LoginViaOtpScreenState extends State<LoginViaOtpScreen> {
  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;
  late LoginViaOtpController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginViaOtpController();
    theme = AppTheme.shoppingManagerTheme;
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LoginViaOtpController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return Scaffold(
          body: Container(
            padding: FxSpacing.nBottom(20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FxSpacing.height(45),
                  Image(
                    image: AssetImage(
                      "assets/background/login_via_otp.webp",
                    ),
                  ),
                  FxSpacing.height(35),
                  title(),
                  FxSpacing.height(20),
                  loginForm(),
                  FxSpacing.height(10),
                  loginWithOtp(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget title() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Login with OTP",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      child: Column(
        children: [
          emailField(),
          FxSpacing.height(20),
        ],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      decoration: InputDecoration(
        hintText: "Email address",
        hintStyle: FxTextStyle.bodyMedium(),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        prefixIcon: Icon(
          FeatherIcons.mail,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(0),
      ),
      controller: controller.emailController,
      validator: controller.validateEmail,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: theme.colorScheme.primary,
    );
  }

  Widget loginWithOtp() {
    return SizedBox(
      width: 150,
      child: FxButton.block(
        padding: FxSpacing.y(17),
        onPressed: () {
          controller.sendOtp();
        },
        backgroundColor: Constant.softColors.violet.color,
        elevation: 0,
        borderRadiusAll: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.bodySmall("Send OTP".toUpperCase(),
                fontWeight: 700,
                color: Constant.softColors.violet.onColor,
                letterSpacing: 0.5),
            FxSpacing.width(8),
            Icon(
              FeatherIcons.chevronRight,
              size: 18,
              color: Constant.softColors.violet.onColor,
            )
          ],
        ),
      ),
    );
  }
}
