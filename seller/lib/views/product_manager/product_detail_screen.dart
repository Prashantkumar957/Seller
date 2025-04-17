import 'package:seller/app_constants.dart';
import 'package:seller/controllers/product_manager/product_detail_controller.dart';
import 'package:seller/models/additional_details_tile.dart';
import 'package:seller/models/product.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/widgets/material/carousel/animated_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/extensions/extensions.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int variantId;
  const ProductDetailScreen(
    this.product, {
    Key? key,
    this.variantId = 0,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late ThemeData theme;
  List<String> productImageList = [];
  late ProductDetailController controller;
  double productPrice = 0, discount = 0;
  bool disableCartButton = false;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingTheme;
    controller = FxControllerStore.put(ProductDetailController(
        this, widget.product,
        selectedVariant: widget.variantId));

    for (var row in widget.product.allDetails['all_images']) {
      productImageList.add(row['image_url']);
    }

    if (widget.product
                .allDetails['variants'][controller.selectedVariant]['a_stock']
                .toString()
                .toInt() +
            widget.product
                .allDetails['variants'][controller.selectedVariant]['s_stock']
                .toString()
                .toInt() <
        1) {
      disableCartButton = true;
    }

    Map<String, bool> sizeTaken = {};
    for (var row in widget.product.allDetails['variants']) {
      if (row['size'] != "") {
        if (!sizeTaken.containsKey(row['size'])) {
          controller.sizes.add(row['size']);
          sizeTaken[row['size']] = true;
        }
      }
    }

    productPrice = double.parse(controller
        .product.allDetails['variants'][controller.selectedVariant]['price']
        .toString());

    if (controller.product.allDetails['discount_type'] == '%') {
      discount = double.parse(
              controller.product.allDetails['discount_amount'].toString()) *
          productPrice /
          100;
    } else {
      discount = double.parse(
          controller.product.allDetails['discount_amount'].toString());
    }
  }

  /*
  Widget _buildProductList() {
    if (controller.relatedProductsLoaded == false) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: LoadingEffect.getSearchLoadingScreen(
          context,
          AppTheme.theme,
          AppTheme.theme.colorScheme,
          itemCount: 1,
        ),
      );
    }

    if (controller.products!.isEmpty) {
      return Center(
        child: FxText.bodyMedium(
          "No related item found",
          fontWeight: 600,
        ),
      );
    }

    List<Widget> list = [];

    list.add(FxSpacing.width(20));

    for (Product product in controller.products!) {
      if (controller.product == product) continue;
      list.add(FxContainer(
        onTap: () {
          controller.goToSingleProduct(product);
        },
        borderRadiusAll: 8,
        paddingAll: 8,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxContainer(
              paddingAll: 0,
              borderRadiusAll: 4,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: [
                  SizedBox(
                    height: 140,
                    width: double.maxFinite,
                    child: Image(
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned(
                  //   right: 8,
                  //   top: 8,
                  //   child: InkWell(
                  //     onTap: () async {
                  //       setState(() {
                  //         product.changingFavoriteStatus = true;
                  //       });
                  //
                  //       final res = await CartProcessor.addToWishlist(
                  //         product.allDetails['id'],
                  //         product.allDetails['variants'][0]['id'],
                  //         product,
                  //       );
                  //
                  //       if (res == -2) {
                  //         if (mounted) {
                  //           await CoolAlert.show(
                  //             context: context,
                  //             type: CoolAlertType.info,
                  //             title: "Login",
                  //             text:
                  //                 "Please login first to add items to your wishlist.",
                  //             confirmBtnText: "OK",
                  //             onConfirmBtnTap: () {},
                  //           );
                  //
                  //           controller.goToLoginScreen();
                  //         }
                  //       }
                  //
                  //       setState(() {
                  //         if (res == -1) {
                  //           product.favorite = false;
                  //         } else if (res == 1) {
                  //           product.favorite = true;
                  //         }
                  //
                  //         product.changingFavoriteStatus = false;
                  //       });
                  //     },
                  //     child: (product.changingFavoriteStatus)
                  //         ? SpinKitFadingCircle(
                  //             size: 20,
                  //             color: theme.colorScheme.primary,
                  //             duration: Duration(seconds: 1),
                  //           )
                  //         : Icon(
                  //             product.favorite
                  //                 ? Icons.favorite_rounded
                  //                 : Icons.favorite_outline_rounded,
                  //             size: 20,
                  //             color: theme.colorScheme.primary,
                  //           ),
                  //   ),
                  // ),
                ],
              ),
            ),
            FxSpacing.height(8),
            FxText.labelLarge(
              product.name,
              fontWeight: 600,
            ),
            FxSpacing.height(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.labelLarge(
                  '$rs ${product.price}',
                  fontWeight: 700,
                ),
                FxContainer.bordered(
                  paddingAll: 2,
                  borderRadiusAll: 4,
                  child: Icon(
                    FeatherIcons.plus,
                    size: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
      list.add(FxSpacing.width(20));
    }

    return Row(
      children: list,
    );
  }
*/

  Widget _buildSizeWidget() {
    return const SizedBox.shrink();
    // List<Widget> list = [];
    //
    // for (String size in controller.sizes) {
    //   bool selected = size == controller.selectedSize;
    //   list.add(
    //     FxContainer.roundBordered(
    //       paddingAll: 8,
    //       width: 36,
    //       height: 36,
    //       onTap: () {
    //         controller.selectSize(size);
    //       },
    //       border: Border.all(
    //           color: selected
    //               ? theme.colorScheme.primary
    //               : theme.colorScheme.onBackground),
    //       color: selected ? theme.colorScheme.primary : null,
    //       child: Center(
    //         child: FxText.bodySmall(
    //           size,
    //           fontWeight: 600,
    //           color: selected
    //               ? theme.colorScheme.onSecondary
    //               : theme.colorScheme.onBackground,
    //         ),
    //       ),
    //     ),
    //   );
    //
    //   list.add(FxSpacing.width(8));
    // }
    //
    // return Wrap(
    //   children: list,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ProductDetailController>(
      controller: controller,
      builder: (controller) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // if (controller.uiLoading) {
    //   return Scaffold(
    //     body: Padding(
    //       padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
    //       child: LoadingEffect.getProductLoadingScreen(context),
    //     ),
    //   );
    // } else {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            controller.goBack();
          },
          child: Icon(
            FeatherIcons.chevronLeft,
            size: 20,
            color: theme.colorScheme.onBackground,
          ).autoDirection(),
        ),
        actions: [
          /*
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (BuildContext context, _) {
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      widget.product.changingFavoriteStatus = true;
                    });

                    final res = await CartProcessor.addToWishlist(
                      widget.product.allDetails['id'],
                      widget.product.allDetails['variants'][0]['id'],
                      widget.product,
                    );

                    if (res == -2) {
                      if (mounted) {
                        await CoolAlert.show(
                          context: context,
                          type: CoolAlertType.info,
                          title: "Login",
                          text:
                              "Please login first to add items to your wishlist.",
                          confirmBtnText: "OK",
                          onConfirmBtnTap: () {},
                        );

                        controller.goToLoginScreen();
                      }
                    }

                    setState(() {
                      if (res == -1) {
                        widget.product.favorite = false;
                      } else if (res == 1) {
                        widget.product.favorite = true;
                      }

                      widget.product.changingFavoriteStatus = false;
                    });
                  },
                  child: (widget.product.changingFavoriteStatus)
                      ? SpinKitFadingCircle(
                          size: 20,
                          color: theme.colorScheme.primary,
                          duration: Duration(seconds: 1),
                        )
                      : Icon(
                          widget.product.favorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          size: 30,
                          color: theme.colorScheme.primary,
                        ),
                ),
              );
            },
          ),
          FxSpacing.width(15),
          InkWell(
            onTap: () {
              controller.goToCart();
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 10,
                    top: 5,
                  ),
                  child: Icon(
                    FeatherIcons.shoppingBag,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      CartProcessor.itemList.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FxSpacing.width(5),
          */
          InkWell(
            onTap: () async {
              await Share.shareWithResult(
                  controller.product.allDetails['variants']
                      [controller.selectedVariant]['share_link']);
            },
            child: Icon(
              Icons.share,
            ),
          ),
          FxSpacing.width(5),
        ],
        title: FxText.titleMedium(
          controller.product.name,
          fontWeight: 600,
        ),
      ),
      body: ListView(
        padding: FxSpacing.fromLTRB(0, 4, 0, 20),
        children: [
          Hero(
            tag: "product_image_${controller.product.allDetails['id']}",
            child: FxContainer(
              margin: FxSpacing.x(20),
              paddingAll: 0,
              borderRadiusAll: 4,
              height: 250,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: AnimatedCarouselWidget(
                "",
                sliderImageUI(),
                height: 250,
              ),
            ),
          ),
          FxSpacing.height(20),
          FxContainer(
            margin: FxSpacing.x(20),
            paddingAll: 0,
            borderRadiusAll: 0,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Hero(
                        tag: "product_${controller.product.allDetails['id']}",
                        child: FxText.titleMedium(
                          controller.product.name,
                          fontWeight: 700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Hero(
                        tag:
                            "product_rating_${controller.product.allDetails['id']}",
                        child: FxContainer(
                          borderRadiusAll: 4,
                          padding: FxSpacing.xy(10, 0),
                          color: Colors.transparent,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FeatherIcons.star,
                                  color: theme.colorScheme.primary,
                                  size: 14,
                                ),
                                FxSpacing.width(6),
                                FxText.labelLarge(
                                  controller.product.rating.toString(),
                                  fontWeight: 600,
                                  color: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ...(discount > 0)
                        ? [
                            Stack(
                              children: [
                                FxText.bodyMedium(
                                  '$rs $productPrice',
                                  fontWeight: 600,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                Positioned(
                                  top: 8,
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            FxSpacing.width(5),
                          ]
                        : [],
                    Hero(
                      tag:
                          "product_price_${controller.product.allDetails['id']}",
                      child: FxText.titleMedium(
                        '$rs ${productPrice - discount}',
                        fontWeight: 600,
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (widget.product.allDetails['cod'] == "1")
                        ? FxContainer(
                            color: Constant.softColors.green.color,
                            borderRadius: BorderRadius.circular(4),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 16,
                                ),
                                FxSpacing.width(7),
                                Text(
                                  "COD Available",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    Row(
                      children: [
                        FxContainer(
                          // color: Constant.softColors.violet.color,
                          color: Colors.transparent,
                          margin: EdgeInsets.zero,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Constant.softColors.violet.onColor,
                                size: 12,
                              ),
                              FxSpacing.width(5),
                              Text(
                                "Sales ${(widget.product.allDetails.containsKey('total_orders')) ? widget.product.allDetails['total_orders'] : 0}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Constant.softColors.violet.onColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FxContainer(
                          // color: Constant.softColors.green.color,
                          color: Colors.transparent,
                          margin: EdgeInsets.zero,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Constant.softColors.green.onColor,
                                size: 12,
                              ),
                              FxSpacing.width(5),
                              Text(
                                "Views ${widget.product.allDetails['views']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Constant.softColors.green.onColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                stockUi(),
                FxSpacing.height(20),
                variantsUI(),
                FxSpacing.height(20),
                additionalDetailTiles(),
                // FxSpacing.height(20),
                // pincodeCheckUi(),
                FxSpacing.height(40),
                FxText.titleMedium(
                  "Description",
                  fontWeight: 600,
                ),
                FxSpacing.height(7),
                FxText.bodyMedium(
                  controller.product.description,
                  textAlign: TextAlign.justify,
                ),
                FxSpacing.height(40),
                qualityCheck(),
                // FxText.bodyMedium(
                //   'Size',
                //   fontWeight: 600,
                // ),
                FxSpacing.height(30),
                returnAndExchangePolicy(),
                _buildSizeWidget(),
              ],
            ),
          ),
          /*
          FxSpacing.height(20),
          Container(
            margin: FxSpacing.x(20),
            child: Row(
              children: [

                AnimatedBuilder(
                  animation: controller.cartController,
                  builder: (BuildContext context, _) {
                    return Stack(
                      children: [
                        FxContainer(
                          onTap: () {
                            controller.goToCart();
                          },
                          color: theme.colorScheme.primaryContainer,
                          paddingAll: controller.paddingAnimation.value,
                          child: Icon(
                            FeatherIcons.shoppingBag,
                            color: theme.colorScheme.primary,
                            size: controller.cartAnimation.value,
                          ),
                        ),
                        CartProcessor.itemList.isNotEmpty
                            ? Positioned(
                                right: 10,
                                top: 8,
                                child: FxContainer.rounded(
                                  color: theme.colorScheme.primary,
                                  paddingAll: 4,
                                  child: FxText.bodySmall(
                                    CartProcessor.itemList.length.toString(),
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 8,
                                    fontWeight: 700,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                ),


                FxSpacing.width(20),
                Expanded(
                  child: FxButton.block(
                    splashColor: theme.colorScheme.onPrimary.withAlpha(40),
                    backgroundColor: (disableCartButton)
                        ? theme.colorScheme.primary.withOpacity(0.5)
                        : theme.colorScheme.primary,
                    elevation: 0,
                    borderRadiusAll: 4,
                    onPressed: () {
                      if (disableCartButton) {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.info,
                            title: "Out of Stock",
                            text: "This item is not available !!");
                        return;
                      }
                      controller.addCart
                          ? controller.cartController.reverse()
                          : controller.cartController.forward();
                      // controller.goToCheckout();

                      CartProcessor.addToCart(
                          controller.product.allDetails['id'],
                          controller.product.allDetails['variants']
                              [controller.selectedVariant]['id'],
                          controller.product.allDetails);
                      setState(() {
                        CartProcessor.itemList;
                      });
                    },
                    child: FxText.bodyLarge(
                      'Add to Cart',
                      fontWeight: 600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),

              ],
            ),
          ),
          FxSpacing.height(20),
          Container(
            padding: FxSpacing.x(20),
            child: Row(
              children: [
                FxText.bodyLarge(
                  'Related',
                  letterSpacing: 0,
                  fontWeight: 600,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildProductList(),
          ),
          */
        ],
      ),
    );
    // }
  }

  List<Widget> sliderImageUI() {
    List<Widget> ans = [];

    if (widget
            .product
            .allDetails['variants'][controller.selectedVariant]['images']
            .length ==
        0) {
      ans.add(
        Image.network(
          widget.product.image,
          fit: BoxFit.cover,
        ),
      );
    }

    for (var row in widget.product.allDetails['variants']
        [controller.selectedVariant]['images']) {
      ans.add(
        Image.network(
          row['image_url'],
          fit: BoxFit.cover,
        ),
      );
    }
    return ans;
  }

  Widget variantsUI() {
    if (widget.product.allDetails['variants'].length <= 1) {
      return const SizedBox.shrink();
    }

    List<Widget> variantList = [];

    for (int i = 0; i < widget.product.allDetails['variants'].length; i++) {
      var row = widget.product.allDetails['variants'][i];

      variantList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FxContainer.bordered(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    widget.product,
                    variantId: i,
                  ),
                ),
              );
            },
            color: (i == controller.selectedVariant)
                ? theme.colorScheme.primaryContainer
                : null,
            borderColor: (i == controller.selectedVariant)
                ? theme.colorScheme.onPrimaryContainer
                : null,
            child: variantTile(row),
          ),
        ),
      );
    }

    return Column(
      children: [
        FxSpacing.height(5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.bodyMedium(
              "${widget.product.allDetails['variants'].length} more variants",
              fontWeight: 600,
            ),
            FxSpacing.height(7),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: variantList,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget variantTile(var variantDetails) {
    List<Widget> data = [];

    for (var row in variantDetails.entries) {
      if (row.value == "") continue;

      switch (row.key.toString().toLowerCase()) {
        case 'size':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Size: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['size'],
                  ),
                ],
              ),
            ),
          );
          break;
        case 'color':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Color: ",
                  ),
                  Icon(
                    Icons.circle,
                    color: HexColor.fromHex(variantDetails['color'].toString()),
                    size: 18,
                  ),
                ],
              ),
            ),
          );
          break;
        case 'fabric':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Fabric: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['fabric'],
                  ),
                ],
              ),
            ),
          );
          break;
        case 'age':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Age: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['age'],
                  ),
                ],
              ),
            ),
          );
          break;

        case 'gender':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Gender: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['gender'],
                  ),
                ],
              ),
            ),
          );
          break;

        case 'style':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Style: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['style'],
                  ),
                ],
              ),
            ),
          );
          break;

        case 'package':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Package: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['package'],
                  ),
                ],
              ),
            ),
          );
          break;

        case 'series':
          data.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleSmall(
                    "Series: ",
                  ),
                  FxText.titleSmall(
                    variantDetails['series'],
                  ),
                ],
              ),
            ),
          );
          break;
      }
    }

    return SizedBox(
      width: 100,
      child: Column(
        children: data,
      ),
    );
  }

  Widget additionalDetailTiles() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: AdditionalDetailsTile(
              "Category",
              controller.product.allDetails['cat_id'],
              Icons.category_sharp,
              theme,
            )),
            Expanded(
                child: AdditionalDetailsTile(
              "Sub-Category",
              controller.product.allDetails['sub_cat_id'],
              Icons.type_specimen_outlined,
              theme,
            )),
          ],
        ),
        FxSpacing.height(20),
        Row(
          children: [
            Expanded(
              child: AdditionalDetailsTile(
                "Brand",
                controller.product.allDetails['brand_name'],
                Icons.branding_watermark_outlined,
                theme,
              ),
            ),
            Expanded(
              child: AdditionalDetailsTile(
                "Origin",
                controller.product.allDetails['origin'],
                MdiIcons.earth,
                theme,
              ),
            ),
          ],
        ),
        FxSpacing.height(20),
      ],
    );
  }

  Widget stockUi() {
    Color color = Colors.green;
    String text = "";

    int stock = widget
        .product.allDetails['variants'][controller.selectedVariant]['s_stock']
        .toString()
        .toInt();

    if ((widget.product
            .allDetails['variants'][controller.selectedVariant]['a_stock']
            .toString()
            .toInt() >
        0)) {
      text = "Stock assured by $appName";
    } else if (stock < 4) {
      color = Colors.red;

      if (stock == 0) {
        text = "Out of stock !!";
      } else if (stock == 1) {
        text = "Only 1 unit left !!";
      } else {
        text = "Only $stock units left !!";
      }
    } else {
      text = "In Stock";
    }

    return FxContainer(
      margin: EdgeInsets.only(top: 10),
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: color.withOpacity(0.1),
      child: FxText.titleSmall(
        text,
        color: color,
        fontWeight: 600,
      ),
    );
  }

  /*
  Widget pincodeCheckUi() {
    return FxContainer(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
              ),
              FxSpacing.width(10),
              ...(DataGetters.isCurrentAddressLoaded)
                  ? [
                      FxText.bodyMedium(
                        "Deliver to ${DataGetters.currentAddress!.firstname} - ${DataGetters.currentAddress!.city} ${DataGetters.currentAddress!.pinCode}",
                        color: theme.colorScheme.primary,
                        fontWeight: 600,
                      ),
                    ]
                  : [],
            ],
          ),
          ...(DataGetters.isCurrentAddressLoaded)
              ? [
                  FxSpacing.height(15),
                  if (controller.isDeliveryAvailableForDefaultPinCode == 0)
                    FxContainer(
                      width: double.maxFinite,
                      color: Colors.red.withOpacity(0.1),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: FxText.bodyMedium(
                              "Delivery is not available for current address",
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    (controller.isDeliveryAvailableForDefaultPinCode == 1)
                        ? FxContainer(
                            width: double.maxFinite,
                            color: Colors.green.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: FxText.bodyMedium(
                                    "Delivery is available for current address",
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : FxContainer(
                            width: double.maxFinite,
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: FxText.bodyMedium(
                                    "Checking if delivery is available for current address ...",
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SpinKitCircle(
                                      duration: Duration(
                                        seconds: 1,
                                      ),
                                      size: 30,
                                      color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                ]
              : [],
          FxSpacing.height(10),
          InkWell(
            onTap: () {
              dynamic comeBackTo = ProductDetailScreen(
                widget.product,
                variantId: controller.selectedVariant,
              );

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddressesScreen(comeBackTo)));
            },
            child: FxText.bodyMedium(
              "Change Address ?",
              color: theme.colorScheme.primary,
            ),
          ),
          FxSpacing.height(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  style: FxTextStyle.bodyMedium(),
                  cursorColor: theme.colorScheme.primary,
                  controller: controller.pinCodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: "Check Delivery by PinCode",
                    hintStyle: FxTextStyle.bodySmall(
                        color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    prefixIcon: Icon(
                      FeatherIcons.search,
                      size: 16,
                      color: theme.colorScheme.onBackground.withAlpha(150),
                    ),
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onTapOutside: (p) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  onFieldSubmitted: (keyword) {},
                ),
              ),
              Expanded(
                flex: 2,
                child: FxContainer(
                  onTap: () {
                    if (controller.checkingCustomPinCode) return;

                    controller.checkDeliveryPinCode();
                  },
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: (controller.checkingCustomPinCode == false)
                      ? Icon(
                          Icons.search,
                        )
                      : SpinKitCircle(
                          duration: Duration(seconds: 1),
                          color: theme.colorScheme.primary,
                          size: 23,
                        ),
                ),
              ),
            ],
          ),
          checkDeliveryUi(),
        ],
      ),
    );
  }


  Widget checkDeliveryUi() {
    if (controller.isDeliveryAvailableForCustomPinCode == -1) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        FxSpacing.height(15),
        (controller.isDeliveryAvailableForCustomPinCode == 0)
            ? FxContainer(
                width: double.maxFinite,
                color: Colors.red.withOpacity(0.1),
                child: FxText.bodyMedium(
                  "Delivery is not available for ${controller.customPinCode}",
                  color: Colors.red,
                ),
              )
            : FxContainer(
                width: double.maxFinite,
                color: Colors.green.withOpacity(0.1),
                child: FxText.bodyMedium(
                  "Delivery is available for ${controller.customPinCode}",
                  color: Colors.green,
                ),
              ),
      ],
    );
  }

   */

  Widget qualityCheck() {
    String genuineImage = "assets/placeholder/genuine_seal.png";

    return FxContainer(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getImageAndTitleTile("Genuine\nProduct", genuineImage),
          FxSpacing.width(0),
          getImageAndTitleTile("Quality\nChecked", genuineImage),
        ],
      ),
    );
  }

  Widget getImageAndTitleTile(String title, String image) {
    double dim = 70;
    return Column(
      children: [
        Image(
          image: AssetImage(
            image,
          ),
          height: dim,
          width: dim,
        ),
        FxSpacing.height(10),
        FxText.titleSmall(
          title,
          textAlign: TextAlign.center,
          fontWeight: 900,
          color: Colors.red,
          fontSize: 16,
        ),
      ],
    );
  }

  Widget returnAndExchangePolicy() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.bodyMedium("Easy 7 days return and exchange", fontWeight: 900,),
          FxText.bodySmall("Choose to return or exchange for a different size if available. ", color: Colors.black.withOpacity(0.6),),
        ],
      ),
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
