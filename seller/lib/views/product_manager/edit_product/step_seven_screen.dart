import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/form_checkbox.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/views/product_manager/edit_product/step_eight_screen.dart';

class StepSevenScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<dynamic, dynamic> product;
  const StepSevenScreen(
      {super.key, required this.formData, required this.product});

  @override
  State<StepSevenScreen> createState() => _StepSevenScreenState();
}

class _StepSevenScreenState extends State<StepSevenScreen> {
  late bool additionalDetails;

  final tncKey = GlobalKey<FlutterSummernoteState>();
  final faqKey = GlobalKey<FlutterSummernoteState>();
  final warrantyKey = GlobalKey<FlutterSummernoteState>();
  final packageIncludesKey = GlobalKey<FlutterSummernoteState>();

  @override
  void initState() {
    super.initState();
    additionalDetails = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stepHeading("Step 7"),
              const Divider(height: 20, thickness: 1),
              buildGeneralCheckbox(
                value: additionalDetails,
                text: "Additional Details",
                onChanged: (value) {
                  setState(() {
                    additionalDetails = value!;
                  });
                },
              ),
              const Divider(height: 20),
              if (additionalDetails) ...[
                buildSummernoteEditor(
                  controller: tncKey,
                  label: "Terms & Conditions",
                  defaultValue: widget.product['tnc'],
                ),
                const SizedBox(height: 10),
                buildSummernoteEditor(
                  controller: faqKey,
                  label: "Product FAQs",
                  defaultValue: widget.product['faqs'],
                ),
                const SizedBox(height: 10),
                buildSummernoteEditor(
                  controller: warrantyKey,
                  label: "Warranty Description",
                  defaultValue: widget.product['warranty_description'],
                ),
                const SizedBox(height: 10),
                buildSummernoteEditor(
                  controller: packageIncludesKey,
                  label: "Package Includes",
                  defaultValue: widget.product['package_includes'],
                ),
                const SizedBox(height: 10),
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
                      }),
                  const SizedBox(width: 10),
                  buildActionButton(
                    label: "Next",
                    onPressed: () async {
                      String tnc = await tncKey.currentState?.getText() ?? "",
                          faq = await faqKey.currentState?.getText() ?? "",
                          warrantyDescription =
                              await warrantyKey.currentState?.getText() ?? "",
                          packageIncludes = await packageIncludesKey
                                  .currentState
                                  ?.getText() ??
                              "";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StepEightScreen(
                            product: widget.product,
                            formData: {
                              ...widget.formData,
                              'is_additional_details':
                                  additionalDetails ? '1' : '0',
                              if (additionalDetails)
                                'terms_and_conditions': tnc,
                              if (additionalDetails) 'faqs': faq,
                              if (additionalDetails)
                                'warranty_description': warrantyDescription,
                              if (additionalDetails)
                                'package_includes': packageIncludes,
                            },
                          ),
                        ),
                      );
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
