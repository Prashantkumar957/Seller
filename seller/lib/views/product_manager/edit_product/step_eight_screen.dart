import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/general_functions.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/product_manager/api/product_manager_api.dart';
import 'package:http/http.dart' as http;


class StepEightScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<dynamic, dynamic> product;
  const StepEightScreen({super.key, required this.formData, required this.product});

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
                        : (widget.product['main_image'].toString().isNotEmpty) ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.product['main_image'].toString(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ) : const Column(
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

                      Spinners spn = Spinners(context: context);
                      spn.showSpinner();

                      productImage ??= await downloadFile(widget.product['main_image'].toString());
                      if (productCatalogue == null  &&  widget.product['catalogue'].toString().isNotEmpty) {
                        productCatalogue = await downloadFile(widget.product['catalogue'].toString());
                      }
                      if (sizeChart == null  &&  widget.product['size_chart'].toString().isNotEmpty) {
                        sizeChart = await downloadFile(widget.product['size_chart'].toString());
                      }

                      final db = Database();
                      final productManagerApi = ProductManagerApi(db: db);


                      final formData = {
                        ...widget.formData,
                        "product_image": productImage,
                        "product_catalogue": productCatalogue,
                        "size_chart": sizeChart,
                        "product_id": widget.product['id'],
                      };

                      // print("Request Send");
                      final res = await productManagerApi.updateProduct(formData);
                      // print("Request END");
                      spn.hideSpinner();

                      // print("Result: ");
                      // print(res);

                      res.fold(
                        (l) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Error",
                            text: l,
                          );
                        },
                        (r) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Updated successfully",
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
                    label: "Update Item",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
