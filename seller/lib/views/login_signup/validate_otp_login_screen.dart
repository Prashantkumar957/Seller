import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/theme/constant.dart';

import '../../controllers/login_signup/validate_otp_controller.dart';
import '../../database/data_getters.dart';
import '../full_app.dart';

class ValidateOtpLoginScreen extends StatefulWidget {
  final String email;

  const ValidateOtpLoginScreen({Key? key, required this.email})
      : super(key: key);

  @override
  _ValidateOtpLoginScreenState createState() => _ValidateOtpLoginScreenState();
}

class _ValidateOtpLoginScreenState extends State<ValidateOtpLoginScreen> {
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
            padding: MediaQuery.of(context).padding,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FxSpacing.height(25),
                  Image(
                    image: AssetImage(
                      "assets/background/otp_verify.webp",
                    ),
                  ),
                  FxSpacing.height(10),
                  const Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
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
                      verifyOtp();
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
          ),
        );
      },
    );
  }

  Widget registerBtn() {
    return Container(
      width: 150,
      child: FxButton.block(
        padding: FxSpacing.y(17),
        onPressed: () {
          verifyOtp();
        },
        backgroundColor: Constant.softColors.violet.color,
        elevation: 0,
        borderRadiusAll: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.bodySmall("Verify Otp".toUpperCase(),
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
            otpResendTime = "in $min:${((sec < 10) ? "0$sec" : sec)}";
          });
        } else {
          timer.cancel();
        }
      }
    });
  }

  Future<void> createNewOtp() async {
    Database db = Database();
    Spinners spn = Spinners(context: context);

    Map<dynamic, dynamic> postBody = {
      "login_via_otp": "true",
      "function": "send_otp",
      "email": widget.email.toString(),
    };

    spn.showSpinner();
    final res = await db.getData(postBody);
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
      "login_via_otp": "true",
      "function": "verify_otp",
      "otp": enteredOtp,
    };
    spn.showSpinner();
    var nv = Navigator.of(context);
    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      var token = res['long_term_access_token'];
      var validator = res['token_verifier'];

      var razorpayKey = res['RAZORPAY_KEY'];

      await Future.wait([storage.write(key: "RAZORPAY_KEY", value: razorpayKey), storage.write(key: "access_token", value: token), storage.write(key: "validator", value: validator), storage.write(key: "user_data", value: jsonEncode(res['full_data'])), storage.write(key: "user_products", value: jsonEncode(res['PRODUCTS'])), storage.write(key: "filters", value: jsonEncode(res['filters'])), DataGetters.loadEverything()]);

      res['PRODUCTS'].forEach((item) {
        if (item['rating'] == "") item['rating'] = "0";
      });


      spn.hideSpinner();

      nv.pop();
      nv.pushReplacement(MaterialPageRoute(
          builder: (context) => const ShoppingManagerFullApp()));
    } else {
      spn.hideSpinner();
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }
  }
}
