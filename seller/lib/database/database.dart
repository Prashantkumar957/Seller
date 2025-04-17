import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';

class Database {
  int retry = 0;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  Future<Map> getData(Map postBody) async {
    var result = {};

    // postBody['APP_ID'] = appId;

    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    final existingSessionId = await storage.read(key: "SESSION_ID");
    // if (existingSessionId != null) {
    //   postBody['SESSION_ID'] = existingSessionId;
    // }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: postBody,
        headers: <String, String>{
          'APP_ID' : appId.toString(),
          'SESSION_ID' : (existingSessionId != null) ? existingSessionId.toString() : '',
        },
      );

      var copy = response.body;
      print(copy);
      result = jsonDecode(copy);

      if (result.containsKey('RAZORPAY_KEY') && liveModeEnabled) {
        var razorpayKey = result['RAZORPAY_KEY'];
        await storage.write(key: "razorpay_key", value: razorpayKey.toString());
      } else {
        var razorpayKey = razorpayTestKey;
        await storage.write(key: "razorpay_key", value: razorpayKey.toString());
      }

      if (result.containsKey('admin_email')) {
        await storage.write(key: 'admin_email', value: result['admin_email']);
      }

      if (result['status'] == 200 && existingSessionId == null) {
        final x =
            await storage.write(key: "SESSION_ID", value: result['SESSION_ID']);
        final y = await storage.read(key: "SESSION_ID");
      } else if (result['status'] == 400 && result.containsKey("logged_out")) {
        if (retry == 0) {
          retry = 1;
          final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

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

            final res = await getData(postData);

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
              await storage.write(
                  key: "filters", value: jsonEncode(res['filters']));

              return await getData(postBody);
            }
          }
        }
      }
    } catch (e) {
      print(e);
      result = {
        "status": 300,
        "error": "Server not reachable ",
      };
    }

    return result;
  }
}
