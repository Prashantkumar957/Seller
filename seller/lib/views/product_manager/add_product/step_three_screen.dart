import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/models/product_card.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/views/product_manager/add_product/step_four_screen.dart';
import 'package:seller/views/product_manager/add_product/variant_widget.dart';
import 'package:seller/views/product_manager/product_detail_screen.dart';

class StepThreeScreen extends StatefulWidget {
  final VariantData variantData;
  final Map<String, dynamic> formData;
  const StepThreeScreen({super.key, required this.formData, required this.variantData});

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  // List to store VariantWidgetControllers
  final List<VariantWidgetController> _variantControllers = [];

  late StepThreeController controller;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(StepThreeController());
    theme = AppTheme.shoppingManagerTheme;
    // Initialize with one default VariantWidgetController
    _addVariant();
  }

  void _addVariant() {
    // Create a new VariantWidgetController for the new VariantWidget
    VariantWidgetController controller = VariantWidgetController();

    // Add a new VariantWidget with the controller
    setState(() {
      _variantControllers.add(controller);
    });
  }

  void _copyVariant(int index) {
    // Copy the existing VariantWidgetController at the specified index
    final VariantWidgetController currentController =
        _variantControllers[index];

    // Create a new instance of VariantWidgetController with the same parameters
    VariantWidgetController newController = VariantWidgetController(
      selectedSize: currentController.selectedSize,
      selectedColor: currentController.selectedColor,
      selectedFabric: currentController.selectedFabric,
      priceController:
          TextEditingController(text: currentController.priceController.text),
      mrpController:
          TextEditingController(text: currentController.mrpController.text),
      declaredStockController: TextEditingController(
          text: currentController.declaredStockController.text),
      assuredStockController: TextEditingController(
          text: currentController.assuredStockController.text),
      images: List.from(currentController.images), // Copy images if necessary
    );

    setState(() {
      _variantControllers.add(newController);
    });
  }

  void _removeVariant(int index) {
    // Remove the VariantWidgetController at the specified index
    setState(() {
      _variantControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    for (var controller in _variantControllers) {
      controller.priceController.dispose();
      controller.mrpController.dispose();
      controller.declaredStockController.dispose();
      controller.assuredStockController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder(
      controller: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Add New Product"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  stepHeading("Step 3"),
                  const Divider(height: 20),
                  pageHeading("Stocks and Variants"),
                  const SizedBox(height: 20),
                  // Render the list of VariantWidgets
                  ..._variantControllers.asMap().entries.map((entry) {
                    int index = entry.key;
                    VariantWidgetController controller = entry.value;

                    return Column(
                      key: ValueKey(index),
                      children: [
                        VariantWidget(
                          variantData: widget.variantData,
                          controller:
                              controller, // Pass the controller to the VariantWidget
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _copyVariant(index),
                              child: const Text("Copy"),
                            ),
                            // Only show the "Remove" button for variants after the first one
                            if (index > 0) ...[
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () => _removeVariant(index),
                                child: const Text("Remove"),
                              ),
                            ],
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: _addVariant,
                              child: const Text("Add New Variant"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                  const Divider(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: "Previous",
                      ),
                      const SizedBox(width: 10),
                      buildActionButton(
                        onPressed: () async {

                          String error = "";

                          for (var con in _variantControllers) {
                            var varData = widget.variantData;
                            if (varData.showPackUnit  &&  con.unitPerPack.text.toString() == "") {
                              error += "Pack per unit can not be empty.\n";
                            }

                            if (varData.showPrice  &&  con.priceController.text.isEmpty) {
                              error += "Price can not be empty.\n";
                            }

                            if (varData.showGender  &&  con.selectedGender == null) {
                              error += "Please select gender.\n";
                            }

                            if (varData.showAge  &&  con.ageController.text.isEmpty) {
                              error += "Age can not be empty.\n";
                            }

                            if (varData.showStyle  &&  con.styleController.text.isEmpty) {
                              error += "Style can not be empty.\n";
                            }

                            if (varData.showSeries  &&  con.seriesController.text.isEmpty) {
                              error += "Series can not be empty.\n";
                            }

                            if (varData.showFabric  &&  con.selectedFabric == null) {
                              error += "Please select a valid fabric.\n";
                            }

                            if (varData.showSize  &&  con.selectedSize == null) {
                              error += "Please select a valid size.\n";
                            }

                            if (varData.showMrp  &&  con.mrpController.text.isEmpty) {
                              error += "MRP can not be empty.\n";
                            }

                            if (varData.showDeclaredStock  &&  con.declaredStockController.text.isEmpty) {
                              error += "Declared Stock can not be empty.\n";
                            }

                            if (varData.showAssuredStock  &&  con.assuredStockController.text.isEmpty) {
                              error += "Assured Stock can not be empty.\n";
                            }

                            if (varData.showImages) {
                              bool allNull = true;
                              for (var x in con.images) {
                                if (x != null) allNull = false;
                              }

                              if (allNull) {
                                error += "Please upload at least one image for each variant.\n";
                              }
                            }
                          }

                          if (error.isNotEmpty) {
                            CoolAlert.show(context: context, type: CoolAlertType.error, title: "All fields are mandatory", text: error);
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StepFourScreen(
                                formData: {
                                  ...widget.formData,
                                  "variants": _variantControllers
                                      .map(
                                        (controller) {
                                          // print(controller.selectedColor.toHex());
                                          return {
                                            "size": controller.selectedSize,
                                            "color": controller.selectedColor.toHex(),
                                            "fabric": controller.selectedFabric,
                                            "age": controller.ageController.text.toString(),
                                            "gender": controller.selectedGender,
                                            "measurement_unit": controller.selectedMeasurementUnit,
                                            "style": controller.styleController.text.toString(),
                                            "series": controller.seriesController.text.toString(),
                                            "unit_per_pack": controller.unitPerPack.text.toString(),
                                            "price":
                                            controller.priceController.text.toString(),
                                            "mrp": controller.mrpController.text.toString(),
                                            "self_declared_stock": controller
                                                .declaredStockController.text.toString(),
                                            "assured_stock": controller
                                                .assuredStockController.text.toString(),
                                            "images": controller.images,
                                          };
                                        },
                                      )
                                      .toList(),
                                },
                              ),
                            ),
                          );
                        },
                        label: "Next",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StepThreeController extends FxController {
  @override
  String getTag() {
    return "Step 3 controller";
  }
}
