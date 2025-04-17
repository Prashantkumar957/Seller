import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/views/login_signup/validate_otp_registeration_screen.dart';

import '../../views/full_app.dart';
import '../../views/login_signup/login_screen.dart';

class ValidateOtpController extends FxController {
  // GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool enable = false;

  @override
  void initState() {
    super.initState();
    save = false;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  @override
  String getTag() {
    return "validate_otp_controller";
  }
}
