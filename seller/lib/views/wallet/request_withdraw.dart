import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutx/styles/app_theme.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';

class RequestWithdraw extends StatefulWidget {
  const RequestWithdraw({super.key});

  @override
  State<RequestWithdraw> createState() => _RequestWithdrawState();
}

class _RequestWithdrawState extends State<RequestWithdraw> {
  var amountController = TextEditingController();
  var descController = TextEditingController();

  int? _radioValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
            FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
        children: [
          titleRow(),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                FxSpacing.height(25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FxText.bodyLarge("Transfer to", fontWeight: 600),
                      Container(
                        margin: FxSpacing.left(8),
                        child: Radio(
                          value: 1,
                          activeColor: theme.colorScheme.primary,
                          groupValue: _radioValue,
                          onChanged: (int? value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                        ),
                      ),
                      FxText.titleSmall(
                        "E-Wallet",
                        color: theme.colorScheme.onBackground.withAlpha(240),
                        letterSpacing: 0.2,
                        fontWeight: 500,
                      ),
                      Container(
                        margin: FxSpacing.left(8),
                        child: Radio(
                          value: 2,
                          activeColor: theme.colorScheme.primary,
                          groupValue: _radioValue,
                          onChanged: (int? value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                        ),
                      ),
                      FxText.titleSmall(
                        "Bank Account",
                        color: theme.colorScheme.onBackground.withAlpha(240),
                        letterSpacing: 0.2,
                        fontWeight: 500,
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(5),
                getTextField("Amount", Icons.currency_rupee, amountController,
                    keyboardType: TextInputType.number),
                FxSpacing.height(25),
                getTextField(
                    "Description (Optional)", Icons.description, descController,
                    keyboardType: TextInputType.text),
                FxSpacing.height(65),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FxButton.medium(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.red,
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                          FxSpacing.width(5),
                          Text(
                            "Discard",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FxButton.medium(
                      onPressed: () {
                        submitRequest();
                      },
                      backgroundColor: Colors.green,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          FxSpacing.width(5),
                          Text(
                            "Request",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getTextField(
      String hintText, IconData icon, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int? maxLength}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: hintText,
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.border,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        prefixIcon: Icon(icon, size: 24),
      ),
      onChanged: (v) {},
    );
  }

  Widget titleRow() {
    return Row(
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
          "Withdraw Request",
          fontWeight: 600,
        ),
      ],
    );
  }

  Future<void> submitRequest() async {
    Database dbConnection = Database();
    Spinners spn = Spinners(context: context);
    var amount = amountController.text.toString();
    if (amount.isEmpty  ||  double.parse(amount) <= 0) {
      spn.showAlert("Error", "Enter valid amount", CoolAlertType.error);
      return;
    }

    var description = descController.text.toString();
    var transferTo = (_radioValue == 1) ? "ewallet" : "bank";

    Map<dynamic, dynamic> postBody = {
      "module": "payment",
      "submodule": "utils",
      "functions": "withdraw_request",
      "amount": amount,
      "description": description,
      "transfer_to": transferTo,
    };
    spn.showSpinner();
    final res = await dbConnection.getData(postBody);
    spn.hideSpinner();
    if (res['status'] == 200) {
      if (res['data']['withdraw_request']['status'] == 200) {
        spn.showAlert("Success", res['data']['withdraw_request']['success'], CoolAlertType.success);
      } else {
        spn.showAlert("Error", res['data']['withdraw_request']['error'], CoolAlertType.error);
      }
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }
  }
}
