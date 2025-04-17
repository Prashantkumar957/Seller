import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:seller/database/database.dart';

class PermissionManagerApi {
  final Database _db;

  PermissionManagerApi({required Database db}) : _db = db;

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

  Future<Either<String, List<String>>> listPermissions({
    required String targetVendor,
  }) async {
    final postBody = {
      "module": "permission_manager",
      "submodule": "get_permission_list",
      "target_vendor": targetVendor,
    };
    return _executeRequest(postBody).map((response) {
      if (response['status'] == 200 && response['data'] is Map) {
        final permissions = response['data']['permission_list'];
        if (permissions is List) {
          return permissions.map((e) => e.toString()).toList();
        } else {
          throw Exception("Unexpected data format for permissions");
        }
      } else {
        throw Exception("Invalid server response format or status");
      }
    }).run();
  }

  Future<Either<String, Map>> grantPermission({
    required Map<String, String> permissionList,
    required String targetVendor,
    required String targetSiteId,
  }) async {
    final postBody = {
      "module": "permission_manager",
      "submodule": "grant_permission",
      "permission_list": jsonEncode(permissionList),
      'target_vendor': targetVendor,
      'target_site_id': targetSiteId,
    };
    return _executeRequest(postBody).run();
  }

  Future<Either<String, Map>> revokePermission({
    required Map<String, String> permissionList,
    required String targetVendor,
    required String targetSiteId,
  }) async {
    final postBody = {
      "module": "permission_manager",
      "submodule": "revoke_permission",
      "permission_list": jsonEncode(permissionList),
      'target_vendor': targetVendor,
      'target_site_id': targetSiteId,
    };
    return _executeRequest(postBody).run();
  }

  Future<Either<String, List<Map<String, dynamic>>>> fetchVendors() async {
    final postBody = {
      "module": "client",
      "submodule": "utils",
      "function": "client_list",
    };

    return _executeRequest(postBody).map((response) {
      if (response['data'] is List) {
        return (response['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception("Unexpected data format");
      }
    }).run();
  }

  Future<Either<String, Map<String, dynamic>>> fetchMarketplacePermissions({
    required String targetSiteId,
    required String targetVendor,
    required List<String> marketPlaceId,
  }) async {
    final postBody = {
      "module": "admin",
      "submodule": "check_site_permission",
      "site_id": targetSiteId,
      'target_vendor': targetVendor,
      "permissions": jsonEncode({
        'marketplace': jsonEncode([
          {
            for (String id in marketPlaceId) 'id': id,
            'permissions': jsonEncode({
              'insert': '1',
              'update': '1',
              'delete': '1',
              'manager': '1',
              'view': '1',
            }),
          },
        ]),
      }),
    };
    return _executeRequest(postBody).map((response) {
      return response as Map<String, dynamic>;
    }).run();
  }

  Future<Either<String, Map<String, dynamic>>> getCurrentPermissions({
    required String targetSiteId,
    required Map<String, String> permissionList,
    required String targetVendor,
  }) async {
    final postBody = {
      "module": "admin",
      "submodule": "check_site_permission",
      "site_id": targetSiteId,
      'target_vendor': targetVendor,
      "permissions": jsonEncode(permissionList),
    };

    return _executeRequest(postBody).map((response) {
      return {
        "have_permission": response["have_permission"],
        "is_requested": response["is_requested"],
      };
    }).run();
  }

  Future<Either<String, Map<String, dynamic>>> getMarketplaceList() async {
    final postBody = {
      "get_products": "true",
      "module": "marketplace",
      "get_marketplace_list": "true",
    };

    return _executeRequest(postBody).map((response) {
      return response as Map<String, dynamic>;
    }).run();
  }
}
