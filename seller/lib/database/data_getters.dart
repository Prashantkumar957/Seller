import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seller/models/proposal_widget.dart';

import '../app_constants.dart';
import '../local_storage_keys.dart';
import 'database.dart';

class DataGetters {
  static String username = "Guest";
  static bool isFirstTimeUser = true;
  static bool showClientSection = false;
  static bool isLoggedIn = false;
  static dynamic targetScreen;
  static dynamic userData;
  static bool isCurrentAddressLoaded = false;
  static bool isProposalsRefreshed = false;

  static dynamic loadHomeScreenAdsBanner() async {
    Database dbConnection = Database();
    Map<String, dynamic> postBody = {
      "module": "ads",
      "submodule": "get_ads",
      "marketplace_id": marketplaceId,
    };

    final data = await dbConnection.getData(postBody);
    if (data['status'] == 200) {
      AndroidOptions androidOptions() =>
          const AndroidOptions(encryptedSharedPreferences: true);
      var st = FlutterSecureStorage(aOptions: androidOptions());
      await st.write(key: homeScreenSliderAds, value: jsonEncode(data['data']));


      final userdata = await st.read(key: "user_data");
      if (userdata != null) {
        var d = jsonDecode(userdata);
        userData = d;
        username = d['name'];
      }

      return data;
    }

    return null;
  }

  static dynamic loadBasicUtils() async {
    Database dbConnection = Database();
    Map<String, dynamic> postBody = {
      "get_products": "true",
      "utils": "true",
      "module": "marketplace",
      "functions": jsonEncode([
        'category',
        'top_category',
        'blogs',
      ]),
      "marketplace_id": marketplaceId,
    };

    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      AndroidOptions androidOptions() =>
          const AndroidOptions(encryptedSharedPreferences: true);
      var st = FlutterSecureStorage(aOptions: androidOptions());
      await st.write(
          key: categoriesHomePageKey,
          value: jsonEncode(res['data']['category']));
      await st.write(
          key: topCategoriesKey,
          value: jsonEncode(res['data']['top_category']));
      await st.write(key: blogsKey, value: jsonEncode(res['data']['blogs']));

      return res['data'];
    }
  }

  static dynamic loadItems(Map<String, dynamic> filters, {int? marketplaceId}) async {
    Database dbConnection = Database();

    Map<String, dynamic> postBody = {
      "get_products": "true",
      "module": "marketplace",
      "marketplace_id": (marketplaceId == null) ? productsMarketplaceId : marketplaceId.toString(),
      "filters": jsonEncode(filters),
    };

    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      AndroidOptions androidOptions() =>
          const AndroidOptions(encryptedSharedPreferences: true);
      var st = FlutterSecureStorage(aOptions: androidOptions());
      if (filters.isEmpty  &&  marketplaceId.toString() != productsMarketplaceId) {
        await st.write(key: 'products', value: jsonEncode(res['data']));
        await st.write(key: 'categories', value: jsonEncode(res['categories']));
        await st.write(
            key: 'price_range', value: jsonEncode(res['price_range']));
        if (res.containsKey('brand_names')) {
          await st.write(key: brandNamesKey, value: jsonEncode(res['brand_names']));
        }
      }
      return res['data'];
    }

    return null;
  }

  static dynamic loadMarketplaceList() async {
    Database database = Database();
    Map<String, dynamic> postBody = {
      "get_products" : "true",
      "module" : "marketplace",
      "get_marketplace_list": "true",
    };

    final data = await database.getData(postBody);
    if (data['status'] == 200) {
      AndroidOptions androidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
      FlutterSecureStorage st = FlutterSecureStorage(aOptions: androidOptions());
      await st.write(key: marketplaceListKey, value: jsonEncode(data['data']));
    } else {
      if (kDebugMode) {
        print("Marketplace list fetch failed");
      }
    }
  }

  static Future<void> initUserDataFromLocalStorage() async {
    AndroidOptions androidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    FlutterSecureStorage storage = FlutterSecureStorage(aOptions: androidOptions());

    final data = await storage.read(key: "user_data");
    if (data != null) {
      userData = jsonDecode(data) as Map<String, dynamic>;
      username = userData['name'];
      if (userData.containsKey('show_client_section')) {
        String x = userData['show_client_section'].toString();
        showClientSection = (x == "1"  ||  x == "true");
      }
    }
  }

  static Future<void> loadEverything() async {
    // await loadHomeScreenAdsBanner();
    await Future.wait<dynamic>([initUserDataFromLocalStorage(), loadBasicUtils(), loadItems({"current_vendor" : "true"}), loadMarketplaceList()]);
  }

  static Future<List<Proposal>> loadProposals({bool storeResultInSecureStorage = false, String targetMarketplace = "ANY", String category = "", String subCategory = "", String childCategory = "", String itemId = ""}) async {
    Map<String, String> postBody = {
      "module" : "marketplace",
      "submodule" : "get_proposals",
      "marketplace_id" : proposalMarketplace,
      "target_marketplace_id" : targetMarketplace,
      "category" : category,
      "sub_category" : subCategory,
      "child_category" : childCategory,
      "item_id" : itemId,
    };

    Database db = Database();
    final res = await db.getData(postBody);
    List<Proposal> ans = [];

    if (res['status'] == 200) {
      if (storeResultInSecureStorage) {
        AndroidOptions androidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
        FlutterSecureStorage storage = FlutterSecureStorage(aOptions: androidOptions());
        isProposalsRefreshed = true;
        storage.write(key: proposalsKey, value: jsonEncode(res['data']));
      }

      ans = Proposal.getProposalListFromJson(res['data']);
    }

    return ans;
  }
}