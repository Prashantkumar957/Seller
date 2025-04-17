import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:seller/models/contact_tile.dart';

import '../loading_effect.dart';
import '../theme/constant.dart';
import 'WebsiteDetailTile.dart';

class ContactTileStateful extends StatefulWidget {
  final ContactTile detail;

  const ContactTileStateful(this.detail, {super.key});

  @override
  State<ContactTileStateful> createState() => _ContactTileStatefulState();

  static Widget getLoadingUI(BuildContext context,
      {int itemCount = 6, double height = 30}) {
    LoadingThemeData theme = LoadingThemeData.theme;

    Widget singleLoading = Shimmer.fromColors(
      baseColor: theme.shimmerBaseColor,
      highlightColor: theme.shimmerHighlightColor,
      child: Container(
        padding: FxSpacing.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 12,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: FxSpacing.only(top: 8.0),
                        child: Container(
                          height: 8,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: FxSpacing.only(top: 16.0),
                        child: Container(
                          height: 8,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                          padding: FxSpacing.only(top: 8),
                          child: Container(
                            height: 80,
                            width: 80,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    height: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    List<Widget> list = [];
    for (int i = 0; i < itemCount; i++) {
      list.add(Container(padding: FxSpacing.all(16), child: singleLoading));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}

class _ContactTileStatefulState extends State<ContactTileStateful> {
  late String name, description, profile, email, websiteStatus, mobile;
  late ColorGroup websiteStatusColor;
  late int defaultDescriptionLength, emailLength;
  late double maxWidth;
  late bool showMore = false;

  @override
  void initState() {
    super.initState();
    name = widget.detail.name;
    description = widget.detail.description;
    profile = widget.detail.profile;
    email = widget.detail.email;
    mobile = widget.detail.mobile;
    websiteStatus = widget.detail.websiteStatus;
    websiteStatusColor = widget.detail.websiteStatusColor;
    defaultDescriptionLength = widget.detail.defaultDescriptionLength;
    emailLength = widget.detail.emailLength;
    maxWidth = widget.detail.maxWidth;
    showMore = widget.detail.showMore;
  }

  @override
  Widget build(BuildContext context) {
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
                      (profile.isEmpty) ? CircleAvatar(
                        radius: 30,
                        foregroundImage: AssetImage("assets/placeholder/profile_placeholder_png.png"),
                        backgroundColor: Colors.white,
                      ) : CircleAvatar(
                        radius: 30,
                        foregroundImage: NetworkImage(profile),
                      ),
                      FxSpacing.height(5),
                      (widget.detail.isVerified)
                          ? FxContainer(
                              color: Constant.softColors.green.color,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 4),
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
                            )
                          : FxContainer(
                              color: Constant.softColors.pink.color,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 4),
                              child: Row(
                                children: [
                                  FxText.titleSmall(
                                    "Unverified",
                                    fontWeight: 600,
                                    fontSize: 10,
                                    color: Constant.softColors.pink.onColor,
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
                            mobile,
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
                      (showMore == false)
                          ? FxContainer(
                              onTap: () {
                                setState(() {
                                  showMore = true;
                                });
                              },
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
                            )
                          : FxContainer(
                              onTap: () {
                                setState(() {
                                  showMore = false;
                                });
                              },
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              color: Colors.transparent,
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
                      width: MediaQuery.of(context).size.width,
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
                      onTap: () {
                        setState(() {
                          showMore = false;
                        });
                      },
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
    List<WebsiteDetail> websites = widget.detail.websiteList;

    List<Widget> websiteTiles = [];

    for (var web in websites) {
      websiteTiles.add(WebsiteDetailTile(web));
    }

    if (websiteTiles.isEmpty) {
      return Column(
        children: [
          FxText.bodySmall("No website is purchased yet!!"),
        ],
      );
    }

    return Column(
      children: websiteTiles,
    );
  }
}
