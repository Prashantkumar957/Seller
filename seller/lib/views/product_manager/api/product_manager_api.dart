import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:seller/app_constants.dart';
import 'package:seller/database/database.dart';

class ProductManagerApi {
  final Database _db;

  ProductManagerApi({required Database db}) : _db = db;

  // Helper function to manage HTTP error codes
  String _handleHttpError(dynamic error) {
    // You may customize the conditions to map specific errors to HTTP codes
    print("Error from server: $error");
    if (error.toString().contains("not found")) {
      return "404: Resource not found";
    } else if (error.toString().contains("timeout")) {
      return "408: Request timeout";
    } else if (error.toString().contains("permission denied")) {
      return "403: Forbidden - Permission denied";
    } else {
      return "500: Internal server error";
    }
  }

  // Wrapper function to simplify the use of TaskEither
  TaskEither<String, Map> _executeRequest(Map<String, dynamic> postBody) {
    return TaskEither.tryCatch(
      () async => await _db.getData(postBody),
      (error, _) => _handleHttpError(error),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<Either<String, Map<String, dynamic>>> fetchPackages() async {
    final postBody = {
      "get_products": "true",
      "utils": "true",
      "module": "marketplace",
      "functions": jsonEncode([
        'package_units',
        'donation_types',
      ]),
      "marketplace_id": productsMarketplaceId,
    };
    return _executeRequest(postBody)
        .map((r) => r as Map<String, dynamic>)
        .run();
  }

  Future<Either<String, Map<String, dynamic>>> postProduct(
      Map<String, dynamic> formData) async {
    final formRequest = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl),
    );
    http.MultipartFile? productImage;
    http.MultipartFile? productCatalogue;
    http.MultipartFile? sizeChart;

    if (formData['product_image'] != null) {
      productImage = await http.MultipartFile.fromPath(
        'product_image',
        (formData['product_image'] as File).path,
      );
      formRequest.files.add(productImage);
    }
    if (formData['product_catalogue'] != null) {
      productCatalogue = await http.MultipartFile.fromPath(
        'product_catalogue',
        (formData['product_catalogue'] as File).path,
      );
      formRequest.files.add(productCatalogue);
    }
    if (formData['size_chart'] != null) {
      sizeChart = await http.MultipartFile.fromPath(
        'size_chart',
        (formData['size_chart'] as File).path,
      );
      formRequest.files.add(sizeChart);
    }


    List<List<String>> variantImageKey = [], variantAndImages = [];
    int key = 1;
    for (var v in formData['variants']) {
      List<String> ls = [], lsIm = [];
      for (var im in v['images']) {
        if (im == null) continue;
        ls.add(key.toString());
        lsIm.add(im!.path);
        key++;
      }

      variantImageKey.add(ls);
      variantAndImages.add(lsIm);
    }

    for (int i = 0; i < variantAndImages.length; i++) {
      for (int j = 0; j < variantAndImages[i].length; j++) {
        formRequest.files.add(await http.MultipartFile.fromPath(variantImageKey[i][j], variantAndImages[i][j]));
      }
    }

    formRequest.fields.addAll(
      {
        "module": "marketplace",
        "submodule": "add_product",
        "marketplace_id": productsMarketplaceId,
        "title": formData['product_title'],
        "is_draft": formData['draft'].toString(),
        "for_self": formData['self'].toString(),
        "posting_for": formData["posting_for"] ?? "",
        "category": formData["category"],
        "sub_category": formData["sub_category"],
        "child_category": formData["child_category"],
        "item_type": formData["item_type"],
        "brand_name": formData["brand_name"],
        "sku": formData["sku"],
        "origin": formData["origin"],
        "manufacturer": formData["manufacturer"],
        "tags": (formData["tags"]),
        "product_description": formData["product_description"].toString(),
        "variants": jsonEncode(
            (formData['variants'] as List<Map<String, dynamic>>)
                .mapWithIndex((field, index) {
          return jsonEncode({
            'size': field['size'],
            'color': field['color'],
            'fabric': field['fabric'],
            'price': field['price'],
            'mrp': field['mrp'],
            'self_declared_stock': field['self_declared_stock'],
            'assured_stock': field['assured_stock'],
            'images': jsonEncode(
              variantImageKey[index],
            ),
          });
        }).toList()),
        'package_type': formData['package_type'],
        'package_length': formData['package_length'],
        'package_width': formData['package_width'],
        'package_height': formData['package_height'],
        'length_unit': formData['length_unit'] ?? "",
        'package_weight': formData['package_weight'],
        'weight_unit': formData['weight_unit'] ?? "",
        'is_additional_discount_for_charity':
            formData['is_additional_discount_for_charity'],
        'donation_type': formData['donation_type'].toString(),
        'donation_per_sale_amount': formData['donation_per_sale_amount'] ?? "",
        'donation_percent': formData['donation_percent'] ?? "",
        'secondary_information': formData['secondary_information'],
        'cod_available': formData['cod_available'],
        'gst_inclusive': formData['gst_inclusive'],
        'gst_rate': formData['gst_rate'] ?? "",
        'is_product_expirable': formData['is_product_expirable'],
        'expiry_date': formData['expiryDate'] ?? "",
        'is_returnable': formData['is_returnable'].toString(),
        'return_duration': formData['return_duration'].toString() ?? "",
        'is_additional_details': formData['is_additional_details'],
        'terms_and_conditions': formData['terms_and_conditions'].toString(),
        'faqs': formData['faqs'].toString(),
        'warranty_description': formData['warranty_description'].toString(),
        'package_includes': formData['package_includes'].toString(),
      },
    );

    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    final existingSessionId = await storage.read(key: "SESSION_ID");

    formRequest.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'APP_ID': appId,
      'SESSION_ID':
          (existingSessionId != null) ? existingSessionId.toString() : '',
    });


    try {
      final streamedResponse = await formRequest.send();

      final response = await http.Response.fromStream(streamedResponse);

      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print(result);

      return right(result);
    } catch (e) {
      return left(e.toString());
    }
  }


  Future<Either<String, Map<String, dynamic>>> updateProduct(
      Map<String, dynamic> formData) async {
    final formRequest = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl),
    );
    http.MultipartFile? productImage;
    http.MultipartFile? productCatalogue;
    http.MultipartFile? sizeChart;

    if (formData['product_image'] != null) {
      productImage = await http.MultipartFile.fromPath(
        'product_image',
        (formData['product_image'] as File).path,
      );
      formRequest.files.add(productImage);
    }
    if (formData['product_catalogue'] != null) {
      productCatalogue = await http.MultipartFile.fromPath(
        'product_catalogue',
        (formData['product_catalogue'] as File).path,
      );
      formRequest.files.add(productCatalogue);
    }
    if (formData['size_chart'] != null) {
      sizeChart = await http.MultipartFile.fromPath(
        'size_chart',
        (formData['size_chart'] as File).path,
      );
      formRequest.files.add(sizeChart);
    }


    List<List<String>> variantImageKey = [], variantAndImages = [];
    int key = 1;
    for (var v in formData['variants']) {
      List<String> ls = [], lsIm = [];
      for (var im in v['images']) {
        if (im == null) continue;
        ls.add(key.toString());
        lsIm.add(im!.path);
        key++;
      }

      variantImageKey.add(ls);
      variantAndImages.add(lsIm);
    }

    for (int i = 0; i < variantAndImages.length; i++) {
      for (int j = 0; j < variantAndImages[i].length; j++) {
        formRequest.files.add(await http.MultipartFile.fromPath(variantImageKey[i][j], variantAndImages[i][j]));
      }
    }

    formRequest.fields.addAll(
      {
        "module": "marketplace",
        "product_id" : formData['product_id'],
        "submodule": "update_product",
        "marketplace_id": productsMarketplaceId,
        "title": formData['product_title'],
        "is_draft": formData['draft'].toString(),
        "for_self": formData['self'].toString(),
        "posting_for": formData["posting_for"] ?? "",
        "category": formData["category"],
        "sub_category": formData["sub_category"],
        "child_category": formData["child_category"],
        "item_type": formData["item_type"],
        "brand_name": formData["brand_name"],
        "sku": formData["sku"],
        "origin": formData["origin"],
        "manufacturer": formData["manufacturer"],
        "tags": (formData["tags"]),
        "product_description": formData["product_description"].toString(),
        "variants": jsonEncode(
            (formData['variants'] as List<Map<String, dynamic>>)
                .mapWithIndex((field, index) {
              return jsonEncode({
                'size': field['size'],
                'color': field['color'],
                'fabric': field['fabric'],
                'price': field['price'],
                'mrp': field['mrp'],
                'self_declared_stock': field['self_declared_stock'],
                'assured_stock': field['assured_stock'],
                'images': jsonEncode(
                  variantImageKey[index],
                ),
              });
            }).toList()),
        'package_type': formData['package_type'],
        'package_length': formData['package_length'],
        'package_width': formData['package_width'],
        'package_height': formData['package_height'],
        'length_unit': formData['length_unit'] ?? "",
        'package_weight': formData['package_weight'],
        'weight_unit': formData['weight_unit'] ?? "",
        'is_additional_discount_for_charity':
        formData['is_additional_discount_for_charity'],
        'donation_type': formData['donation_type'].toString(),
        'donation_per_sale_amount': formData['donation_per_sale_amount'] ?? "",
        'donation_percent': formData['donation_percent'] ?? "",
        'secondary_information': formData['secondary_information'],
        'cod_available': formData['cod_available'],
        'gst_inclusive': formData['gst_inclusive'],
        'gst_rate': formData['gst_rate'] ?? "",
        'is_product_expirable': formData['is_product_expirable'],
        'expiry_date': formData['expiryDate'] ?? "",
        'is_returnable': formData['is_returnable'].toString(),
        'return_duration': formData['return_duration'].toString() ?? "",
        'is_additional_details': formData['is_additional_details'],
        'terms_and_conditions': formData['terms_and_conditions'].toString(),
        'faqs': formData['faqs'].toString(),
        'warranty_description': formData['warranty_description'].toString(),
        'package_includes': formData['package_includes'].toString(),
      },
    );

    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    final existingSessionId = await storage.read(key: "SESSION_ID");

    formRequest.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'APP_ID': appId,
      'SESSION_ID':
      (existingSessionId != null) ? existingSessionId.toString() : '',
    });


    try {
      final streamedResponse = await formRequest.send();

      final response = await http.Response.fromStream(streamedResponse);

      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print("API RESULT START");
      print(result);
      print("API RESULT END");

      if (result['status'] != 200) {
        return left(result['error']);
      }

      return right(result);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> getItems() async {
    final filters = {"current_vendor": "true"};
    final postBody = {
      "get_products": "true",
      "module": "marketplace",
      "marketplace_id": "5",
      "filters": jsonEncode(filters),
    };

    return _executeRequest(postBody).map((r) {
      return Map<String, dynamic>.from(r);
    }).run();
  }
}
