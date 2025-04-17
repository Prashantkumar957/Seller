import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutx/styles/app_theme.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../app_constants.dart';
import '../../database/database.dart';
import '../../models/membership_card.dart';
import '../../spinners.dart';
import '../../theme/constant.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  late OutlineInputBorder outlineInputBorder;
  String selectedMembershipID = "";
  bool membershipsLoaded = false;
  var searchTE = TextEditingController();
  final _razorpay = Razorpay();

  List<Membership> msl = [];

  @override
  void initState() {
    super.initState();
    outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide.none,
    );
    loadMemberships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                  ),
                ),
                FxSpacing.width(20),
                FxContainer(
                  width: 10,
                  height: 24,
                  color: theme.colorScheme.primaryContainer,
                  borderRadiusAll: 2,
                ),
                FxSpacing.width(12),
                FxText.titleLarge(
                  "Memberships",
                  fontWeight: 600,
                ),
                FxSpacing.width(20),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                child: (membershipsLoaded)
                    ? Row(
                        children: loadMembershipCards(),
                      )
                    : SpinKitWaveSpinner(
                        color: theme.colorScheme.primaryContainer,
                        waveColor: Constant.softColors.violet.onColor,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeSelectedMembership(String membershipCode) {
    if (mounted) {
      setState(() {
        selectedMembershipID = membershipCode;
      });
    }
  }

  void fillMembershipData(Map<dynamic, dynamic> res) {
    List<Membership> l = [];

    for (var row in res['data']) {
      List<String> availableFeatures = [],
          unavailableFeatures = [],
          mainFeatures = [];

      for (var r in row['details']) {
        r['posts'] = int.parse(r['posts'].toString());
        if (r['posts'] > 0) {
          availableFeatures.add("${r['posts']} posts in ${r['display_name']}");
        }
      }

      row['team_member_count'] = int.parse(row['team_member_count'].toString());

      if (row['team_member_count'] > 0) {
        availableFeatures
            .add("Add up to ${row['team_member_count']} in your team");
      }

      row['number_of_websites'] =
          int.parse(row['number_of_websites'].toString());
      if (row['number_of_websites'] > 0) {
        availableFeatures
            .add("Create ${row['number_of_websites']} website for free");
      }

      row['priority_support_website'] =
          int.parse(row['priority_support_website'].toString());
      if (row['priority_support_website'] > 0) {
        availableFeatures.add("Priority website support");
      }

      if (row.containsKey("discounts")) {
        for (var d in row['discounts']) {
          // if (d['marketplace_id'] != 27) continue;
          mainFeatures.add(
              "Get ${d['discount_amount']} ${(d['discount_type'] == '%') ? '%' : "$rupee flat"} discount on item of ${d['discount_group'] == 'CAT' ? 'category' : 'sub-category'} '${d['item']}' ");
        }
      }

      l.add(
        Membership(
          row['id'].toString(),
          row['title'],
          row['banner'],
          row['validity'].toString(),
          double.parse(row['price'].toString()),
          availableFeatures,
          unavailableFeatures,
          mainFeatures,
          allDetails: row,
          alreadyPurchased: (int.parse(row['is_purchased'].toString()) > 0),
        ),
      );
    }

    if (mounted) {
      setState(() {
        msl = l;
        membershipsLoaded = true;
      });
    }
  }

  Future<void> loadMemberships(
      {bool applySearch = false, String keyword = ""}) async {
    if (keyword == "") {
      loadFromLocal();
    }

    Spinners spn = Spinners(context: context);
    if (applySearch && keyword.length > 2) {
      spn.customSpinner(overlayEntry);
      spn.showSpinner();
    } else if (applySearch) {
      return;
    }

    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module": "membership",
      "get_products": "true",
      "keyword": keyword,
    };

    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      fillMembershipData(res);
      if (applySearch) {
        spn.hideSpinner();
      }
      if (!applySearch) {
        AndroidOptions androidOptions() =>
            const AndroidOptions(encryptedSharedPreferences: true);
        var storage = FlutterSecureStorage(aOptions: androidOptions());
        await storage.write(key: 'memberships', value: jsonEncode(res));
      }
    }
  }

  Future<void> loadFromLocal() async {
    AndroidOptions androidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    var storage = FlutterSecureStorage(aOptions: androidOptions());
    final res = await storage.read(key: 'memberships');
    if (res != null) {
      var data = jsonDecode(res);
      fillMembershipData(data);
    }
  }

  OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.black54,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LoadingAnimationWidget.dotsTriangle(
              color: Constant.softColors.blue.color,
              size: 40,
            ),
          ],
        ),
      ),
    );
  });

  Future<void> purchaseMembership(
      String membershipID, String title, String text) async {
    final res = await CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: title,
        text: text,
        confirmBtnText: "Yes",
        cancelBtnText: "No",
        onConfirmBtnTap: () {
          Navigator.of(context).pop("1");
        },
      closeOnConfirmBtnTap: false,
    );

    if (res != null  &&  res == "1") {
      await startMembershipPayment(membershipID, text);
    }
  }

  Future<void> startMembershipPayment(
      String membershipID, String itemTitle) async {
    AndroidOptions androidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    FlutterSecureStorage secureStorage =
        FlutterSecureStorage(aOptions: androidOptions());
    final razorpayKey = await secureStorage.read(key: "razorpay_key");

    if (razorpayKey == null) {
      if (mounted) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Payment Failed",
            text: "Payment gateway is not setup by admin.");
      }
      return;
    }

    Spinners spinners = Spinners(context: context);
    spinners.customSpinner(overlayEntry);
    spinners.showSpinner();

    AndroidOptions a() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    var s = FlutterSecureStorage(aOptions: a());
    final userData = await s.read(key: "user_data");
    String mobile = "", email = "";
    if (userData != null) {
      var res = jsonDecode(userData);
      mobile = res['mobile'];
      email = res['email'];
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    Database dbConnection = Database();
    Map<dynamic, dynamic> postData = {
      "module": "payment",
      "submodule": "make_payment",
      "marketplace": "membership",
      "membership_id": membershipID,
    };
    final res = await dbConnection.getData(postData);
    spinners.hideSpinner();
    if (res['status'] == 200) {
      if (res['payment_status'] == "PROGRESS") {
        var options = {
          'key': razorpayKey,
          'amount': res['data']['amount'],
          'name': siteName,
          'description': itemTitle,
          'prefill': {
            'contact': mobile,
            'email': email,
          }
        };

        _razorpay.open(options);
      } else if (res['payment_status'] == "DONE") {
        updateProducts(res);
        spinners
            .showAlert("Payment Success", "Membership has been purchased.",
                CoolAlertType.success)
            .then((value) => () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MembershipScreen()));
                });
      }
    } else {
      spinners.showAlert(
          "Error: ${res['status']}", res['error'], CoolAlertType.error);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Spinners spn = Spinners(context: context);
    spn.customSpinner(overlayEntry);
    spn.showSpinner();
    Map<dynamic, dynamic> postData = {
      "verify_membership_payment": "true",
      "razorpay_payment_id": (liveModeEnabled)
          ? response.paymentId.toString()
          : "", // to be used in live mode
      "razorpay_signature": (liveModeEnabled)
          ? response.signature.toString()
          : "", // to be used in live mode
      "marketplace": "membership",
      "module": "payment",
      "submodule": "make_payment",
    };

    Database dbConnection = Database();
    final res = await dbConnection.getData(postData);
    spn.hideSpinner();
    if (res['status'] == 200) {
      updateProducts(res);
      spn
          .showAlert("Payment Success", res['data'], CoolAlertType.success)
          .then((value) => () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MembershipScreen()));
              });
    } else {
      spn.showAlert(
          "Error: ${res['status']}", res['error'], CoolAlertType.error);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CoolAlert.show(context: context, type: CoolAlertType.error, title: "Payment Cancelled",);
    _razorpay.clear(); // Removes all listeners
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CoolAlert.show(context: context, type: CoolAlertType.error, title: "Payment Cancelled",);
    // Do something when an external wallet was selected
    _razorpay.clear();
  }

  List<Widget> loadMembershipCards() {
    List<Widget> ans = [];
    for (var row in msl) {
      ans.add(getMembershipCard(row, () {
        purchaseMembership(row.membershipID, "Do you really want to buy ?",
            "${row.title} for $rupee ${row.price} / ${row.duration} days");
      }));
    }
    return ans;
  }

  void updateProducts(dynamic res) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

    await storage.write(key: "premium_member", value: "yes");

    res['PRODUCTS'].forEach((item) {
      if (item['rating'] == "") item['rating'] = "0";
    });
    await storage.write(
        key: "user_products", value: jsonEncode(res['PRODUCTS']));
    await storage.write(key: "filters", value: jsonEncode(res['filters']));
  }
}
