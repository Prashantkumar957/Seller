import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/bank_detail_tile.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/bank/add_bank_account.dart';
import 'package:seller/views/bank/edit_bank_details.dart';

import '../../app_constants.dart';
import '../../theme/constant.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  late List<BankDetailTile> mp;
  bool dataLoaded = false, refreshingData = true;

  @override
  void initState() {
    super.initState();
    renderBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (dataLoaded == true)
          ? ListView(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
              children: [
                titleRow(),
                (refreshingData == true)
                    ? Column(
                        children: [
                          SpinKitWaveSpinner(
                            color: Colors.deepPurpleAccent,
                            waveColor: Constant.softColors.violet.color,
                          ),
                          Center(child: Text("Refreshing data please wait...")),
                        ],
                      )
                    : Text(""),
                FxSpacing.height(20),
                ...mp.map((det) => getCard(det)).toList(),
              ],
            )
          : Center(
              child: Column(
                children: [
                  titleRow(),
                  FxSpacing.height(20),
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: SpinKitWaveSpinner(
                      color: Colors.deepPurpleAccent,
                      waveColor: Constant.softColors.violet.color,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> loadFromLocal() async {
    AndroidOptions androidOptions() =>
        AndroidOptions(encryptedSharedPreferences: true);
    var st = FlutterSecureStorage(aOptions: androidOptions());
    final data = await st.read(key: "bank_accounts");
    if (data != null) {
      var res = jsonDecode(data);
      List<BankDetailTile> temp = [];
      for (var row in res) {
        temp.add(BankDetailTile(
            row['account_number'].toString(),
            row['account_name'].toString(),
            row['bank_name'].toString(),
            row['ifsc'].toString(),
            (row['default'].toString() == "1") ? true : false,
            allDetails: row));
      }
      setState(() {
        mp = temp;
        dataLoaded = true;
      });
    }
  }

  Future<void> loadFromServer() async {
    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module": "bank",
      "submodule": "get_accounts",
    };

    Spinners spn = Spinners(context: context);
    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      AndroidOptions androidOptions() =>
          AndroidOptions(encryptedSharedPreferences: true);
      var st = FlutterSecureStorage(aOptions: androidOptions());
      // print(res['data']);
      List<BankDetailTile> temp = [];
      for (var row in res['data']) {
        temp.add(BankDetailTile(
            row['account_number'].toString(),
            row['account_name'].toString(),
            row['bank_name'].toString(),
            row['ifsc'].toString(),
            (row['default'].toString() == "1") ? true : false,
            iconUrl: (bankIcons.containsKey(row['bank_code'].toString()))
                ? bankIcons[row['bank_code']]
                : "",
            showDummyIcon:
                !(bankIcons.containsKey(row['bank_code'].toString())),
            allDetails: row));
      }

      setState(() {
        mp = temp;
        dataLoaded = true;
        refreshingData = false;
      });
      await st.write(key: "bank_accounts", value: jsonEncode(res['data']));
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }
  }

  void renderBankDetails() {
    loadFromLocal();
    loadFromServer();
  }

  Widget getCard(BankDetailTile data) {
    return FxContainer(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditBankDetails(data)));
      },
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: (data.showDummyIcon)
                    ? Icon(Icons.image_not_supported_outlined)
                    : Image(
                        image: AssetImage(data.iconUrl),
                      ),
              ),
              FxSpacing.width(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data.accountNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FxSpacing.width(5),
                      (data.isDefault == true)
                          ? FxContainer(
                              padding: EdgeInsets.all(4),
                              color: Constant.softColors.violet.color,
                              child: Text(
                                "Default",
                                style: TextStyle(
                                  color: Constant.softColors.violet.onColor,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        ),
                    child: Text(
                      data.accountHolder,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.chevron_right_outlined),
        ],
      ),
    );
  }

  Widget titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.chevron_left),
            ),
            FxSpacing.width(8),
            FxContainer(
              width: 10,
              height: 24,
              color: theme.colorScheme.primaryContainer,
              borderRadiusAll: 2,
            ),
            FxSpacing.width(8),
            FxText.titleMedium(
              "Bank Accounts",
              fontWeight: 600,
            ),
          ],
        ),
        FxButton.small(
          backgroundColor: Constant.softColors.violet.color,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBankAccount()));
          },
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: 16,
                color: Constant.softColors.violet.onColor,
              ),
              FxSpacing.width(5),
              Text(
                "Add Account",
                style: TextStyle(
                  fontSize: 12,
                  color: Constant.softColors.violet.onColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
