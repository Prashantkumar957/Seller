import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:seller/database/database.dart';

class ItemsApi {
  final Database _db;

  ItemsApi({required Database db}) : _db = db;

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

  Future<Either<String, Map<String, dynamic>>> fetchCategory(
      String marketplaceId) async {
    final postBody = {
      "get_products": "true",
      "utils": "true",
      "module": "marketplace",
      "functions": jsonEncode([
        'category', 'package_units', 'donation_types', 'fabrics', 'posts_left',
      ]),
      "marketplace_id": marketplaceId,
    };
    return _executeRequest(postBody)
        .map((r) => r as Map<String, dynamic>)
        .run();
  }

  Future<Either<String, Map<String, dynamic>>> fetchSubCategory(
      String marketplaceId, String selectedCategory) async {
    final postBody = {
      "get_products": "true",
      "utils": "true",
      "module": "marketplace",
      "selected_category": selectedCategory,
      "functions": jsonEncode([
        'sub_category',
      ]),
      "marketplace_id": marketplaceId,
    };
    return _executeRequest(postBody)
        .map((r) => r as Map<String, dynamic>)
        .run();
  }

  Future<Either<String, Map<String, dynamic>>> fetchChildCategory(
      String marketplaceId,
      String selectedCategory,
      String selectedSubCategory) async {
    final postBody = {
      "get_products": "true",
      "utils": "true",
      "module": "marketplace",
      "selected_category": selectedCategory,
      "selected_sub_category": selectedSubCategory,
      "functions": jsonEncode([
        'child_category',
      ]),
      "marketplace_id": marketplaceId,
    };
    return _executeRequest(postBody)
        .map((r) => r as Map<String, dynamic>)
        .run();
  }

  Future<Either<String, Map<String, dynamic>>> fetchItems(
      String marketplaceId,
      String selectedCategory,
      String selectedSubCategory,
      String selectedChildCategory) async {
    final postBody = {
      "get_products": "true",
      "utils": "true",
      "module": "marketplace",
      "selected_category": selectedCategory,
      "selected_sub_category": selectedSubCategory,
      "selected_child_category": selectedChildCategory,
      "functions": jsonEncode([
        'items',
      ]),
      "marketplace_id": marketplaceId,
    };
    return _executeRequest(postBody)
        .map((r) => r as Map<String, dynamic>)
        .run();
  }
}
