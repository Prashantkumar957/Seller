import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/spinners.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/views/product_manager/edit_product/step_four_screen.dart';
import 'package:seller/views/product_manager/add_product/variant_widget.dart';
import 'package:seller/views/product_manager/product_detail_screen.dart';

class StepThreeScreen extends StatefulWidget {
  final VariantData variantData;
  final Map<String, dynamic> formData;
  final Map<dynamic, dynamic> product;
  const StepThreeScreen({super.key, required this.formData, required this.variantData, required this.product});

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  // List to store VariantWidgetControllers
  final List<VariantWidgetController> _variantControllers = [];

  late StepThreeController controller;
  late ThemeData theme;
  late bool loadPreviousVariants;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(StepThreeController());
    theme = AppTheme.shoppingManagerTheme;
    // Initialize with one default VariantWidgetController
    loadPreviousVariants = (widget.product['item_type'].toString().toLowerCase() == widget.formData['item_type'].toString().toLowerCase());
    if (widget.product['variants'] is List) {
      for (var v in widget.product['variants']) {
        _addVariant(prefillData: v);
      }
    }

    if (_variantControllers.isEmpty) _addVariant();
  }

  void _addVariant({bool callSetState = true, Map<dynamic, dynamic> prefillData = const {}}) {
    // Create a new VariantWidgetController for the new VariantWidget
    print(prefillData);

    List<String> images = [];
    for (var im in prefillData['images']) {
      images.add(im['image_url']);
    }


    VariantWidgetController controller = VariantWidgetController(
      variantId: int.parse(prefillData['id'].toString()),
      selectedSize: (prefillData['size'].toString().isEmpty) ? null : prefillData['size'].toString(),
      selectedColor: HexColor.fromHex(prefillData['color'].toString()),
      ageController: (prefillData['age'].toString().isEmpty) ? null : TextEditingController(text: prefillData['age'].toString()),
      selectedFabric: (prefillData['fabric'].toString().isEmpty) ? null : prefillData['fabric'].toString(),
      selectedGender: (prefillData['gender'].toString().isEmpty) ? null : prefillData['gender'].toString(),
      styleController: (prefillData['style'].toString().isEmpty) ? null : TextEditingController(text: prefillData['style'].toString()),
      seriesController: (prefillData['series'].toString().isEmpty) ? null : TextEditingController(text: prefillData['series'].toString()),
      unitPerPack: prefillData['unit_per_pack'].toString().isEmpty ? null : TextEditingController(text: prefillData['unit_per_pack'].toString()),
      priceController: TextEditingController(text: prefillData['price'].toString()),
      mrpController: TextEditingController(text: prefillData['mrp'].toString()),
      assuredStockController: TextEditingController(text: prefillData['a_stock']),
      declaredStockController: TextEditingController(text: prefillData['s_stock']),
      imageLinks: images,
    );

    // Add a new VariantWidget with the controller
    if (callSetState) {
      setState(() {
      _variantControllers.add(controller);
    });
    }
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
            title: const Text("Edit Product"),
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

                              Spinners spn = Spinners(context: context);
                              spn.showSpinner();

                              int j = 0;
                              for (int i = 0; i < con.images.length; i++) {
                                if (con.images[i] == null  &&  con.imageLinks != null  &&  con.imageLinks!.length > j) {
                                  con.images[i] = await downloadFile(con.imageLinks![j]);
                                  j++;
                                }
                              }
                              spn.hideSpinner();

                              bool allNull = true;
                              for (var x in con.images) {
                                if (x != null) allNull = false;
                              }

                              if (con.imageLinks != null) {
                                for (var x in con.imageLinks!) {
                                  allNull = false;
                                }
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
                                product: widget.product,
                                formData: {
                                  ...widget.formData,
                                  "variants": _variantControllers
                                      .map(
                                        (controller) {
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
                                            "image_links": controller.imageLinks,
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

  Future<File> downloadFile(String url) async {
    try {
      // Send a GET request to download the file
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Write the file to the specified path
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String filename = url.split("/").last;
        String filePath = '$tempPath/$filename';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }
}

class StepThreeController extends FxController {
  @override
  String getTag() {
    return "Step 3 controller";
  }
}
