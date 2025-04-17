import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller/extensions/string.dart';

class Product {
  String name, image, description;
  double price, rating;
  int review, quantity;
  Color color;
  bool favorite;
  bool changingFavoriteStatus;
  Map<dynamic, dynamic> allDetails;

  Product(this.name, this.image, this.description, this.rating, this.price,
      this.review, this.quantity, this.color, this.favorite,
      {this.allDetails = const {}, this.changingFavoriteStatus = false});

  static Future<List<Product>> getDummyList() async {
    dynamic data = json.decode(await getData());
    return getListFromJson(data);
  }

  static Future<Product> getOne() async {
    return (await getDummyList())[0];
  }

  static Product fromJson(Map<String, dynamic> prod) {
    int ratingCount = (prod['rating_count'].toString().isNotEmpty)
        ? int.parse(prod['rating_count'].toString())
        : 0;
    double rating = (prod['rating'].toString().isNotEmpty)
        ? double.parse(prod['rating'].toString())
        : 0.0;
    double price = double.parse(prod['variants'][0]['price']);

    return Product(
      prod['product_title'].toString(),
      prod['main_image'].toString(),
      prod['description'].toString(),
      rating,
      price,
      ratingCount,
      2,
      Colors.red,
      (prod['in_wishlist'].toString().toInt() > 0),
      allDetails: prod,
    );
  }

  static List<Product> getListFromJson(List<dynamic> jsonArray) {
    List<Product> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Product.fromJson(jsonArray[i]));
    }
    return list;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('lib/data/products.json');
  }

  static List<Product> fromJsonToProduct(var productData) {
    List<Product> productList = [];

    if (productData != null) {
      var allProducts = jsonDecode(productData);
      for (var prod in allProducts) {
        int ratingCount = (prod['rating_count'].toString().isNotEmpty)
            ? int.parse(prod['rating_count'].toString())
            : 0;
        double rating = (prod['rating'].toString().isNotEmpty)
            ? double.parse(prod['rating'].toString())
            : 0.0;
        double price = double.parse(prod['variants'][0]['price']);

        Product prd = Product(
          prod['product_title'].toString(),
          prod['main_image'].toString(),
          prod['description'].toString(),
          rating,
          price,
          ratingCount,
          2,
          Colors.red,
          (prod['in_wishlist'].toString().toInt() > 0),
          allDetails: prod,
        );
        productList.add(
          prd,
        );

        // if ((prod['in_wishlist'].toString().toInt() > 0)) {
        //   Pair pr = Pair(prod['id'], prod['variants'][0]['id']);
        //   if (!CartProcessor.wishlist.containsKey(pr)) {
        //     CartProcessor.wishlist[pr] = 1;
        //     CartProcessor.wishlistDetails[pr] = prd;
        //   }
        // }
      }
    }

    return productList;
  }
}
