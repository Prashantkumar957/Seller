import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/database/database.dart';
import 'package:seller/database/data_getters.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/views/intro_slider_screen.dart';
import 'package:seller/views/login_signup/login_screen.dart';
import 'package:seller/views/login_signup/unverified_account_screen.dart';

import 'full_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String autoLoginStr = "Trying auto login...";
  bool showSlowInternetMsg = false;
  String slowInternet =
      "Your internet is too slow please wait or restart the app";

  @override
  void initState() {
    super.initState();
    selectScreen();
    updateTimer();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.shoppingManagerTheme;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: theme.colorScheme.primary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 100,
                color: Colors.white,
                image: AssetImage("assets/images/splash_screen.gif"),
              ),
              FxSpacing.height(20),
              const Text(
                appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // LoadingAnimationWidget.dotsTriangle(
              //     color: Colors.white, size: 40),
              // const SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Text(
              //     autoLoginStr,
              //     style: const TextStyle(
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // FxSpacing.height(10),
              // (showSlowInternetMsg)
              //     ? Container(
              //         alignment: Alignment.center,
              //         child: Text(
              //           slowInternet,
              //           style: const TextStyle(
              //             color: Colors.white,
              //           ),
              //         ),
              //       )
              //     : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  void selectScreen() async {
    var screenReplacement = Navigator.of(context, rootNavigator: true);
    Database dbConnection = Database();

    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

    final isVisitedBefore = await storage.read(key: 'isVisitedBefore');
    if (isVisitedBefore == null) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IntroSliderScreen()));
      }

      return;
    }

    String? accessToken;
    String? validator;

    try {
      accessToken = await storage.read(key: "access_token");
      validator = await storage.read(key: "validator");
    } catch (e) {
      validator = accessToken = null;
    }

    if (accessToken != null && validator != null) {
      Map<String, String> postData = {
        "auto_login": "true",
        "access_token": accessToken,
        "validator": validator,
      };

      final res = await dbConnection.getData(postData);

      if (res['status'] == 401 &&
          res.containsKey('account_status') &&
          res['account_status'].toString() != '1') {
        screenReplacement.pushReplacement(MaterialPageRoute(
            builder: (context) =>
                UnVerifiedAccount(res['account_status'].toString(), res['admin_email'].toString())));
        return;
      }

      var result = res['LOGIN_RESPONSE'];

      if (result != null && result['status'] == 200) {
        final token = result['long_term_access_token'];
        final validator = result['token_verifier'];

        await storage.write(key: "access_token", value: token);
        await storage.write(key: "validator", value: validator);
        await storage.write(
            key: "user_data", value: jsonEncode(result['full_data']));
        await storage.write(
            key: "user_products", value: jsonEncode(res['PRODUCTS']));
        await storage.write(key: "filters", value: jsonEncode(res['filters']));
        await DataGetters.loadEverything();

        screenReplacement.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ShoppingManagerFullApp(),
          ),
        );

        // screenReplacement.pushReplacement(
        //     MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        screenReplacement.pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } else {
      Database dbConnection = Database();
      Map<dynamic, dynamic> postData = {
        "get_session_token": "true",
      };

      final res = await dbConnection.getData(postData);

      screenReplacement.pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void updateTimer() {
    int counter = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      counter++;
      if (mounted && counter > 5) {
        setState(() {
          showSlowInternetMsg = true;
        });
      }
    });
  }
}
