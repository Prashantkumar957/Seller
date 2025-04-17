import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/local_storage_keys.dart';
import 'package:seller/theme/constant.dart';

import 'WebsiteDetailTile.dart';

class ContactTile {
  String name, description, profile, email, websiteStatus, mobile;
  ColorGroup websiteStatusColor;
  int defaultDescriptionLength, emailLength;
  double maxWidth;
  bool showMore = false, isVerified;
  List<WebsiteDetail> websiteList;

  ContactTile(
    this.name,
    this.description,
    this.profile,
    this.email,
    this.mobile,
    this.websiteStatus,
    this.websiteStatusColor,
      this.isVerified, {
    this.defaultDescriptionLength = 30,
    this.emailLength = 40,
    this.maxWidth = 220,
    this.websiteList = const [],
  });

  Widget getTile({Function()? onTapShowMore, Function()? onTapShowLess}) {
    return FxContainer(
      margin: const EdgeInsets.only(bottom: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        foregroundImage: NetworkImage(profile),
                      ),
                      FxSpacing.height(5),
                      FxContainer(
                        color: Constant.softColors.green.color,
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 10,
                            ),
                            FxSpacing.width(2),
                            FxText.titleSmall(
                              "Verified",
                              fontWeight: 600,
                              fontSize: 10,
                              color: Constant.softColors.green.onColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FxSpacing.width(15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.titleMedium(
                        name,
                        fontWeight: 600,
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      FxText.bodySmall(
                        (email.length > emailLength)
                            ? "${email.substring(0, emailLength - 3)}..."
                            : email,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: 600,
                      ),
                      FxSpacing.height(2),
                      Row(
                        children: [
                          FxText.bodySmall(
                            "Mobile: ",
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: 600,
                          ),
                          FxText.bodySmall(
                            "+91 9045097609",
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: 600,
                          ),
                        ],
                      ),
                      FxSpacing.height(7),
                      // FxText.bodySmall(
                      //   (description.length > defaultDescriptionLength)
                      //       ? "${description.substring(0, defaultDescriptionLength - 3)}..."
                      //       : description,
                      //   color: Colors.black.withOpacity(0.6),
                      // ),
                      FxContainer(
                        onTap: onTapShowMore,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            FxText.bodySmall(
                              "show more",
                              decoration: TextDecoration.underline,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: 600,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 17,
                              color: Colors.black.withOpacity(0.6),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Icon(
              //   Icons.more_vert_outlined,
              // ),
            ],
          ),
          (showMore)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxSpacing.height(25),
                    AnimatedContainer(
                      width: maxWidth,
                      duration: Duration(
                        seconds: 1,
                      ),
                      child: getWebsiteList(),
                    ),
                    FxSpacing.height(10),
                    FxContainer(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      color: Colors.transparent,
                      onTap: onTapShowLess,
                      child: Row(
                        children: [
                          FxText.bodySmall(
                            "show less",
                            decoration: TextDecoration.underline,
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: 600,
                          ),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 17,
                            color: Colors.black.withOpacity(0.6),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget getWebsiteList() {
    List<WebsiteDetail> websites = [
      WebsiteDetail(
          "https://john-snow-231673562536.wlai.org",
          "Social Media Site",
          "Live",
          Constant.softColors.green,
          "https://history.com"),
      WebsiteDetail("https://arya-stark-231673562536.wlai.org", "News Site",
          "Suspended", Constant.softColors.pink, ""),
    ];

    List<Widget> websiteTiles = [];

    for (var web in websites) {
      websiteTiles.add(getWebsiteTile(web));
    }

    return Column(
      children: websiteTiles,
    );
  }

  Widget getWebsiteTile(WebsiteDetail website) {
    return FxContainer(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.titleSmall(
            "Name: ${website.name}",
            fontWeight: 600,
            fontSize: 12,
            color: Colors.black.withOpacity(0.7),
          ),
          FxSpacing.height(5),
          Row(
            children: [
              FxText.bodySmall(
                "Website Status: ",
                color: Colors.black.withOpacity(0.6),
                fontWeight: 600,
              ),
              FxContainer(
                color: website.colorGroup.color,
                padding: EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 7,
                ),
                child: FxText.bodySmall(
                  website.status,
                  color: website.colorGroup.onColor,
                  fontWeight: 600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          FxSpacing.height(5),
          Row(
            children: [
              FxText.bodySmall(
                "Default Domain: ",
                color: Colors.black.withOpacity(0.6),
                fontWeight: 600,
              ),
              Flexible(
                child: FxText.bodySmall(
                  decoration: TextDecoration.underline,
                  website.defaultDomain,
                  color: Constant.softColors.blue.onColor,
                  fontWeight: 600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          FxSpacing.height(5),
          Row(
            children: [
              FxText.bodySmall(
                "Custom Domain: ",
                color: Colors.black.withOpacity(0.6),
                fontWeight: 600,
              ),
              Flexible(
                child: FxText.bodySmall(
                  decoration: (website.customDomain.isEmpty)
                      ? TextDecoration.none
                      : TextDecoration.underline,
                  (website.customDomain.isEmpty)
                      ? "Not Added Yet"
                      : website.customDomain,
                  color: Constant.softColors.blue.onColor,
                  fontWeight: 600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          FxSpacing.height(7),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  static ContactTile getClientObject(dynamic row) {
    List<WebsiteDetail> wbl = WebsiteDetail.getDetailListFromJson(row['website_details']);
    return ContactTile(row['name'].toString(), "", row['profile_pic'].toString(), row['email'].toString(), row['mobile'].toString(), "Checking...", Constant.softColors.violet, (row['verified'].toString() == "1"), websiteList: wbl);
  }
  
  static List<ContactTile> getClientListFromJson(dynamic js) {
    List<ContactTile> ans = [];
    for (var row in js) {
      ans.add(getClientObject(row));
    }
    
    return ans;
  }
}


class ClientDataLoader {
  static List<ContactTile> clientDataList = [];
  static bool isClientListLoaded = false;
  
  static Future<List<ContactTile>> getClientDataList() async {
    if (isClientListLoaded) return clientDataList;
    
    AndroidOptions androidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    FlutterSecureStorage st = FlutterSecureStorage(aOptions: androidOptions());
    
    final data = await st.read(key: clientDataKey);
    if (data != null) {
      clientDataList = ContactTile.getClientListFromJson(jsonDecode(data));
    } else {
      await refreshClientData();
    }

    refreshClientData();
    return clientDataList;
  }


  static Future<void> refreshClientData() async {
    Map<dynamic, dynamic> postData = {
      "module": "client",
      "submodule": "utils",
      "function": "client_list",
    };

    Database dbConnection = Database();
    final res = await dbConnection.getData(postData);
    if (res['status'] == 200) {
      clientDataList = ContactTile.getClientListFromJson(res['data']);
      AndroidOptions androidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
      FlutterSecureStorage st = FlutterSecureStorage(aOptions: androidOptions());
      await st.write(key: clientDataKey, value: jsonEncode(res['data']));
    } else {
      print("Unable to load client list");
    }
  }
}