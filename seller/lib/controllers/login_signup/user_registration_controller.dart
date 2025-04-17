import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/login_signup/validate_otp_registeration_screen.dart';

import '../../views/login_signup/login_screen.dart';

class UserRegistrationController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  bool enable = false;

  @override
  void initState() {
    super.initState();
    save = false;
  }

  String? validateName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter  name";
    }
    return null;
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (!FxStringUtils.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validateMobile(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter mobile";
    }

    int n = int.parse(text);
    if (n <= 999999999  ||  n > 9999999999) {
      return "Please enter valid mobile number";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringUtils.validateStringRange(text, 6, 20)) {
      return "Password must be between 6 to 20";
    }
    return null;
  }

  String? validateConfirmPassword(String? text) {
    if (text != passwordController.text.toString())
      return "Password not matched";
    return null;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void goToLoginScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<void> register() async {
    var nv = Navigator.of(context);
    if (formKey.currentState!.validate()) {
      Spinners spn = Spinners(context: context);
      Database dbConnection = Database();
      Map<dynamic, dynamic> postData = {
        "module": "vendor",
        "submodule": "registration",
        "function": "register",
        "name": businessNameController.text.toString(),
        "email": emailController.text.toString(),
        "password": passwordController.text.toString(),
        "mobile": mobileController.text.toString(),
        "vendor_type": vendorType,
      };
      spn.showSpinner();
      final res = await dbConnection.getData(postData);
      spn.hideSpinner();
      if (res['status'] == 200) {
        nv.push(MaterialPageRoute(
            builder: (context) =>
                ValidateOtpScreen(email: emailController.text.toString())));
      } else {
        spn.showAlert("Error", res['error'], CoolAlertType.error);
      }
    }
  }

  @override
  String getTag() {
    return "register_controller";
  }
}
