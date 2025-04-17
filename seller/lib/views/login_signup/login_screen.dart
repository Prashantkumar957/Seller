import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/views/login_signup/login_via_otp_screen.dart';

import '../../controllers/login_signup/login_controller.dart';
import '../../theme/constant.dart';

class LoginScreen extends StatefulWidget {
  bool showAccountCreatedMsg;

  LoginScreen({Key? key, this.showAccountCreatedMsg = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ThemeData theme;
  late LoginController controller;
  late OutlineInputBorder outlineInputBorder;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(LoginController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );

    markVisited();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LoginController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: FxSpacing.nBottom(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (widget.showAccountCreatedMsg)
                      ? Column(
                          children: [
                            FxContainer.bordered(
                              margin: EdgeInsets.only(top: 50),
                              color: Colors.green.withAlpha(30),
                              borderColor: Colors.green,
                              child: Column(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                      size: 45,
                                    ),
                                  ),
                                  FxSpacing.height(15),
                                  const Text(
                                    "Your account has been created successfully.\nYou can login to your account with your email and password.",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FxSpacing.height(15),
                          ],
                        )
                      : const Text(""),
                  FxSpacing.height(25),
                  Image(
                    image: AssetImage(
                      "assets/background/login.webp",
                    ),
                    height: 200,
                  ),
                  FxSpacing.height(35),
                  title(),
                  FxSpacing.height(30),
                  loginForm(),
                  FxSpacing.height(10),
                  forgotPassword(),
                  FxSpacing.height(10),
                  loginBtn(),
                  FxSpacing.height(10),
                  socialLoginDivider(),
                  // FxSpacing.height(10),
                  // socialLoginBtn(),
                  // FxSpacing.height(5),
                  registerBtn()
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
      child: FxText.headlineSmall(
        "Sign in",
        fontWeight: 700,
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [emailField(), FxSpacing.height(20), passwordField()],
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
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      obscureText: controller.enable ? false : true,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: FxTextStyle.bodyMedium(),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        suffixIcon: InkWell(
            onTap: () {
              controller.toggle();
            },
            child: Icon(
              controller.enable
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            )),
        prefixIcon: Icon(
          FeatherIcons.lock,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(0),
      ),
      controller: controller.passwordController,
      validator: controller.validatePassword,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: theme.colorScheme.primary,
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: FxButton.text(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginViaOtpScreen()));
            },
            elevation: 0,
            padding: FxSpacing.right(0),
            borderRadiusAll: 4,
            child: FxText.bodySmall(
              "Login with OTP",
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: FxButton.text(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginViaOtpScreen()));
            },
            elevation: 0,
            padding: FxSpacing.right(0),
            borderRadiusAll: 4,
            child: FxText.bodySmall(
              "Forgot password ?",
            ),
          ),
        ),
      ],
    );
  }

  Widget loginBtn() {
    return Column(
      children: [
        SizedBox(
          width: 150,
          child: FxButton.block(
            padding: FxSpacing.y(17),
            onPressed: () {
              controller.login();
            },
            backgroundColor: Constant.softColors.violet.color,
            elevation: 0,
            borderRadiusAll: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxText.bodySmall("Sign In".toUpperCase(),
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
        ),
        // ElevatedButton(onPressed: () {
        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProduct()));
        // }, child: Text("dsk",),),
      ],
    );
  }

  Widget socialLoginDivider() {
    return const Row(
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
    );
  }

  Widget socialLoginBtn() {
    return FxButton(
      borderRadiusAll: 24,
      backgroundColor: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.facebook,
            color: Colors.blueAccent,
          ),
          SizedBox(
            width: 8,
          ),
          Image(
            height: 18,
            image: AssetImage("assets/icons/google.png"),
          ),
        ],
      ),
    );
  }

  Widget registerBtn() {
    return FxButton.text(
      onPressed: () {
        controller.goToRegisterScreen();
      },
      elevation: 0,
      child: FxText.bodySmall("Create Account",
          decoration: TextDecoration.underline),
    );
  }

  void markVisited() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    var st = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await st.write(key: 'isVisitedBefore', value: 'true');
  }
}
