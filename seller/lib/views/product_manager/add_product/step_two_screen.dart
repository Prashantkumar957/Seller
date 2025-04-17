import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/form_buttons.dart';
import 'package:seller/models/form_fields.dart';
import 'package:seller/models/headings.dart';
import 'package:seller/views/product_manager/add_product/step_three_screen.dart';
import 'package:seller/views/product_manager/add_product/variant_widget.dart';
import 'package:seller/views/product_manager/api/items_api.dart';

import '../../../theme/app_theme.dart';

class StepTwoScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  const StepTwoScreen({
    super.key,
    required this.formData,
  });

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  late final ItemsApi _itemsApi;
  late final Database _db;

  late final String selectedCategory;
  late final String selectedSubCategory;
  late final String selectedChildCategory;

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final List<String> _items = [];
  String? _selectedItem;
  List<dynamic> itemList = [];

  final productTitleController = TextEditingController();
  final brandNameController = TextEditingController();
  final skuController = TextEditingController();
  final countryOfOriginController = TextEditingController();
  final manufacturerNameController = TextEditingController();
  final productDescriptionController = TextEditingController();

  final GlobalKey<FlutterSummernoteState> productDescriptionKey =
      GlobalKey<FlutterSummernoteState>();

  final List<String> _availableTags = [];
  final List<String> _selectedTags = [];

  late StepTwoController controller;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    _db = Database();
    controller = FxControllerStore.putOrFind(StepTwoController());
    theme = AppTheme.shoppingManagerTheme;
    _itemsApi = ItemsApi(db: _db);
    selectedCategory = widget.formData['category'];
    selectedSubCategory = widget.formData['sub_category'];
    selectedChildCategory = widget.formData['child_category'];
    _fetchItems();
  }

  _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _itemsApi.fetchItems(
      productsMarketplaceId,
      selectedCategory,
      selectedSubCategory,
      selectedChildCategory,
    );

    result.fold(
      (error) {
        print("Error: $error");
        setState(() {
          _isLoading = false;
        });
      },
      (data) {
        setState(() {
          itemList = data['data']['items'];
          print(itemList);
          _items.addAll((data['data']['items'] as List).map((e) {
            return e['item_name'].toString();
          }).toList());
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<StepTwoController>(
      controller: controller,
      theme: theme,
      builder: (StepTwoController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add New Product"),
            /*
            actions: [
              InkWell(
                onTap: () async {
                  print("Fetching clip data...");
                  final Map<String, dynamic> clipData = await SystemChannels.platform.invokeMethod('Clipboard.getData',
                    'text/plain',);
                  print("Clip data");
                  print(clipData);
                  print("Text: " + clipData['text']);
                },
                child: Text("Click"),
              )
            ],
             */
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          stepHeading("Step 2"),
                          const Divider(thickness: 1, height: 24),
                          Wrap(
                            spacing: 8.0,
                            children: [
                              _buildTagWidget("Category: $selectedCategory"),
                              _buildTagWidget(
                                  "Sub-Category: $selectedSubCategory"),
                              if (selectedChildCategory.isNotEmpty)
                                _buildTagWidget(
                                    "Child-Category: $selectedChildCategory"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          pageHeading("Product Info"),
                          const SizedBox(height: 20),
                          _buildSearchField(),
                          const SizedBox(height: 24),
                          _buildTextField(
                            controller: productTitleController,
                            label: "Product Title",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Product Title must not be empty.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: brandNameController,
                            label: "Brand Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Brand Name is required.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: skuController,
                            label: "SKU",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "SKU must not be empty.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: countryOfOriginController,
                            label: "Country of Origin",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Country of Origin is required.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: manufacturerNameController,
                            label: "Manufacturer Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Manufacturer Name must not be empty.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildSelectableChips(),
                          const SizedBox(height: 16),
                          buildSummernoteEditor(
                            controller: productDescriptionKey,
                            label: "Product Description",
                          ),
                          // _buildMultilineTextField(
                          //   controller: productDescriptionController,
                          //   label: "Product Description",
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return "Product Description is required.";
                          //     }
                          //     if (value.length < 20) {
                          //       return "Product Description should be at least 20 characters.";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildActionButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                label: "Previous",
                              ),
                              buildActionButton(
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {

                                    setState(() {

                                    });
                                    String? description =
                                        await productDescriptionKey.currentState
                                            ?.getText();

                                    if (_selectedItem == null) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          title: "Item not selected.",
                                          text:
                                              "Please select item to move to the next step.");
                                      return;
                                    }
                                    int idx = -1;
                                    for (int i = 0; i < _items.length; i++) {
                                      String x = _items[i];
                                      if (x.toLowerCase() == _selectedItem) {
                                        idx = i;
                                        break;
                                      }
                                    }

                                    if (idx == -1) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          title: "Invalid Item.",
                                          text:
                                              "Please select a valid item from the given list.");
                                      return;
                                    }
                                    // int idx = _items.indexOf(_selectedItem!);
                                    // print(_selectedItem);
                                    // print(idx);
                                    VariantData varData =
                                        VariantData(data: itemList[idx]);
                                    print(_selectedTags.join(","));
                                    print(description);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StepThreeScreen(
                                          variantData: varData,
                                          formData: {
                                            ...widget.formData,
                                            'product_title':
                                                productTitleController.text
                                                    .toString(),
                                            'item_type': _selectedItem,
                                            'brand_name':
                                                brandNameController.text,
                                            'sku': skuController.text,
                                            'origin':
                                                countryOfOriginController.text,
                                            'manufacturer':
                                                manufacturerNameController.text,
                                            'tags': _selectedTags.join(","),
                                            'product_description': description,
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                label: "Next",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSelectableChips() {
    final TextEditingController tagInputController = TextEditingController();
    void addTag(String tag) {
      if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
        setState(() {
          _selectedTags.add(tag);
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tags",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        buildTextFormField(
          'Add a tag',
          tagInputController,
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addTag(tagInputController.text.trim());
              tagInputController.clear();
            },
          ),
          onSubmitted: (value) {
            addTag(value.trim());
            tagInputController.clear();
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedTags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () {
                setState(() {
                  _selectedTags.remove(tag);
                });
              },
              backgroundColor: Colors.blue.shade100,
              labelStyle: TextStyle(
                color: Colors.blue.shade800,
              ),
              deleteIcon: const Icon(
                Icons.close,
                size: 18,
              ),
              deleteIconColor: Colors.blue.shade800,
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return ChoiceChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: Colors.blue.shade100,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue.shade800 : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SearchTextField(
      items: _items,
      label: "Search Item",
      onSearch: (item) {
        setState(() {
          _selectedItem = item;
        });
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return buildTextFormField(
      label,
      controller,
      validator: validator,
    );
  }

  // Widget _buildMultilineTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   String? Function(String?)? validator,
  // }) {
  //   return buildTextFormField(
  //     label,
  //     controller,
  //     maxLines: 5,
  //     validator: validator,
  //     textInputType: TextInputType.multiline,
  //   );
  // }

  Widget _buildTagWidget(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
    );
  }
}

class StepTwoController extends FxController {
  @override
  String getTag() {
    return "Step 2 controller";
  }
}
