import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutx/styles/app_theme.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:seller/models/bank_detail_tile.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';

import '../../theme/constant.dart';

class EditBankDetails extends StatefulWidget {
  final BankDetailTile bankDetail;
  EditBankDetails(this.bankDetail, {super.key});

  @override
  State<EditBankDetails> createState() => _EditBankDetailsState();
}

class _EditBankDetailsState extends State<EditBankDetails> {

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHoldersNameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  int? _radioValue = 1;

  @override
  void initState() {
    super.initState();
    accountNumberController.text = widget.bankDetail.accountNumber;
    accountHoldersNameController.text = widget.bankDetail.accountHolder;
    ifscController.text = widget.bankDetail.ifsc;
    _radioValue = (widget.bankDetail.allDetails['account_type'].toString().toLowerCase() == "savings") ? 1 : 2 ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
        FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
        children: [
          titleRow(),
          FxSpacing.height(15),
          getTextField("Account Number", Icons.numbers_outlined, accountNumberController,
              keyboardType: TextInputType.number),
          FxSpacing.height(15),
          getTextField("Account Holder's Name", Icons.account_circle_outlined, accountHoldersNameController,
              keyboardType: TextInputType.text),
          FxSpacing.height(15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FxText.bodyLarge("Account Type: ", fontWeight: 600),
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
                  "Savings",
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
                  "Current",
                  color: theme.colorScheme.onBackground.withAlpha(240),
                  letterSpacing: 0.2,
                  fontWeight: 500,
                ),
              ],
            ),
          ),
          FxSpacing.height(15),
          getTextField("IFSC Code", Icons.qr_code, ifscController,
              keyboardType: TextInputType.text),
          FxSpacing.height(55),
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
                    const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    FxSpacing.width(5),
                    const Text(
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
                  updateDetails(widget.bankDetail.allDetails['id'].toString());
                },
                backgroundColor: Colors.green,
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    FxSpacing.width(5),
                    const Text(
                      "Update",
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
              "Bank Details",
              fontWeight: 600,
            ),
          ],
        ),
        FxButton.small(
          backgroundColor: Constant.softColors.violet.color,
          onPressed: () {
            setAsDefault(widget.bankDetail.allDetails['id'].toString());
          },
          child: Row(
            children: [
              Icon(
                Icons.edit,
                size: 16,
                color: Constant.softColors.violet.onColor,
              ),
              FxSpacing.width(5),
              Text(
                "Set as Default",
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

  Future<void> updateDetails(String id) async {
    Spinners spn = Spinners(context: context);
    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module": "bank",
      "submodule" : "edit",
      "holder_name" : accountHoldersNameController.text.toString(),
      "account_number" : accountNumberController.text.toString(),
      "ifsc" : ifscController.text.toString(),
      "account_type" : _radioValue.toString(),
      "id" : id,
    };
    spn.showSpinner();
    final res = await dbConnection.getData(postBody);
    spn.hideSpinner();
    if (res['status'] == 200) {
      spn.showAlert("Success", res['success'], CoolAlertType.success);
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }

  }

  Future<void> setAsDefault(String id) async {
    Spinners spn = Spinners(context: context);
    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module": "bank",
      "submodule" : "change_default",
      "id" : id,
    };
    spn.showSpinner();
    final res = await dbConnection.getData(postBody);
    spn.hideSpinner();
    if (res['status'] == 200) {
      spn.showAlert("Success", res['success'], CoolAlertType.success);
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.success);
    }

  }

}