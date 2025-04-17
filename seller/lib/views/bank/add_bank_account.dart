import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutx/styles/app_theme.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/bank/bank_details.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  int? _radioValue = 1;
  TextEditingController accountController = TextEditingController();
  TextEditingController confirmAccountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
            FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
        children: [
          titleRow(),
          FxSpacing.height(15),
          getTextField(
              "Account Number", Icons.numbers_outlined, accountController,
              keyboardType: TextInputType.number),
          FxSpacing.height(15),
          getTextField("Confirm Account Number", Icons.numbers_outlined,
              confirmAccountController,
              keyboardType: TextInputType.visiblePassword),
          FxSpacing.height(15),
          getTextField("Account Holder's Name", Icons.account_circle_outlined,
              nameController,
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
          // FxSpacing.height(15),
          // getTextField("Bank Name", FontAwesomeIcons.bank, bankNameController,
          //     keyboardType: TextInputType.text),
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
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              FxButton.medium(
                onPressed: () {
                  addBankAccount();
                },
                backgroundColor: Colors.green,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    FxSpacing.width(5),
                    const Text(
                      "Add",
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

  Future<void> addBankAccount() async {
    var accountNumber = accountController.text.toString();
    var confirmAccountNumber = confirmAccountController.text.toString();
    Spinners spn = Spinners(context: context);
    if (accountNumber != confirmAccountNumber) {

      CoolAlert.show(context: context, type: CoolAlertType.error, title: "Error", text: "Account number and confirm account number did not matched");

      return;
    }

    var name = nameController.text.toString();
    var ifsc = ifscController.text.toString();
    String accountType = (_radioValue == 1) ? "Savings" : "Current";

    if (accountNumber.isEmpty) {
      CoolAlert.show(context: context, type: CoolAlertType.error, title: "Insufficient Info", text: "Account number can not be blank");
      return;
    }

    if (name.isEmpty) {
      spn.showAlert(
          "Insufficient Info", "Account Holder's name can not be blank", CoolAlertType.error);
      return;
    }

    if (ifsc.isEmpty) {
      spn.showAlert("Insufficient Info", "IFSC Code can not be blank", CoolAlertType.error);
      return;
    }

    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module": "bank",
      "submodule": "add",
      "account_number": accountNumber,
      "holder_name": name,
      "ifsc": ifsc,
      "account_type": accountType,
    };

    spn.showSpinner();
    final res = await dbConnection.getData(postBody);
    spn.hideSpinner();
    if (res['status'] == 200) {
      spn.showAlert("Success", "Account has been added", CoolAlertType.success).whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BankDetails()));
      });
    } else {
      spn.showAlert("Error", res['error'], CoolAlertType.error);
    }
  }
}
