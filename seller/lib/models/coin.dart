import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:seller/extensions/extensions.dart';
import 'package:flutter/services.dart';

class Coin {
  String name, image, code;
  double price;
  DateTime date;
  Widget tooltip;

  Coin(this.name, this.image, this.code, this.price, this.date, {this.tooltip = const SizedBox.shrink()});
  static Future<List<Coin>> getDummyList() async {
    dynamic data = json.decode(await getData());
    return getListFromJson(data);
  }

  static Future<Coin> getOne() async {
    return (await getDummyList())[0];
  }

  static Future<Coin> fromJson(Map<String, dynamic> jsonObject) async {
    String name = jsonObject['name'].toString();
    String image = jsonObject['image'].toString();
    String code = jsonObject['code'].toString();
    double? price = jsonObject['price'].toString().toDouble(0);
    DateTime date = DateTime.parse(jsonObject['date'].toString());

    return Coin(name, image, code, price, date);
  }

  static Future<List<Coin>> getListFromJson(List<dynamic> jsonArray) async {
    List<Coin> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(await Coin.fromJson(jsonArray[i]));
    }
    return list;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('lib/data/coins.json');
  }
}
