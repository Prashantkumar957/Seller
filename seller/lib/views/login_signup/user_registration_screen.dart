import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/theme/app_theme.dart';

import '../../controllers/login_signup/user_registration_controller.dart';
import '../../theme/constant.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({Key? key}) : super(key: key);

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  late ThemeData theme;
  late UserRegistrationController controller;
  late OutlineInputBorder outlineInputBorder;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(UserRegistrationController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<UserRegistrationController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxSpacing.height(50),
                Center(
                  child: Container(
                    height: 250,
                    child: Image(
                      image: AssetImage("assets/background/signup.webp"),
                    ),
                  ),
                ),
                Container(
                  padding: FxSpacing.x(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FxSpacing.height(30),
                      title(),
                      FxSpacing.height(20),
                      registerForm(),
                      FxSpacing.height(20),
                      registerBtn(),
                      FxSpacing.height(20),
                      // socialLoginDivider(),
                      // FxSpacing.height(20),
                      // socialLoginBtn(),
                      FxSpacing.height(20),
                      loginBtn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget title() {
    return Align(
      alignment: Alignment.center,
      child: FxText.headlineMedium(
        "Sign Up",
        fontWeight: 700,
      ),
    );
  }

  Widget registerForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          nameField(),
          FxSpacing.height(20),
          emailField(),
          FxSpacing.height(20),
          mobileField(),
          FxSpacing.height(20),
          pinCodeField(),
          FxSpacing.height(20),
          passwordField(),
          FxSpacing.height(20),
          confirmPasswordField(),
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
        contentPadding: EdgeInsets.all(0),
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

  Widget mobileField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      decoration: InputDecoration(
        hintText: "Mobile Number",
        hintStyle: FxTextStyle.bodyMedium(),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        prefixIcon: Icon(
          Icons.call,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
      ),
      controller: controller.mobileController,
      validator: controller.validateMobile,
      keyboardType: TextInputType.phone,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: theme.colorScheme.primary,
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
  Widget pinCodeField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      decoration: InputDecoration(
        hintText: "Pin Code",
        hintStyle: FxTextStyle.bodyMedium(),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        prefixIcon: Icon(
          Icons.location_on_outlined,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
      ),
      controller: controller.pinCodeController,
      keyboardType: TextInputType.phone,
      maxLength: 6,
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
        contentPadding: EdgeInsets.all(0),
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

  Widget confirmPasswordField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      obscureText: controller.enable ? false : true,
      decoration: InputDecoration(
        hintText: "Confirm Password",
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
        contentPadding: EdgeInsets.all(0),
      ),
      controller: controller.confirmPasswordController,
      validator: controller.validateConfirmPassword,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: theme.colorScheme.primary,
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      decoration: InputDecoration(
        hintText: "Name",
        hintStyle: FxTextStyle.bodyMedium(),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        prefixIcon: Icon(
          FeatherIcons.user,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
      ),
      controller: controller.businessNameController,
      validator: controller.validateName,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: theme.colorScheme.primary,
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget registerBtn() {
    return SizedBox(
      width: 150,
      child: FxButton.block(
        padding: FxSpacing.y(17),
        onPressed: () {
          controller.register();
        },
        backgroundColor: Constant.softColors.violet.color,
        elevation: 0,
        borderRadiusAll: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.bodySmall("Sign Up".toUpperCase(),
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

  Widget loginBtn() {
    return FxButton.text(
      onPressed: () {
        controller.goToLoginScreen();
      },
      elevation: 0,
      child: FxText.bodySmall("I already have an account",
          decoration: TextDecoration.underline),
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
}
