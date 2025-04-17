import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';

enum ShopStatus { close, open }

class ProfileController extends FxController {
  late ShopStatus shopStatus;

  ProfileController() {
    shopStatus = ShopStatus.open;
  }

  void changeShopStatus(ShopStatus shopStatus) {
    this.shopStatus = shopStatus;
    update();
  }


  @override
  String getTag() {
    return "profile_controller";
  }
}
