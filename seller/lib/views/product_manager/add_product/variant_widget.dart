import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/general_functions.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/views/product_manager/api/static_data.dart';

class VariantData {
  String variantNumber;
  bool showSize,
      showColor,
      showFabric,
      showImages,
      showPrice,
      showMrp,
      showDeclaredStock,
      showAssuredStock,
      showAge,
      showMeasurementUnit,
      showPackageType,
      showPackUnit,
      showSeries,
      showStyle,
      showGender;
  dynamic data;

  VariantData(
      {required this.data,
      this.variantNumber = "",
      this.showSize = false,
      this.showImages = true,
      this.showFabric = false,
      this.showColor = false,
      this.showAssuredStock = true,
      this.showDeclaredStock = true,
      this.showMrp = true,
      this.showPrice = true,
      this.showAge = false,
      this.showGender = false,
      this.showMeasurementUnit = false,
      this.showPackageType = false,
      this.showPackUnit = false,
      this.showSeries = false,
      this.showStyle = false}) {
    List<dynamic> variants = data['variants'];

    for (int i = 0; i < variants.length; i++) {
      variants[i] = variants[i].toString().toLowerCase();
    }

    if (variants.contains('size')) showSize = true;
    if (variants.contains('color')) showColor = true;
    if (variants.contains('fabric')) showFabric = true;

    if (variants.contains('age')) showAge = true;
    if (variants.contains('measurement unit')) showMeasurementUnit = true;
    if (variants.contains('package type')) showPackageType = true;

    if (variants.contains('series')) showSeries = true;
    if (variants.contains('style')) showStyle = true;
    if (variants.contains('pack unit')) showPackUnit = true;

    if (variants.contains('gender')) showGender = true;
    //
    // showSize = showColor = showFabric = showAge = showMeasurementUnit =
    //     showPackageType = showSeries =
    //         showStyle = showPackageType = showPackUnit = showGender = true;
  }
}

class VariantWidget extends StatefulWidget {
  final VariantData variantData;
  final VariantWidgetController controller;
  Map<dynamic, dynamic>? defaultValues;

  VariantWidget({
    super.key,
    required this.variantData,
    required this.controller,
    this.defaultValues,
  });

  @override
  State<VariantWidget> createState() => _VariantWidgetState();
}

class _VariantWidgetState extends State<VariantWidget> {
  final List<String> _sizes = [
    "XS",
    "S",
    "M",
    "L",
    "XL",
    "XXL",
    "XXXL",
    "XXXXL"
  ];

  Future<void> _pickImage(int index) async {
    final imageFile = await GeneralFunctions.pickImage();
    if (imageFile != null) {
      setState(() {
        widget.controller.images[index] = imageFile;
      });
    }
  }

  void _showColorPicker() async {
    Color selectedColor = widget.controller.selectedColor;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: sectionTitle("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: widget.controller.selectedColor,
              onColorChanged: (color) => selectedColor = color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.controller.selectedColor = selectedColor;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white),
              child: const Text("Select"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stepHeading("Variant ${widget.variantData.variantNumber}"),
              const SizedBox(height: 10),
              ...(widget.variantData.showSize)
                  ? [
                      buildDropdownButton(
                        label: "Size",
                        value: widget.controller.selectedSize,
                        items: _sizes,
                        onChanged: (value) => setState(
                            () => widget.controller.selectedSize = value),
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showGender)
                  ? [
                      const SizedBox(height: 10),
                      buildDropdownButton(
                        label: "Select Applicable Gender",
                        value: widget.controller.selectedGender,
                        items: [
                          "All",
                          "Kids",
                          "Unisex",
                          "Girls",
                          "Boys",
                          "Man",
                          "Woman",
                        ],
                        onChanged: (value) => setState(
                            () => widget.controller.selectedGender = value),
                      ),
                      const SizedBox(height: 10),
                    ]
                  : [],
              ...(widget.variantData.showColor)
                  ? [
                      FxSpacing.height(10),
                      Row(
                        children: [
                          FxText.titleMedium(
                            "Color: ",
                            fontWeight: 600,
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: _showColorPicker,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                                color: widget.controller.selectedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      FxSpacing.height(10),
                    ]
                  : [],
              ...(widget.variantData.showFabric)
                  ? [
                      FxSpacing.height(10),
                      buildDropdownButton(
                        label: "Fabric",
                        value: widget.controller.selectedFabric,
                        items: StaticData.fabrics,
                        onChanged: (value) => setState(
                            () => widget.controller.selectedFabric = value),
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showAge)
                  ? [
                      FxSpacing.height(10),
                      buildTextFormField(
                        "Age",
                        widget.controller.ageController,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showPackUnit)
                  ? [
                      FxSpacing.height(10),
                      buildTextFormField(
                        "Unit Per Package",
                        widget.controller.unitPerPack,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showPrice)
                  ? [
                      buildTextFormField(
                        "Price",
                        widget.controller.priceController,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showMrp)
                  ? [
                      buildTextFormField(
                        "MRP",
                        widget.controller.mrpController,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showDeclaredStock)
                  ? [
                      buildTextFormField(
                        "Declared Stock",
                        widget.controller.declaredStockController,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showAssuredStock)
                  ? [
                      buildTextFormField(
                        "Assured Stock",
                        widget.controller.assuredStockController,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10)
                    ]
                  : [],
              ...(widget.variantData.showImages)
                  ? [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeading("Upload Product Images"),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              6,
                              (index) {
                                return GestureDetector(
                                  onTap: () => _pickImage(index),
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: widget.controller.images[index] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              widget.controller.images[index]!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ((widget.controller.imageLinks !=
                                                    null &&
                                                widget.controller.imageLinks!
                                                        .length >
                                                    index))
                                            ? ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                              child: Image.network(
                                                  widget.controller
                                                      .imageLinks![index],
                                                  fit: BoxFit.cover,
                                                ),
                                            )
                                            : const Icon(
                                                Icons.add_a_photo,
                                                color: Colors.grey,
                                              ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ]
                  : [],
            ],
          ),
        ),
      ),
    );
  }
}

class VariantWidgetController {
  int variantId;
  String? selectedSize,
      selectedMeasurementUnit,
      selectedPackageType,
      selectedPackUnit,
      selectedLengthUnit,
      selectedWeightUnit,
      selectedGender;
  Color selectedColor;
  String? selectedFabric;
  TextEditingController priceController,
      ageController,
      seriesController,
      unitPerPack,
      styleController,
      packageWeightController,
      packageLengthController,
      packageWidthController,
      packageHeightController;
  TextEditingController mrpController;
  TextEditingController declaredStockController;
  TextEditingController assuredStockController;
  List<File?> images;
  List<String>? imageLinks; // URLs

  VariantWidgetController({
    this.selectedGender,
    this.imageLinks,
    this.selectedSize,
    this.variantId = -1,

    /// -1 means new variant
    this.selectedColor = Colors.black,
    this.selectedFabric,
    TextEditingController? priceController,
    TextEditingController? unitPerPack,
    TextEditingController? ageController,
    TextEditingController? packUnitController,
    TextEditingController? seriesController,
    TextEditingController? styleController,
    TextEditingController? mrpController,
    TextEditingController? declaredStockController,
    TextEditingController? assuredStockController,
    TextEditingController? packageLengthController,
    TextEditingController? packageWeightController,
    TextEditingController? packageWidthController,
    TextEditingController? packageHeightController,
    List<File?>? images,
  })  : priceController = priceController ?? TextEditingController(),
        mrpController = mrpController ?? TextEditingController(),
        ageController = ageController ?? TextEditingController(),
        unitPerPack = unitPerPack ?? TextEditingController(),
        packageWeightController =
            packageWeightController ?? TextEditingController(),
        packageHeightController =
            packageHeightController ?? TextEditingController(),
        packageLengthController =
            packageLengthController ?? TextEditingController(),
        packageWidthController =
            packageWidthController ?? TextEditingController(),
        styleController = styleController ?? TextEditingController(),
        seriesController = seriesController ?? TextEditingController(),
        declaredStockController =
            declaredStockController ?? TextEditingController(),
        assuredStockController =
            assuredStockController ?? TextEditingController(),
        images = images ?? List.filled(6, null);

  // Utility method to clear all fields if needed
  void clear() {
    selectedSize = null;
    selectedColor = Colors.black;
    selectedFabric = null;
    priceController.clear();
    mrpController.clear();
    declaredStockController.clear();
    assuredStockController.clear();
    seriesController.clear();
    styleController.clear();
    ageController.clear();
    images.fillRange(0, images.length, null);
  }
}
