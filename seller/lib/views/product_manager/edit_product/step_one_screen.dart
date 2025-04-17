import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/database/data_getters.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/views/membership/membership_screen.dart';
import 'package:seller/views/product_manager/api/items_api.dart';
import 'package:seller/views/product_manager/api/static_data.dart';
import 'package:seller/views/product_manager/edit_product/step_two_screen.dart';

class StepOneScreen extends StatefulWidget {
  final Map<dynamic, dynamic> product;
  final String initialValue;
  final List<Map<String, dynamic>> vendors;
  const StepOneScreen({
    super.key,
    required this.initialValue,
    required this.product,
    required this.vendors,
  });

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  late Database _db;
  late ItemsApi _itemsApi;

  // Vendor selection variables
  String? postingFor;

  // Category selection variables
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedChildCategory;

  bool isCategoriesLoading = false;
  bool isSubCategoriesLoading = false;
  bool isChildCategoriesLoading = false;

  List<String> categories = [];
  Map<String, List<String>> subCategories = {};
  Map<String, List<String>> childCategories = {};
  int? postLeft;

  @override
  void initState() {
    super.initState();
    _db = Database();
    _itemsApi = ItemsApi(db: _db);
    postingFor = widget.initialValue;
    selectedCategory = widget.product['cat_id'];
    selectedSubCategory = widget.product['sub_cat_id'];
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      isCategoriesLoading = true;
    });
    final result = await _itemsApi.fetchCategory(productsMarketplaceId);
    result.fold(
      (error) => CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Failed to fetch categories. Please try again.",
      ),
      (data) {
        setState(() {
          categories = (data['data']['category'] as List)
              .map((e) => e['category_title'] as String)
              .toList();
          StaticData.packageLengthUnit = (data['data']['package_units']['length_unit'] as List<dynamic>).map((e) => e.toString()).toList();
          StaticData.packageWeightUnit = (data['data']['package_units']['weight_unit'] as List<dynamic>).map((e) => e.toString()).toList();
          StaticData.packageType = (data['data']['package_units']['package_type'] as List<dynamic>).map((e) => e.toString()).toList();
          StaticData.fabrics = (data['data']['fabrics'] as List<dynamic>).map((e) => e.toString()).toList();
          postLeft = int.parse(data['data']['posts_left'].toString());
        });
      },
    );
    setState(() {
      isCategoriesLoading = false;
    });
  }

  Future<void> _fetchSubCategories(String category) async {
    setState(() {
      isSubCategoriesLoading = true;
    });
    final result =
        await _itemsApi.fetchSubCategory(productsMarketplaceId, category);
    result.fold(
      (error) => CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Failed to fetch sub-categories. Please try again.",
      ),
      (data) {
        setState(() {
          subCategories[category] = (data['data']['sub_category'] as List)
              .map((e) => e['category_title'].toString())
              .toList();
        });
      },
    );
    setState(() {
      isSubCategoriesLoading = false;
    });
  }

  Future<void> _fetchChildCategories(String subCategory) async {
    setState(() {
      isChildCategoriesLoading = true;
    });
    final result = await _itemsApi.fetchChildCategory(
        productsMarketplaceId, selectedCategory!, subCategory);
    result.fold(
      (error) => CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Failed to fetch child categories. Please try again.",
      ),
      (data) {
        setState(() {
          childCategories[subCategory] =
              (data['data']['child_category'] as List)
                  .map((e) => e['category_title'].toString())
                  .toList();
        });
      },
    );
    setState(() {
      isChildCategoriesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ... (DataGetters.showClientSection) ?
              [const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Posting this product for ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: "\"${postingFor ?? ""}\"",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildDropdownButton(
                value: postingFor,
                label: "Select Vendor",
                items: [
                  'Self',
                  ...widget.vendors.map((val) => val['name'] as String),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    postingFor = newValue;
                  });
                },
              ),] : [],

              const SizedBox(height: 20),
              stepHeading("Step 1"),
              FxSpacing.height(15),
              FxContainer(
                width: MediaQuery.of(context).size.width,
                color: (postLeft == null) ? null : (postLeft! == 0) ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                child: (postLeft != null  &&  postLeft! > 0) ? FxText.titleMedium("$postLeft posts left.", fontWeight: 600, color: Colors.green,) : (postLeft == null) ? FxText.titleMedium("Loading posts count...", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleMedium("You do not have any item posts left. Please upgrade your membership to post new items.", color: Colors.red, fontWeight: 600,),
                    FxSpacing.height(5),
                    FxContainer(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: Constant.softColors.violet.color,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MembershipScreen()));
                      },
                      child: Text("Buy Membership",style: TextStyle(color: Constant.softColors.violet.onColor),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              pageHeading("Select Category"),
              const SizedBox(height: 20),
              buildDropdownButton(
                items: categories,
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedSubCategory = null;
                    selectedChildCategory = null;
                    subCategories.clear();
                    childCategories.clear();
                  });
                  if (value != null) _fetchSubCategories(value);
                },
                label: "Select Category",
                isLoading: isCategoriesLoading,
              ),
              const SizedBox(height: 20),
              buildDropdownButton(
                label: "Select Sub-Category",
                value: selectedSubCategory,
                items: selectedCategory != null
                    ? (subCategories[selectedCategory!] ?? [])
                    : [],
                onChanged: selectedCategory != null
                    ? (value) {
                        setState(() {
                          selectedSubCategory = value;
                          selectedChildCategory = null;
                          childCategories.clear();
                        });
                        if (value != null) _fetchChildCategories(value);
                      }
                    : null,
                disabledHint: selectedCategory == null
                    ? const Text("Select a Category first")
                    : (selectedSubCategory != null) ? Text(selectedSubCategory!) : (subCategories.isEmpty) ? Text("No sub-category available") : Text("Select sub-category"),
                isLoading: isSubCategoriesLoading,
              ),
              const SizedBox(height: 20),
              buildDropdownButton(
                label: "Select Child-Category",
                value: selectedChildCategory,
                items: selectedSubCategory != null
                    ? (childCategories[selectedSubCategory!] ?? [])
                    : [],
                onChanged: selectedSubCategory != null
                    ? (value) {
                        setState(() {
                          selectedChildCategory = value;
                        });
                      }
                    : null,
                disabledHint: selectedSubCategory == null
                    ? const Text("Select sub-category first")
                    : (selectedChildCategory != null) ? Text(selectedChildCategory!) : (childCategories.isEmpty) ? Text("No child-category available") : Text("Select child-category"),
                isLoading: isChildCategoriesLoading,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: buildActionButton(
                  onPressed: () async {
                    if (postLeft == 0) {
                      await CoolAlert.show(context: context, type: CoolAlertType.warning, title: "Insufficient balance", text: "You do not have any postings left. Please upgrade your membership to post items, you can only save the items as draft but can not post.");
                    }

                    if (selectedCategory != null &&
                        selectedSubCategory != null) {
                      if (mounted) {
                        Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StepTwoScreen(
                            product: widget.product,
                            formData: {
                              'initial_value': widget.initialValue,
                              'vendors': widget.vendors,
                              if (postingFor != null && postingFor == 'Self')
                                'self': '1',
                              if (postingFor != null && postingFor != 'Self')
                                'posting_for': postingFor,
                              'category': selectedCategory!,
                              'sub_category': selectedSubCategory!,
                              'child_category': selectedChildCategory ?? '',
                            },
                          ),
                        ),
                      );
                      }


                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        text: "Please select a category and sub-category.",
                      );
                    }
                  },
                  label: "Next",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
