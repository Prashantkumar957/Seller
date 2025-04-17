import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/views/login_signup/login_screen.dart';

import '../../controllers/login_signup/validate_otp_controller.dart';

class ValidateOtpScreen extends StatefulWidget {
  final String email;
  const ValidateOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ValidateOtpScreenState createState() => _ValidateOtpScreenState();
}

class _ValidateOtpScreenState extends State<ValidateOtpScreen> {
  late ThemeData theme;
  late ValidateOtpController controller;
  late OutlineInputBorder outlineInputBorder;
  String otpResendTime = "";
  bool requestNewOtp = false;
  List<TextEditingController?>? otpController;
  String enteredOtp = "";

  @override
  void initState() {
    super.initState();
    startOtpTime();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(ValidateOtpController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ValidateOtpController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return Scaffold(
          body: Container(
            padding: FxSpacing.x(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                FxSpacing.height(50),
                const Text("Otp has been sent to your email: "),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FxSpacing.height(20),
                OtpTextField(
                  numberOfFields: 6,
                  keyboardType: TextInputType.number,
                  showFieldAsBox: true,
                  onSubmit: (val) {
                    enteredOtp = val;
                  },
                ),
                FxSpacing.height(20),
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FxButton.text(
                      onPressed: () {
                        if (requestNewOtp) {
                          createNewOtp();
                        }
                      },
                      child: FxText.bodySmall("Resend OTP $otpResendTime"),
                    ),
                  ),
                ),
                registerBtn(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget registerBtn() {
    return FxButton.block(
      padding: FxSpacing.y(12),
      onPressed: () {
        verifyOtp();
      },
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      borderRadiusAll: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FxText.bodySmall("Verify Otp".toUpperCase(),
              fontWeight: 700,
              color: theme.colorScheme.onPrimary,
              letterSpacing: 0.5),
          FxSpacing.width(8),
          Icon(
            FeatherIcons.chevronRight,
            size: 18,
            color: theme.colorScheme.onPrimary,
          )
        ],
      ),
    );
  }

  void startOtpTime() {
    int secElapsed = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      secElapsed++;
      if (secElapsed >= 5 * 60) {
        if (mounted) {
          setState(() {
            otpResendTime = "";
            requestNewOtp = true;
          });
        }
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            double m = 5 - (secElapsed / 60);
            int min = m.toInt();
            int sec = 60 - secElapsed % 60;
            otpResendTime = "in $min:${((sec < 10) ? "0$sec" : sec)}" ;
          });
        } else {
          timer.cancel();
        }
      }
    });
  }

  Future<void> createNewOtp() async {
    Spinners spn = Spinners(context: context);
    Database dbConnection = Database();

    Map<dynamic, dynamic> postBody = {
      "module" : "vendor",
      "submodule" : "registration",
      "function" : "resend_otp",
    };
    spn.showSpinner();
    final res = await dbConnection.getData(postBody);
    spn.hideSpinner();
    if (res['status'] == 200) {
      if (mounted) {
        setState(() {
          requestNewOtp = false;
        });
        startOtpTime();
      }
      spn.showAlert("OTP Resend", "OTP has been send to your email", CoolAlertType.success);
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }
  }

  Future<void> verifyOtp() async {
    Spinners spn = Spinners(context: context);
    if (enteredOtp.length != 6) {
      spn.showAlert("Invalid OTP", "Please enter otp", CoolAlertType.error);
      return;
    }

    for (int i = 0; i < 6; i++) {
      int x;
      try {
        x = int.parse(enteredOtp[i]);
      } catch (e) {
        spn.showAlert("Invalid OTP", "Please enter only numbers", CoolAlertType.error);
        return;
      }
    }
    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module" : "vendor",
      "submodule" : "registration",
      "function" : "verify_otp",
      "otp" : enteredOtp,
    };
    spn.showSpinner();
    var nv = Navigator.of(context);
    final res = await dbConnection.getData(postBody);
    spn.hideSpinner();
    if (res['status'] == 200) {
      nv.pop();
      nv.pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(showAccountCreatedMsg: true,)));
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }
  }
}
