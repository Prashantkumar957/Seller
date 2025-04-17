import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/login_signup/registration_type_selection_screen.dart';
import 'package:seller/views/login_signup/unverified_account_screen.dart';

import '../../database/data_getters.dart';
import '../../views/login_signup/forgot_password_screen.dart';
import '../../views/full_app.dart';
import '../../views/login_signup/user_registration_screen.dart';

class LoginController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool enable = false;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  void initState() {
    super.initState();
    save = false;
    fetchData();
  }

  fetchData() async {

  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (!FxStringUtils.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringUtils.validateStringRange(text, 5, 20)) {
      return "Password must be between 5 to 20";
    }
    return null;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void goToRegisterScreen() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const RegistrationTypeSelectionScreen(),
      ),
    );
  }

  void goToForgotPasswordScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text.toString();
      String password = passwordController.text.toString();

      Database dbConnection = Database();
      Map<String, String> postBody = {
        "login": "true",
        "email": email,
        "password": password,
        "vendor_type": vendorType,
      };

      var pushReplacement = Navigator.of(context, rootNavigator: true);

      Spinners spinners = Spinners(context: context);
      spinners.showSpinner();

      final res = await dbConnection.getData(postBody);
      var result = res['LOGIN_RESPONSE'];

      if (result['status'] == 401 &&
          result.containsKey('account_status') &&
          result['account_status'].toString() != '1') {
        spinners.hideSpinner();
        pushReplacement.push(MaterialPageRoute(
            builder: (context) =>
                UnVerifiedAccount(result['account_status'].toString(), (result.containsKey('admin_email') ? result['admin_email'].toString() : ""))));
        return;
      }

      if (result != null && result['status'] == 200) {
        final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
        var token = result['long_term_access_token'];
        var validator = result['token_verifier'];

        await Future.wait([storage.write(key: "access_token", value: token), storage.write(key: "validator", value: validator), storage.write(key: "user_data", value: jsonEncode(result['full_data'])), storage.write(key: "user_products", value: jsonEncode(res['PRODUCTS'])), storage.write(key: "filters", value: jsonEncode(res['filters'])), DataGetters.loadEverything()]);
        res['PRODUCTS'].forEach((item) {if (item['rating'] == "") item['rating'] = "0";});
        spinners.hideSpinner();

        pushReplacement.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ShoppingManagerFullApp(),
          ),
        );
      } else {
        spinners.hideSpinner();
        if (result != null) {
          spinners.showAlert("Something went wrong!", result['error'], CoolAlertType.error);
        } else {
          spinners.showAlert("Something went wrong !", res['error'], CoolAlertType.error);
        }
      }
    }
  }

  @override
  String getTag() {
    return "login_controller";
  }
}
