import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/state_management/controller_store.dart';
import 'package:flutx/styles/app_theme.dart';
import 'package:flutx/styles/text_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/controllers/login_signup/business_information_register_controller.dart';

class BusinessInformationRegisterScreen extends StatefulWidget {
  const BusinessInformationRegisterScreen({super.key});

  @override
  State<BusinessInformationRegisterScreen> createState() =>
      _BusinessInformationRegisterScreenState();
}

class _BusinessInformationRegisterScreenState
    extends State<BusinessInformationRegisterScreen> {
  late OutlineInputBorder outlineInputBorder;
  late BusinessInformationRegisterController controller;
  List<XFile> businessDocumentList = [], warehouseImagesList = [];

  @override
  void initState() {
    super.initState();
    controller =
        FxControllerStore.putOrFind(BusinessInformationRegisterController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "MORE INFO REQUIRED",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 15,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              const Text(
                "We need a bit more information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              gstField(),
              const SizedBox(
                height: 10,
              ),
              (businessDocumentList.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxSpacing.height(25),
                        FxText.titleMedium(
                          "Selected Registration Documents: ",
                          fontWeight: 600,
                        ),
                        FxSpacing.height(15),
                        SizedBox(
                          height: (125.0 *
                              (businessDocumentList.length / 3.0).ceil()),
                          child: GridView.builder(
                            itemCount: businessDocumentList.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 7,
                                    right: 6,
                                    child: Image(
                                      height: 120,
                                      width: 120,
                                      image: FileImage(
                                        File(
                                          businessDocumentList[index].path,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 3,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            showCancelBtn: true,
                                            cancelBtnText: "No",
                                            confirmBtnText: "Yes, Remove",
                                            onConfirmBtnTap: () {
                                              setState(() {
                                                businessDocumentList.remove(
                                                    businessDocumentList[
                                                        index]);
                                              });
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.black.withOpacity(0.3),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.9,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              _buildUploadBox(
                icon: Icons.upload_file,
                heading: "Business Registration Documents",
                subtitle:
                    "Upload photo of the registration slip of your business.",
                onTap: () {
                  selectBusinessDocuments();
                },
              ),
              (warehouseImagesList.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxSpacing.height(25),
                        FxText.titleMedium(
                          "Selected Shop Images: ",
                          fontWeight: 600,
                        ),
                        FxSpacing.height(15),
                        SizedBox(
                          height: (125.0 *
                              (warehouseImagesList.length / 3.0).ceil()),
                          child: GridView.builder(
                            itemCount: warehouseImagesList.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 7,
                                    right: 6,
                                    child: Image(
                                      height: 120,
                                      width: 120,
                                      image: FileImage(
                                        File(
                                          warehouseImagesList[index].path,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -2,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            showCancelBtn: true,
                                            cancelBtnText: "No",
                                            confirmBtnText: "Yes, Remove",
                                            onConfirmBtnTap: () {
                                              setState(() {
                                                warehouseImagesList.remove(
                                                    warehouseImagesList[index]);
                                              });
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.black.withOpacity(0.3),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.9,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              _buildUploadBox(
                icon: Icons.upload_file,
                heading: "Shop/Warehouse Images",
                subtitle: "Upload photo of your warehouse/shop.",
                onTap: () {
                  selectWarehouseImages();
                },
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                width: 500,
                height: 70,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save & Next",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                width: 500,
                height: 70,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required IconData icon,
    required String heading,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              heading,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget gstField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      decoration: InputDecoration(
        hintText: "GST Number (Optional)",
        hintStyle: FxTextStyle.bodyMedium(),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        prefixIcon: Icon(
          Icons.app_registration,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
      ),
      controller: controller.businessNameController,
      validator: controller.validateName,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: theme.colorScheme.primary,
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Future<void> selectBusinessDocuments() async {
    var x = ImagePicker();
    final pickedImages = await x.pickMultiImage();
    for (var im in pickedImages) {
      businessDocumentList.add(im);
    }
    setState(() {});
  }

  Future<void> selectWarehouseImages() async {
    var x = ImagePicker();
    final pickedImages = await x.pickMultiImage();
    for (var im in pickedImages) {
      warehouseImagesList.add(im);
    }
    setState(() {});
  }
}
