import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';

import '../theme/constant.dart';

class Membership {
  String? image;
  String title, duration;
  double price;
  String membershipID;
  List<String> availableFeatures, unavailableFeatures, mainFeatures;
  Map<dynamic, dynamic> allDetails;
  bool showSmallCard, alreadyPurchased;

  Membership(
      this.membershipID,
      this.title,
      this.image,
      this.duration,
      this.price,
      this.availableFeatures,
      this.unavailableFeatures,
      this.mainFeatures,
      {this.allDetails = const {},
      this.showSmallCard = false,
      this.alreadyPurchased = false});
}

Widget getMembershipCard(Membership membership, Function()? onTap) {
  double height = 600, width = 300;
  if (membership.showSmallCard) height = 400;

  var boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.colorScheme.primaryContainer,
        Constant.softColors.violet.onColor.withOpacity(0.7),
      ],
    ),
  );

  return FlipCard(
    front: Stack(
      children: [
        Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 10,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
          decoration: boxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (membership.image != null)
                      ? Image(
                          image: NetworkImage(
                            membership.image!,
                          ),
                          color: Constant.softColors.violet.onColor,
                        )
                      : SizedBox.shrink(),
                  (membership.showSmallCard)
                      ? FxSpacing.height(150)
                      : FxSpacing.height(0),
                  FxText.titleLarge(
                    membership.title.toUpperCase(),
                    color: theme.colorScheme.secondaryContainer,
                    fontWeight: 900,
                  ),
                  ...(membership.showSmallCard == false)
                      ? [
                          FxSpacing.height(20),
                          SizedBox(
                            height: 170,
                            child: ListView(
                              children: [
                                ...getListItem(membership.mainFeatures,
                                    onlyFirst: 3),
                                ...(membership.mainFeatures.length < 3)
                                    ? getListItem(membership.availableFeatures,
                                        onlyFirst:
                                            3 - membership.mainFeatures.length)
                                    : [],
                              ],
                            ),
                          ),
                        ]
                      : [],
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        color:
                            Constant.softColors.violet.color.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(80),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: (membership.alreadyPurchased == false) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                        children: (membership.alreadyPurchased == false) ? [
                          Text(
                            "${membership.duration} day(s)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constant.softColors.violet.onColor,
                            ),
                          ),
                          Text(
                            "$rupee ${membership.price}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constant.softColors.violet.onColor,
                            ),
                          ),
                        ] : [
                          Text(
                            "Already Active, Buy again ?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constant.softColors.violet.onColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FxSpacing.height(15),
                  FxText.titleSmall(
                    "**Terms & Conditions Apply**",
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 22,
          left: 15,
          child: Icon(
            Icons.workspace_premium_outlined,
            color: Constant.softColors.violet.onColor,
            size: 34,
          ),
        ),
        Positioned(
          right: 18,
          top: 25,
          child: Text(
            "Tap to flip",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Constant.softColors.violet.onColor),
          ),
        ),
        ...(membership.alreadyPurchased)
            ? [alreadyPurchasedUI(), alreadyPurchasedIcon()]
            : [],
      ],
    ),
    back: Container(
      height: height,
      width: width,
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                FxText.titleLarge(membership.title),
                FxSpacing.height(15),
                ...(membership.showSmallCard == false)
                    ? [
                        FxText.bodySmall(
                          membership.allDetails['additional_details']
                              .toString(),
                          textAlign: TextAlign.justify,
                        ),
                        FxSpacing.height(25),
                        Container(
                          width: double.maxFinite,
                          child: FxText.titleMedium(
                            "This membership includes: ",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        FxSpacing.height(15),
                        SizedBox(
                          height: 382,
                          child: ListView(
                            children: [
                              ...getListItem(membership.mainFeatures),
                              ...getListItem(membership.availableFeatures),
                            ],
                          ),
                        ),
                        FxSpacing.height(15),
                      ]
                    : [SizedBox.shrink()],
              ],
            ),
            FxText.titleSmall(
              "Terms and conditions Reloaded 1 of 2121 libraries in 1,415ms (compile: 86 ms, reload: 790 ms, reassemble: 468 ms)",
              textAlign: TextAlign.justify,
              fontSize: 10,
            ),
          ],
        ),
      ),
    ),
  );
}

List<Widget> getListItem(List<String> features, {int onlyFirst = 100000}) {
  List<Widget> ans = [];
  int i = 0;
  for (var f in features) {
    if (i >= onlyFirst) break;
    i++;
    ans.add(Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          FxSpacing.width(5),
          Icon(
            CupertinoIcons.checkmark,
          ),
          FxSpacing.width(10),
          Flexible(
            child: FxText.titleSmall(
              f,
              fontWeight: 600,
            ),
          ),
        ],
      ),
    ));
  }
  return ans;
}


Widget alreadyPurchasedIcon() {
  return Positioned(
    top: 40,
    left: 10,
    child: Icon(
      Icons.check_circle_outline,
      color: Constant.softColors.violet.onColor.withOpacity(0.1),
      size: 300,
    ),
  );
}


Widget alreadyPurchasedUI() {
  return Positioned(
    top: 160,
    left: 70,
    child: Transform.rotate(
      angle: -45,
      child: Text(
        "Purchased",
        style: TextStyle(
          color: Constant.softColors.violet.onColor.withOpacity(0.2),
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
    ),
  );
}
