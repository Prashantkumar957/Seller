import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';

import '../../views/login_signup/validate_otp_login_screen.dart';

class LoginViaOtpController extends FxController {
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
    // emailController = TextEditingController(text: 'vkg360.vikas@gmail.com');
    // passwordController = TextEditingController(text: '12345');
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

  void toggle() {
    enable = !enable;
    update();
  }

  @override
  String getTag() {
    return "login_via_otp_controller";
  }

  Future<void> sendOtp() async {
    Database db = Database();
    Spinners spn = Spinners(context: context);

    Map<dynamic, dynamic> postBody = {
      "login_via_otp": "true",
      "function": "send_otp",
      "email": emailController.text.toString(),
    };

    spn.showSpinner();
    final res = await db.getData(postBody);
    spn.hideSpinner();

    if (res['status'] == 200) {
      if (context.mounted) {
        spn
            .showAlert("Otp Send", "OTP has been send to your email.", CoolAlertType.success)
            .then((value) => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ValidateOtpLoginScreen(
                          email: emailController.text.toString())))
                });
      }
    } else {
      spn.showAlert("Error", res['error'].toString(), CoolAlertType.error);
    }
  }
}
