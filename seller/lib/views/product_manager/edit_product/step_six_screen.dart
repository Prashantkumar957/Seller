import 'package:flutter/material.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/form_checkbox.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/views/product_manager/edit_product/step_seven_screen.dart';

class StepSixScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<dynamic, dynamic> product;
  const StepSixScreen({
    super.key,
    required this.formData,
    required this.product,
  });

  @override
  State<StepSixScreen> createState() => _StepSixScreenState();
}

class _StepSixScreenState extends State<StepSixScreen> {
  late bool secondaryInfo;
  late bool cod;
  late bool inclusiveOfGst;
  late bool isExpirable;
  late bool isReturnable;

  late TextEditingController gstRateController;
  late TextEditingController expiryDateController;
  late TextEditingController returnDayController;

  @override
  void initState() {
    super.initState();
    cod = (widget.product['cod'].toString() == "1");
    inclusiveOfGst = (widget.product['gst'].toString() == ""  ||  widget.product['gst'].toString() == "0");
    isExpirable = widget.product['is_expirable'].toString().isNotEmpty  &&  int.parse(widget.product['is_expirable'].toString()) > 0;
    isReturnable = widget.product['returnable'].toString().isNotEmpty  &&  int.parse(widget.product['returnable'].toString()) > 0;
    print(widget.product['gst'].toString());
    gstRateController = TextEditingController(text: widget.product['gst'].toString());
    expiryDateController = TextEditingController(text: widget.product['is_expirable'].toString());
    returnDayController = TextEditingController(text: (int.parse(widget.product['returnable'].toString()) > 0 ? widget.product['returnable'].toString() : "0"));

    secondaryInfo = cod  ||  inclusiveOfGst  ||  isExpirable  ||  isReturnable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stepHeading("Step 6"),
              const Divider(height: 20),
              buildGeneralCheckbox(
                value: secondaryInfo,
                text: "Secondary Information",
                onChanged: (value) {
                  setState(() {
                    secondaryInfo = value!;
                  });
                },
              ),
              if (secondaryInfo) ...[
                const Divider(height: 20),
                const SizedBox(height: 20),
                buildGeneralCheckbox(
                    value: cod,
                    text: "Cash on Delivery Available?",
                    onChanged: (value) {
                      setState(() {
                        cod = value!;
                      });
                    }),
                const SizedBox(height: 10),
                buildGeneralCheckbox(
                    value: inclusiveOfGst,
                    text: "Price Inclusive of GST?",
                    onChanged: (value) {
                      setState(() {
                        inclusiveOfGst = value!;
                      });
                    }),
                const SizedBox(height: 10),
                if (!inclusiveOfGst) ...[
                  buildTextFormField(
                    "GST Rate",
                    gstRateController,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                ],
                buildGeneralCheckbox(
                    value: isExpirable,
                    text: "Is Product Expirable?",
                    onChanged: (value) {
                      setState(() {
                        isExpirable = value!;
                      });
                    }),
                const SizedBox(height: 10),
                if (isExpirable) ...[
                  buildTextFormField(
                    "Expiry Date (in Months)",
                    expiryDateController,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                ],
                buildGeneralCheckbox(
                    value: isReturnable,
                    text: "Is this product returnable?",
                    onChanged: (value) {
                      setState(() {
                        isReturnable = value!;
                      });
                    }),
                const SizedBox(height: 20),
                if (isReturnable) ...[
                  buildTextFormField(
                    "Max Return Days",
                    returnDayController,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                ],
              ],
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildActionButton(
                      label: "Previous",
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  buildActionButton(
                    label: "Next",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StepSevenScreen(
                        product: widget.product,
                        formData: {
                        ...widget.formData,
                        'secondary_information': secondaryInfo ? '1' : '0',
                        if (secondaryInfo) 'cod_available': cod ? '1' : '0',
                        if (secondaryInfo)
                          'gst_inclusive': inclusiveOfGst ? '1' : '0',
                        if (secondaryInfo && inclusiveOfGst)
                          'gst_rate': gstRateController.text,
                        if (secondaryInfo)
                          'is_product_expirable': isExpirable ? '1' : '0',
                        if (secondaryInfo && isExpirable)
                          'expiry_date': expiryDateController.text,
                        if (secondaryInfo)
                          'is_returnable': isReturnable ? '1' : '0',
                        if (secondaryInfo && isReturnable)
                          'return_duration': returnDayController.text,
                      },),),);

                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
