import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/text_field/text_field.dart';

class CommissionUpdateModel extends StatefulWidget {
  final GestureTapCallback onTapRemove;
  final CommissionModel controllers;

  const CommissionUpdateModel({super.key, required this.onTapRemove, required this.controllers});
  @override
  State<CommissionUpdateModel> createState() => _CommissionUpdateModelState();
}


class CommissionModel {
  late TextEditingController minQuantityController,
      maxQuantityController,
      rateController;
  String? selectedCommissionType;
  int id;

  CommissionModel({String minQuantity = "", String maxQuantity = "", String rate = "", String selectedCommissionType = "", this.id = -1}) {
    minQuantityController = TextEditingController(text: minQuantity);
    maxQuantityController = TextEditingController(text: maxQuantity);
    rateController = TextEditingController(text: rate);
    if (selectedCommissionType != "") {
      this.selectedCommissionType = selectedCommissionType;
    }
  }
}

class _CommissionUpdateModelState extends State<CommissionUpdateModel> {
  final List<List<String>> options = [
    ["Percentage %", "%"],
    ["Flat", "flat"],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 9, left: 9, right: 9, bottom: 55),
      color: Colors.grey.withOpacity(0.07),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: widget.controllers.selectedCommissionType,
            hint: const Text("Select Commission Type"),
            items: options
                .map((option) => DropdownMenuItem(
                      value: option[1],
                      child: Text(option[0]),
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                widget.controllers.selectedCommissionType = value!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.4),
                  width: 1.0,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          FxSpacing.height(10),
          getTextField(
            labelText: "Minimum Quantity",
            icon: Icons.low_priority_outlined,
            controller: widget.controllers.minQuantityController,
          ),
          getTextField(
            labelText: "Maximum Quantity",
            icon: Icons.trending_up,
            controller: widget.controllers.maxQuantityController,
          ),
          getTextField(
            labelText: "Rate",
            icon: Icons.monetization_on_outlined,
            controller: widget.controllers.rateController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FxContainer(
                onTap: widget.onTapRemove,
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                color: Color.fromRGBO(246, 197, 197, 1.0),
                child: FxText.titleSmall(
                  "- Remove",
                  fontWeight: 600,
                  color: Color.fromRGBO(170, 0, 0, 1.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getTextField(
      {required String labelText,
      required IconData icon,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FxTextField(
        prefixIcon: Icon(
          icon,
        ),
        controller: controller,
        fillColor: Colors.white,
        labelText: labelText,
        filled: true, // Enable the field background
        keyboardType: TextInputType.number,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
