import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/database/database.dart';
import 'package:seller/models/product.dart';
import 'package:seller/views/product_manager/product_detail_screen.dart';

class ProductDetailController extends FxController {
  TickerProvider ticker;

  ProductDetailController(this.ticker, this.product, {this.selectedVariant = 0}) {
    sizes = [];
  }
  bool showLoading = true, uiLoading = true;
  int colorSelected = 1;
  int selectedVariant;
  Product product;
  late AnimationController animationController, cartController;
  late Animation<Color?> colorAnimation;
  late Animation<double?> sizeAnimation, cartAnimation, paddingAnimation;

  bool isFav = false;
  bool addCart = false;

  TextEditingController pinCodeController = TextEditingController();

  late List<String> sizes;
  String selectedSize = '';

  List<Product>? products;
  // bool relatedProductsLoaded = false, checkingCustomPinCode = false;
  // int isDeliveryAvailableForCustomPinCode = -1, isDeliveryAvailableForDefaultPinCode = -2; // -3 address not available // -2 checking // -1 not checked // 0 not available  // 1 available
  // String customPinCode = "";

  @override
  void initState() {
    super.initState();
    save = false;
    // checkDeliveryForDefaultAddress();
    animationController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 500));

    cartController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 500));

    colorAnimation =
        ColorTween(begin: Colors.grey.shade400, end: Color(0xff1c8c8c))
            .animate(animationController);

    sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 24, end: 28), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 28, end: 24), weight: 50)
    ]).animate(animationController);

    cartAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 24, end: 28), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 28, end: 24), weight: 50)
    ]).animate(cartController);

    paddingAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 16, end: 14), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 14, end: 16), weight: 50)
    ]).animate(cartController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isFav = true;
        update();
      }
      if (status == AnimationStatus.dismissed) {
        isFav = false;
        update();
      }
    });

    cartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        addCart = true;
        update();
      }
      if (status == AnimationStatus.dismissed) {
        addCart = false;
        update();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    cartController.dispose();
    super.dispose();
  }

  void toggleFavorite() {
    product.favorite = !product.favorite;
    update();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void selectSize(String size) {
    selectedSize = size;
    update();
  }

  /*
  void fetchData(Map<String, dynamic> filters) async {
    Database dbConnection = Database();
    Map<String, dynamic> postBody = {
      "get_products": "true",
      "module": "marketplace",
      "marketplace_id": marketplaceId,
      "filters": jsonEncode(filters),
    };

    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      relatedProductsLoaded = true;
      products = Product.fromJsonToProduct(jsonEncode(res['data']));
      update();
    }
  }

   */

  void goToLoginScreen() {
    // DataGetters.targetScreen = FullApp(DataGetters.userName, currentIndex: 1,);
    //
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(),
    //   ),
    // );
  }

  Future<void> goToCheckout() async {
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(
    //     builder: (context) => CheckOutScreen(),
    //   ),
    // );
  }

  void goToSingleProduct(Product product) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product),
      ),
    );
  }

  /*

  void goToCart() {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => CartScreen(showBackButton: true,)));
  }


  Future<void> checkDeliveryForDefaultAddress() async {
    if (DataGetters.isCurrentAddressLoaded == false) {
      isDeliveryAvailableForDefaultPinCode = -3;
      return;
    }
    String pinCode = DataGetters.currentAddress!.pinCode;

    if (pinCode.length != 6) return;
    Database db = Database();
    Map<String, dynamic> postBody = {
      "module" : "logistics",
      "submodule" : "check_delivery",
      "pincode" : pinCode,
      "logistic_id" : product.allDetails['logistic_package_id'],
    };

    update();

    final res = await db.getData(postBody);
    if (res['status'] == 200) {
      if (res['data'].toString().toLowerCase() == "yes") {
        isDeliveryAvailableForDefaultPinCode = 1;
      } else {
        isDeliveryAvailableForDefaultPinCode = 0;
      }
    }


    update();
  }


  Future<void> checkDeliveryPinCode() async {
    String pinCode = pinCodeController.text;
    if (pinCode.length != 6) return;
    Database db = Database();
    Map<String, dynamic> postBody = {
      "module" : "logistics",
      "submodule" : "check_delivery",
      "pincode" : pinCode,
      "logistic_id" : product.allDetails['logistic_package_id'],
    };

    checkingCustomPinCode = true;
    update();

    final res = await db.getData(postBody);
    if (res['status'] == 200) {
      checkingCustomPinCode = false;
      customPinCode = pinCode;
      if (res['data'].toString().toLowerCase() == "yes") {
        isDeliveryAvailableForCustomPinCode = 1;
      } else {
        isDeliveryAvailableForCustomPinCode = 0;
      }
    }


    update();
  }
  */

  @override
  String getTag() {
    return "single_product_controller";
  }
}
