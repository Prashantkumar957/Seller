import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/router/routes.dart';
import 'package:seller/views/product_manager/add_product/step_five_screen.dart';
import 'package:seller/views/product_manager/api/product_manager_api.dart';

class StepFourScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  const StepFourScreen({super.key, required this.formData});

  @override
  State<StepFourScreen> createState() => _StepFourScreenState();
}

class _StepFourScreenState extends State<StepFourScreen> {
  late final Database _db;
  late final ProductManagerApi _productManagerApi;

  late final List<String> packageTypes;
  late final List<String> dimensionUnits;
  late final List<String> weightUnits;
  late final List<String> donationTypes;

  bool isLoading = true;

  String? selectedPackageType;
  String? selectedDimensionUnit;
  String? selectedWeightUnit;

  // Controllers for form fields
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    packageTypes = [];
    dimensionUnits = [];
    weightUnits = [];
    donationTypes = [];
    print(widget.formData);
    _db = Database();
    _productManagerApi = ProductManagerApi(db: _db);
    _fetchData();
  }

  @override
  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  _fetchData() async {
    final result = await _productManagerApi.fetchPackages();
    result.fold(
      (l) {
        setState(() {
          isLoading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Error fetching package data. Please try again.",
        );
      },
      (data) {
        final packageUnit = data['data']['package_units'];
        setState(() {
          packageTypes.addAll(List<String>.from(packageUnit['package_type']));
          dimensionUnits.addAll(List<String>.from(packageUnit['length_unit']));
          weightUnits.addAll(List<String>.from(packageUnit['weight_unit']));
          donationTypes
              .addAll(List<String>.from(data['data']['donation_types']));
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stepHeading("Step 4"),
                    const Divider(height: 20, thickness: 1),
                    sectionHeading("Package Info"),
                    const SizedBox(height: 20),

                    // Package Type Dropdown
                    buildDropdownButton(
                      items: packageTypes,
                      label: "Select Package Type",
                      onChanged: (value) {
                        setState(() {
                          selectedPackageType = value;
                        });
                      },
                      value: selectedPackageType,
                    ),
                    const SizedBox(height: 20),

                    // Package Dimensions Section
                    sectionTitle("Package Dimensions"),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      "Length",
                      lengthController,
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      "Width",
                      widthController,
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      "Height",
                      heightController,
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    buildDropdownButton(
                      items: dimensionUnits,
                      label: "Unit",
                      onChanged: (value) {},
                      value: selectedDimensionUnit,
                    ),
                    const SizedBox(height: 20),

                    // Package Weight Section
                    sectionTitle("Package Weight"),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      "Weight",
                      weightController,
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    buildDropdownButton(
                      items: weightUnits,
                      label: "Unit",
                      onChanged: (value) {
                        // Handle weight unit selection
                      },
                      value: selectedWeightUnit,
                    ),
                    const Divider(height: 20),
                    const SizedBox(height: 20),

                    // Action Buttons
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
                            final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => StepFiveScreen(formData: {
                              ...widget.formData,
                              "package_type": selectedPackageType,
                              "package_length": lengthController.text,
                              "package_width": widthController.text,
                              "package_height": heightController.text,
                              "length_unit": selectedDimensionUnit,
                              "package_weight": weightController.text,
                              "weight_unit": selectedWeightUnit,
                              "donation_types": donationTypes,
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
            ),
    );
  }
}
