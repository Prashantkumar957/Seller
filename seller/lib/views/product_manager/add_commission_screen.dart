import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';

import '../../models/commission_update_model.dart';

class ChangeCommissionsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ChangeCommissionsScreen({super.key, required this.product});

  @override
  State<ChangeCommissionsScreen> createState() =>
      _ChangeCommissionsScreenState();
}

class _ChangeCommissionsScreenState extends State<ChangeCommissionsScreen> {
  late List<CommissionModel> commissionControllers;
  bool commissionsLoaded = false;

  @override
  void initState() {
    super.initState();
    commissionControllers = [];
    loadCommissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Commissions"),
        actions: [
          FxContainer(
            onTap: () {
              updateCommissions();
            },
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            color: Color.fromRGBO(237, 221, 255, 1.0,),
            child: FxText.titleSmall(
              "Save Changes",
              fontWeight: 600,
              color: Color.fromRGBO(
                82,
                0,
                170,
                1.0,
              ),
            ),
          ),
          FxSpacing.width(10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: (commissionsLoaded) ? [
              ...renderCommissions(),
              FxSpacing.height(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxContainer(
                    onTap: () {
                      updateCommissions();
                    },
                    margin: EdgeInsets.only(left: 9),
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    color: Color.fromRGBO(237, 221, 255, 1.0,),
                    child: FxText.titleSmall(
                      "Save Changes",
                      fontWeight: 600,
                      color: Color.fromRGBO(
                        82,
                        0,
                        170,
                        1.0,
                      ),
                    ),
                  ),
                  FxContainer(
                    onTap: () {
                      commissionControllers.add(CommissionModel());
                      setState(() {

                      });
                    },
                    margin: EdgeInsets.only(right: 9),
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    color: Color.fromRGBO(208, 246, 197, 1.0),
                    child: FxText.titleSmall(
                      "+ Add More Commission",
                      fontWeight: 600,
                      color: Color.fromRGBO(
                        25,
                        170,
                        0,
                        1.0,
                      ),
                    ),
                  ),
                ],
              ),
              FxSpacing.height(80),
            ] : [
              FxSpacing.height(40),
              Center(
                child: FxText.titleMedium("Loading commissions..."),
              ),
            ] ,
          ),
        ),
      ),
    );
  }

  List<CommissionUpdateModel> renderCommissions() {
    List<CommissionUpdateModel> ans = [];

    for (int i = 0; i < commissionControllers.length; i++) {
      ans.add(CommissionUpdateModel(onTapRemove: () {
        CoolAlert.show(context: context, type: CoolAlertType.confirm, title: "Confirmation", text: "Do you really want to remove this commission tab ?", confirmBtnText: "Yes", onConfirmBtnTap: () {
          commissionControllers.remove(commissionControllers[i]);
          setState(() {
          });
        }, showCancelBtn: true);
      }, controllers: commissionControllers[i],));
    }
    return ans;
  }

  Future<void> loadCommissions() async {
    print(widget.product['id'].toString());
    Database db = Database();
    Map<String, dynamic> postBody = {
      "marketplace_id" : "5",
      "module" : "marketplace",
      "product_id" : widget.product['id'].toString(),
      "submodule": "commission",
      "function" : "get_commission",
    };

    print("Send...");
    final res = await db.getData(postBody);
    print("Response: ");
    print(res);

    if (mounted  &&  res['status'] == 200) {

      for (var x in res['data']) {
        commissionControllers.add(CommissionModel(
          id: int.parse(x['product_id'].toString()),
          selectedCommissionType: (x['commission_type'].toString().toUpperCase()),
          minQuantity: x['min_order'].toString(),
          maxQuantity: x['max_order'].toString(),
          rate: x['commission_rate'].toString(),
        ));
      }

      if (commissionControllers.isEmpty) commissionControllers.add(CommissionModel());

      commissionsLoaded = true;
      setState(() {
      });
    }
  }

  Future<void> updateCommissions() async {
    Spinners spn = Spinners(context: context);
    List<String> newCommissions = [];

    for (int i = 0; i < commissionControllers.length; i++) {
      var c = commissionControllers[i];

      if (c.selectedCommissionType == null  ||  c.selectedCommissionType == "") {
        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Invalid Commission Type", text: "Please select commission type in commission number ${i + 1}");
        return;
      }

      if (c.minQuantityController.text == "") {
        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Invalid Min. Quantity", text: "Minimum quantity can not be null. Please fill a valid value in commission number ${i + 1}");
        return;
      }

      if (c.maxQuantityController.text == "") {
        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Invalid Max. Quantity", text: "Maximum quantity can not be null. Please fill a valid value in commission number ${i + 1}");
        return;
      }

      if (c.rateController.text == "") {
        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Invalid Rate", text: "Rate can not be null. Please fill a valid value in commission number ${i + 1}");
        return;
      }

      newCommissions.add(jsonEncode({
        "id" : c.id,
        "min_order" : c.minQuantityController.text,
        "max_order" : c.maxQuantityController.text,
        "commission_rate" : c.rateController.text,
        "commission_type" : c.selectedCommissionType,
      }));
    }

    Map<String, dynamic> postBody = {
      "marketplace_id" : "5",
      "module" : "marketplace",
      "product_id" : widget.product['id'].toString(),
      "submodule": "commission",
      "function" : "update_commission",
      "new_commissions" : jsonEncode(newCommissions),
    };

    Database db = Database();
    print("send.....");
    spn.showSpinner();
    final res = await db.getData(postBody);
    spn.hideSpinner();
    print("Response: ");
    print(res);
    if (res['status'] == 200) {
      if (mounted) {
        CoolAlert.show(context: context, type: CoolAlertType.success, title: "Commissions Updated");
      }
    } else {
      if (mounted) {
        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Something went wrong!!");
      }
    }
  }
}