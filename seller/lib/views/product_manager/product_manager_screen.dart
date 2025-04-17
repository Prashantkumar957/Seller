import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/data_getters.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/product_card.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/views/product_manager/api/product_manager_api.dart';
import '../../app_constants.dart';
import '../../spinners.dart';
import './add_product/step_one_screen.dart' as add_product_step_one;
import './edit_product/step_one_screen.dart' as edit_product_step_one;

import 'api/permission_manager_api.dart';

class ProductManagerScreen extends StatefulWidget {
  const ProductManagerScreen({super.key});

  @override
  State<ProductManagerScreen> createState() => _ProductManagerScreenState();
}

class _ProductManagerScreenState extends State<ProductManagerScreen> {
  late final Database _db;
  List<Map<String, dynamic>> vendors = [];
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> products = [];
  late ThemeData theme;

  String searchQuery = '';
  String selectedFilter = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    _db = Database();
    _fetchVendors();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      isLoading = true;
    });


    final res = await ProductManagerApi(db: _db).getItems();
    res.fold(
      (l) {
        log(l);
        Fluttertoast.showToast(msg: l);
      },
      (r) {
        products = List<Map<String, dynamic>>.from(r['data']);
        filteredProducts = products;
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchVendors() async {
    final res = await PermissionManagerApi(db: _db).fetchVendors();
    res.fold(
      (l) {
        print("Error fetching vendors: $l");
        setState(() {
          isLoading = false;
        });
      },
      (r) {
        setState(() {
          vendors = r;
          isLoading = false;
        });
      },
    );
  }

  void _filterProducts(String filter) {
    setState(() {
      selectedFilter = filter;
      filteredProducts = products.where((product) {
        final matchesSearch = product['product_title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final matchesFilter = filter == 'All' || ProductCard.getStatus(product['status']) == filter;
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _filterProducts(selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Manager",
        ),
        actions: [
          InkWell(
            onTap: () async {
              _fetchItems();
              _fetchVendors();
              DataGetters.loadEverything();
              print(DataGetters.userData);
            },
            child: Text("Refresh"),
          ),
          FxSpacing.width(10),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Box
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: _updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search Products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTapOutside: (c) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                  ),
                ),
                // Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['All', 'Approved', 'Removed', 'Pending']
                          .map(
                            (filter) => Container(
                              margin: EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: selectedFilter == filter,
                                onSelected: (isSelected) => _filterProducts(filter),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Product List
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredProducts
                          .map(
                            (product) => ProductCard(
                              product: product,
                              onDelete: () async {
                                Spinners spn = Spinners(context: context);
                                Map<String, dynamic> postBody = {
                                  "module": "marketplace",
                                  "submodule": "delete_product",
                                  "marketplace_id": productsMarketplaceId,
                                  "product_id" : product['id'],
                                };

                                spn.showSpinner();
                                Database db = Database();
                                final res = await db.getData(postBody);
                                spn.hideSpinner();

                                if (res['status'] == 200) {
                                  if (context.mounted) {
                                    CoolAlert.show(context: context, type: CoolAlertType.success, title: "Item deleted", text: "Item has been deleted and won't be shown in marketplace but some of the details will remain in the database for 1 year to show them in the order history of users.").then((v) {
                                      _fetchItems();
                                    });
                                  }
                                } else {
                                  if (context.mounted) {
                                    CoolAlert.show(context: context, type: CoolAlertType.error, title: "Error", text: res['error']);
                                  }
                                }
                              },
                              onEdit: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => edit_product_step_one.StepOneScreen(initialValue: "Self", vendors: vendors, product: product,)));
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        overlayColor: Colors.black,
        backgroundColor: Constant.softColors.violet.onColor,
        overlayOpacity: 0.3,
        spacing: 5,
        spaceBetweenChildren: 5,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_shopping_cart, color: Constant.softColors.violet.onColor),
            backgroundColor: Constant.softColors.violet.color,
            label: 'Add Product',
            labelStyle: TextStyle(fontSize: 16, color: Constant.softColors.violet.onColor),
            onTap: () => _showSelectDialog(),
          ),
          SpeedDialChild(
            child: Icon(Icons.card_giftcard, color: Constant.softColors.violet.onColor),
            backgroundColor: Constant.softColors.violet.color,
            label: 'Add Coupon',
            labelStyle: TextStyle(fontSize: 16, color: Constant.softColors.violet.onColor),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.discount, color: Constant.softColors.violet.onColor),
            backgroundColor: Constant.softColors.violet.color,
            label: 'Add Discount',
            labelStyle: TextStyle(fontSize: 16, color: Constant.softColors.violet.onColor),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.price_change, color: Constant.softColors.violet.onColor),
            backgroundColor: Constant.softColors.violet.color,
            label: 'Add Margin Rate',
            labelStyle: TextStyle(fontSize: 16, color: Constant.softColors.violet.onColor),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  _showSelectDialog() async {

    if (DataGetters.showClientSection == false) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => add_product_step_one.StepOneScreen(initialValue: "Self", vendors: vendors,)));
      _fetchItems();
      return;
    }

    final res = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.help_outline,
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 15),
                  const Text("For whom do you want to add a product?"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop("self");
                        },
                        child: const Text("Self"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop("show_client");
                          _showClientSelectionDialog();
                        },
                        child: const Text("Client"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (res != null  &&  res == "self"  &&  mounted) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => add_product_step_one.StepOneScreen(initialValue: "Self", vendors: vendors,)));
      _fetchItems();
    }
  }

  _showClientSelectionDialog() async {
    final res = await showDialog(
      context: context,
      builder: (ctx) {
        String? selectedClient;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.help_outline,
                      size: 50,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                        "For which client do you want to add the product?"),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedClient,
                      items: [
                        const DropdownMenuItem<String>(
                          value: 'Self',
                          child: Text('Self'),
                        ),
                        ...vendors.map((Map<String, dynamic> client) {
                          return DropdownMenuItem<String>(
                            value: client['name'],
                            child: Text(
                                client['name'],
                            ),
                          );
                        })
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClient = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select Client',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSelectDialog();
                          },
                          child: const Text("Back"),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(80, 247, 247, 247),),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedClient != null) {
                              Navigator.of(context).pop(selectedClient as String);
                            }
                          },
                          child: const Text("Confirm"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (res != null  &&  mounted) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => add_product_step_one.StepOneScreen(initialValue: res, vendors: vendors,)));
      _fetchItems();
    }
  }
}
