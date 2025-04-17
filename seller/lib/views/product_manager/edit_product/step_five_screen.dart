import 'package:flutter/material.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/form_checkbox.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/views/product_manager/edit_product/step_six_screen.dart';

class StepFiveScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<dynamic, dynamic> product;
  const StepFiveScreen({super.key, required this.formData, required this.product});

  @override
  State<StepFiveScreen> createState() => _StepFiveScreenState();
}

class _StepFiveScreenState extends State<StepFiveScreen> {
  String? selectedDonationType;
  late bool charityDiscount;
  late TextEditingController donationController;

  @override
  void initState() {
    super.initState();
    charityDiscount = (widget.product['charity_discount'] != null);
    if (widget.product['charity_discount'] != null) {
      donationController = TextEditingController(text: widget.product['charity_discount']['discount_percent'].toString());

      if (widget.product['charity_discount']['fixed_amount'].toString().isNotEmpty) {
        selectedDonationType = 'PER_SALE';
        donationController = TextEditingController(text: widget.product['charity_discount']['fixed_amount'].toString());
      } else if (widget.product['charity_discount']['discount_percent'].toString() != '100') {
        selectedDonationType = "%";
      } else {
        selectedDonationType = 'FREE';
      }
    } else {
      donationController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeading("Step 5"),
            const Divider(height: 20, thickness: 1),
            buildGeneralCheckbox(
              value: charityDiscount,
              text: "Additional Discount for Charity",
              onChanged: (value) {
                setState(() {
                  charityDiscount = value!;
                });
              },
            ),
            const Divider(height: 20),
            const SizedBox(height: 20),
            if (charityDiscount) ...[
              buildDropdownButton(
                items: widget.formData['donation_types'],
                label: "Donation Types",
                value: selectedDonationType,
                onChanged: (value) {
                  setState(() {
                    selectedDonationType = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (selectedDonationType != null &&
                  selectedDonationType != "FREE")
                buildTextFormField(
                  selectedDonationType == "PER_SALE"
                      ? "Donation per sale amount"
                      : "Donation Percentage",
                  donationController,
                  textInputType: TextInputType.number,
                ),
              const Divider(height: 20),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildActionButton(
                  label: "Previous",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                buildActionButton(
                  label: "Next",
                  onPressed: () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => StepSixScreen(
                      product: widget.product,
                      formData: {
                      ...widget.formData,
                      "is_additional_discount_for_charity":
                      charityDiscount ? "1" : "0",
                      if (charityDiscount)
                        "donation_type": selectedDonationType,
                      if (charityDiscount &&
                          selectedDonationType == 'PER_SALE')
                        "donation_per_sale_amount": donationController.text,
                      if (charityDiscount && selectedDonationType == '%')
                        "donation_percent": donationController.text,
                    },),),);
                    if (res != null  &&  res == "reload") {
                      Navigator.of(context).pop(res);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
