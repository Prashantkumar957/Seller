import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/constant.dart';

class WebsiteDetailTile extends StatefulWidget {
  final WebsiteDetail website;
  const WebsiteDetailTile(this.website, {super.key});

  @override
  State<WebsiteDetailTile> createState() => _WebsiteDetailTileState();
}

class _WebsiteDetailTileState extends State<WebsiteDetailTile> {
  late WebsiteDetail website;
  @override
  void initState() {
    super.initState();
    website = widget.website;
  }

  @override
  Widget build(BuildContext context) {
    return FxContainer(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.titleSmall("Name: ${website.name}", fontWeight: 600, fontSize: 12, color: Colors.black.withOpacity(0.7),),
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
                child: InkWell(
                  onTap: () async {
                    Uri url = Uri.parse(
                        "https://${website.defaultDomain}");
                    final lc = await canLaunchUrl(url);
                    if (lc) {
                      await launchUrl(url,
                          mode: LaunchMode
                              .externalApplication);
                    } else {
                      print(lc);
                    }
                  },
                  child: FxText.bodySmall(
                    decoration: TextDecoration.underline,
                    website.defaultDomain,
                    color: Constant.softColors.blue.onColor,
                    fontWeight: 600,
                    fontSize: 10,
                  ),
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
                child: InkWell(
                  onTap: () async {
                    if (website.customDomain.isEmpty) return;
                    Uri url = Uri.parse(
                        "https://${website.customDomain}");
                    final lc = await canLaunchUrl(url);
                    if (lc) {
                      await launchUrl(url,
                          mode: LaunchMode
                              .externalApplication);
                    } else {
                      print(lc);
                    }
                  },
                  child: FxText.bodySmall(
                    decoration: (website.customDomain.isEmpty) ? TextDecoration.none: TextDecoration.underline,
                    (website.customDomain.isEmpty) ? "Not Added Yet" : website.customDomain,
                    color: Constant.softColors.blue.onColor,
                    fontWeight: 600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          FxSpacing.height(7),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.1), width: 1,),),
            ),
          ),
        ],
      ),
    );
  }
}


class WebsiteDetail {
  String defaultDomain, name, status, customDomain;
  ColorGroup colorGroup;
  WebsiteDetail(this.defaultDomain, this.name, this.status, this.colorGroup, this.customDomain);


  static WebsiteDetail getWebsiteDetailObject(dynamic row) {
    ColorGroup colorGroup = Constant.softColors.green;

    switch (row['status'].toString().toLowerCase()) {
      case "live":
        colorGroup = Constant.softColors.green;
        break;
      case "offline":
        colorGroup = Constant.softColors.pink;
        break;
      case "waiting":
        colorGroup = Constant.softColors.violet;
        break;
      case "pending":
        colorGroup = Constant.softColors.blue;
        break;
    }

    String x = row['status'].toString();
    row['status'] = x.substring(0, 1).toUpperCase() + x.substring(1, x.length);

    return WebsiteDetail(row['domain1'].toString(), row['site_name'].toString(), row['status'].toString(), colorGroup, row['domain2'].toString());
  }

  static List<WebsiteDetail> getDetailListFromJson(dynamic js) {
    List<WebsiteDetail> ans = [];
    for (var row in js) {
      ans.add(getWebsiteDetailObject(row));
    }
    return ans;
  }
}