import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/general_functions.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/product_manager/api/product_manager_api.dart';
import 'package:seller/views/product_manager/product_manager_screen.dart';


class StepEightScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  const StepEightScreen({super.key, required this.formData});

  @override
  State<StepEightScreen> createState() => _StepEightScreenState();
}

class _StepEightScreenState extends State<StepEightScreen> {
  File? productImage;
  File? productCatalogue;
  File? sizeChart;

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
              stepHeading("Step 8"),
              const Divider(height: 20, thickness: 1),
              sectionHeading("Product Image"),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final image = await GeneralFunctions.pickImage();
                  if (image != null) {
                    setState(() {
                      productImage = image;
                    });
                  }
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: productImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              productImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Upload Product Image"),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              sectionHeading("Product Catalogue"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final file = await GeneralFunctions.pickFile();
                  if (file != null) {
                    setState(() {
                      productCatalogue = file;
                    });
                  }
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: productCatalogue != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.file_present,
                                  size: 40, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  productCatalogue!.path.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_present,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Upload Product Catalogue"),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              sectionHeading("Size Chart"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final file = await GeneralFunctions.pickFile();
                  if (file != null) {
                    setState(() {
                      sizeChart = file;
                    });
                  }
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: sizeChart != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.insert_drive_file,
                                  size: 40, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  sizeChart!.path.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_drive_file,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Upload Size Chart"),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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

                      if (productImage == null) {
                        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Product image not selected.", text: "Product image is mandatory.");
                        return;
                      }

                      final db = Database();
                      final productManagerApi = ProductManagerApi(db: db);

                      final formData = {
                        ...widget.formData,
                        "product_image": productImage,
                        "product_catalogue": productCatalogue,
                        "size_chart": sizeChart,
                      };

                      Spinners spn = Spinners(context: context);
                      spn.showSpinner();
                      final res = await productManagerApi.postProduct(formData);
                      spn.hideSpinner();

                      // print("Result: ");
                      // print(res);

                      res.fold(
                        (l) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Error $l",
                          );
                        },
                        (r) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Posted successfully",
                          ).then((v) {
                            int count = 0;
                            Navigator.of(context).popUntil((route) {
                              count++;
                              return count == 9;
                            });
                          });
                        },
                      );
                    },
                    label: "Post Item",
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
