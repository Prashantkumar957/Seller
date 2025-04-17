import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/views/profile/profile_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:seller/database/database.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/widgets/syncfusion/data/charts_sample_data.dart';

import '../../app_constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../membership/membership_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showRefreshLoader = true;
  late ThemeData theme;
  late DashboardController controller;
  late OutlineInputBorder outlineInputBorder;
  late String totalCustomers, newCustomers, totalIncome, newIncome;
  late List<Widget> refreshLoader;
  late int totalSelfSites, liveSelfSites, totalClientSites, liveClientSites;

  bool isPremiumMember = false;

  @override
  void initState() {
    super.initState();
    initPremiumMember();
    initRefreshLoader();
    totalCustomers = newCustomers = totalIncome = newIncome = "---";
    totalClientSites = totalSelfSites = liveClientSites = liveSelfSites = 0;

    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(DashboardController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );
    initDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<DashboardController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.titleLarge(
                        "Dashboard",
                        fontWeight: 600,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MembershipScreen()));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          FxSpacing.width(10),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileScreen()));
                            },
                            child: const Icon(FeatherIcons.user),
                          ),
                          FxSpacing.width(10),
                          Stack(
                            children: [
                              FxContainer.rounded(
                                padding: const EdgeInsets.all(7),
                                color: Constant.softColors.violet.color,
                                child: const Icon(
                                  Icons.notifications_none_outlined,
                                ),
                              ),
                              const Positioned(
                                top: -3,
                                right: 5,
                                child: FxContainer.rounded(
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.all(5),
                                  color: Colors.red,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  (showRefreshLoader)
                      ? FxSpacing.height(16)
                      : SizedBox.shrink(),
                  ...((showRefreshLoader) ? refreshLoader : []),
                  // alert(),
                  // FxSpacing.height(16),
                  (isPremiumMember == false)
                      ? Column(
                          children: [
                            FxSpacing.height(16),
                            purchaseMembership(),
                            FxSpacing.height(16),
                          ],
                        )
                      : const SizedBox.shrink(),
                  // buildWebsiteButton(),
                  // FxSpacing.height(10),
                  FxContainer(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Want to expand your business ?\nIntegrate modules in your website",
                            ),
                          ),
                          FxSpacing.width(10),
                          FxContainer.bordered(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Modules()));
                            },
                            color: Constant.softColors.violet.color,
                            child: Text(
                              "View Modules",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FxSpacing.height(10),
                  overview(),
                  FxSpacing.height(20),
                  statistics(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget alert() {
    return FxContainer(
      color: Constant.softColors.green.color,
      child: Row(
        children: [
          FxText.bodySmall(
            'Alert: ',
            color: Constant.softColors.green.onColor,
            fontWeight: 700,
          ),
          FxText.bodySmall(
            'Your shop is approved for outside delivery',
            color: Constant.softColors.green.onColor,
            fontWeight: 600,
            fontSize: 11,
          )
        ],
      ),
    );
  }

  Widget timeFilter() {
    return PopupMenuButton(
      color: theme.colorScheme.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.containerRadius.small)),
      elevation: 1,
      child: FxContainer.bordered(
          paddingAll: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FxText.bodySmall(
                controller.time,
              ),
              FxSpacing.width(8),
              const Icon(
                FeatherIcons.chevronDown,
                size: 14,
              )
            ],
          )),
      itemBuilder: (BuildContext context) => [
        ...controller.filterTime.map((time) => PopupMenuItem(
            onTap: () {
              controller.changeFilter(time);
            },
            padding: FxSpacing.x(16),
            height: 36,
            child: FxText.bodyMedium(time)))
      ],
    );
  }

  Widget overview() {
    return Column(
      children: [
        FxContainer(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FxContainer(
                        width: 10,
                        height: 20,
                        color: theme.colorScheme.primaryContainer,
                        borderRadiusAll: 2,
                      ),
                      FxSpacing.width(8),
                      FxText.titleSmall(
                        "Overview",
                        fontWeight: 600,
                      ),
                    ],
                  ),
                  // timeFilter()
                ],
              ),
              FxSpacing.height(20),
              status()
            ],
          ),
        ),
      ],
    );
  }

  Widget status() {
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FxContainer.bordered(
                  color: theme.colorScheme.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodySmall(
                        'Customers',
                        fontWeight: 600,
                        muted: true,
                      ),
                      FxSpacing.height(8),
                      FxText.titleLarge(
                        totalCustomers,
                        fontWeight: 700,
                      ),
                      FxSpacing.height(8),
                      FxContainer(
                          borderRadiusAll: Constant.containerRadius.small,
                          paddingAll: 6,
                          color: theme.colorScheme.primaryContainer,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FeatherIcons.arrowUp,
                                size: 12,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              FxSpacing.width(2),
                              FxText.bodySmall(
                                newCustomers,
                                color: theme.colorScheme.onPrimaryContainer,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              FxSpacing.width(20),
              Expanded(
                child: FxContainer(
                  color: theme.colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodySmall(
                        'Income',
                        fontWeight: 600,
                        muted: true,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      FxSpacing.height(8),
                      FxText.titleLarge(
                        "$rupee$totalIncome",
                        fontWeight: 700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      FxSpacing.height(8),
                      FxContainer(
                          borderRadiusAll: Constant.containerRadius.small,
                          paddingAll: 6,
                          color: theme.colorScheme.errorContainer,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FeatherIcons.arrowUp,
                                size: 12,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                              FxSpacing.width(2),
                              FxText.bodySmall(
                                newIncome,
                                fontWeight: 600,
                                color: theme.colorScheme.onErrorContainer,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          FxSpacing.height(10),
          Row(
            children: [
              Expanded(
                child: FxContainer.bordered(
                  color: theme.colorScheme.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.titleMedium(
                        'Client Sites',
                        fontWeight: 700,
                      ),
                      FxSpacing.height(8),
                      FxText.titleSmall(
                        '$liveClientSites/$totalClientSites',
                        fontWeight: 700,
                      ),
                      FxSpacing.height(12),
                      FxText.bodySmall(
                        'Live',
                        fontWeight: 600,
                        muted: true,
                      ),
                      FxSpacing.height(6),
                      FxProgressBar(
                        width: 140,
                        inactiveColor: Constant.softColors.green.color,
                        activeColor: Constant.softColors.green.onColor,
                        height: 4,
                        progress: (totalClientSites > 0)
                            ? (liveClientSites / totalClientSites)
                            : 0,
                      ),
                    ],
                  ),
                ),
              ),
              FxSpacing.width(20),
              Expanded(
                child: FxContainer.bordered(
                  color: theme.colorScheme.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.titleMedium(
                        'Self Sites',
                        fontWeight: 700,
                      ),
                      FxSpacing.height(8),
                      FxText.titleSmall(
                        '$liveSelfSites/$totalSelfSites',
                        fontWeight: 700,
                      ),
                      FxSpacing.height(12),
                      FxText.bodySmall(
                        'Live',
                        fontWeight: 600,
                        muted: true,
                      ),
                      FxSpacing.height(6),
                      FxProgressBar(
                        width: 140,
                        inactiveColor: theme.colorScheme.secondaryContainer,
                        activeColor: theme.colorScheme.onSecondaryContainer,
                        height: 4,
                        progress: (totalSelfSites > 0)
                            ? (liveSelfSites / totalSelfSites)
                            : 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statistics() {
    return FxContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FxContainer(
                    width: 10,
                    height: 20,
                    color: theme.colorScheme.primaryContainer,
                    borderRadiusAll: 2,
                  ),
                  FxSpacing.width(8),
                  FxText.titleSmall(
                    "Sales Status",
                    fontWeight: 600,
                  ),
                ],
              ),
              timeFilter()
            ],
          ),
          FxSpacing.height(20),
          salesStatusChart()
        ],
      ),
    );
  }

  SfCartesianChart salesStatusChart() {
    return SfCartesianChart(
      margin: EdgeInsets.zero,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(
          width: 0,
          color: Colors.transparent,
        ),
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0, color: Colors.transparent),
          labelFormat: '{value}',
          majorTickLines:
              const MajorTickLines(size: 4, color: Colors.transparent)),
      series: _getDefaultColumnSeries(),
      tooltipBehavior: controller.tooltipBehavior,
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: controller.chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        width: 0.5,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constant.containerRadius.xs)),
        dataLabelSettings: const DataLabelSettings(
            isVisible: false, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }

  Future<void> initDashboard() async {
    loadDefaultData();

    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "module": "dashboard",
      "init_dashboard": "true",
      "marketplace": marketplaceId,
    };

    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      AndroidOptions options() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      final st = FlutterSecureStorage(aOptions: options());
      await st.write(key: "init_dashboard", value: jsonEncode(res));
      if (mounted) {
        setState(() {
          showRefreshLoader = false;
        });
      }
      fillDashboard(res);
    }
  }

  Future<void> loadDefaultData() async {
    AndroidOptions options() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );

    final storage = FlutterSecureStorage(aOptions: options());
    final data = await storage.read(key: "init_dashboard");

    if (data != null) {
      var res = jsonDecode(data);
      if (res != null) {
        fillDashboard(res);
      }
    }
  }

  void fillDashboard(res) {
    if (mounted &&
        res.containsKey("clients") &&
        res.containsKey("income") &&
        res.containsKey("sites") &&
        res.containsKey("stats")) {
      setState(() {
        totalCustomers = res['clients']['total'].toString();
        if (res['clients']['total'] > 0) {
          newCustomers =
              "${(double.parse(res['clients']['new'].toString()) * 100 / double.parse(res['clients']['total'].toString())).ceil()}%";
        } else {
          newCustomers = "0%";
        }

        totalIncome =
            double.parse(res['income']['total'].toString()).toStringAsFixed(2);
        if (double.parse(totalIncome) > 0) {
          newIncome =
              "${(double.parse(res['income']['new'].toString()) * 100 / double.parse(totalIncome)).ceil()}%";
        } else {
          newIncome = "0%";
        }

        totalClientSites = res['sites']['client']['total'];
        liveClientSites = res['sites']['client']['live'];
        totalSelfSites = res['sites']['self']['total'];
        liveSelfSites = res['sites']['self']['live'];

        setState(() {
          isPremiumMember = (res['premium_member'] == "yes");
        });

        if (res['stats'].containsKey("all_time")) {
          List<ChartSampleData> ls = [];
          int i = 0;
          for (var row in res['stats']['all_time']) {
            ls.add(ChartSampleData(
              x: row['year'].toString(),
              y: num.parse(row['total'].toString()),
              pointColor: controller.chartColorList[i % 3],
            ));

            i++;
          }

          controller.allTime = ls;
        }

        if (res['stats'].containsKey("yearly")) {
          List<ChartSampleData> ls = [];
          int i = 0;
          for (var row in res['stats']['yearly']) {
            ls.add(ChartSampleData(
              x: row['year'].toString(),
              y: num.parse(row['total'].toString()),
              pointColor: controller.chartColorList[i % 3],
            ));

            i++;
          }

          controller.yearly = ls;
        }

        if (res['stats'].containsKey("monthly")) {
          List<ChartSampleData> ls = [];
          int i = 0;
          for (var row in res['stats']['monthly']) {
            ls.add(ChartSampleData(
              x: row['month'].toString(),
              y: num.parse(row['total'].toString()),
              pointColor: controller.chartColorList[i % 3],
            ));
            i++;
          }

          controller.monthly = ls;
        }

        if (res['stats'].containsKey("weekly")) {
          List<ChartSampleData> ls = [];
          int i = 0;
          for (var row in res['stats']['weekly']) {
            ls.add(ChartSampleData(
              x: row['day'].toString(),
              y: num.parse(row['total'].toString()),
              pointColor: controller.chartColorList[i % 3],
            ));
            i++;
          }

          controller.thisWeek = ls;
        }

        controller.changeFilter("All time");
      });
    }
  }

  void initRefreshLoader() {
    Duration d = const Duration(seconds: 5);
    setState(() {
      refreshLoader = [
        AnimatedOpacity(
          duration: d,
          opacity: (showRefreshLoader) ? 1.0 : 0.0,
          child: Center(
            child: SpinKitWaveSpinner(
              color: Colors.deepPurpleAccent,
              waveColor: Constant.softColors.violet.color,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: d,
          opacity: (showRefreshLoader) ? 1.0 : 0.0,
          child: FxSpacing.height(4),
        ),
        AnimatedOpacity(
          duration: d,
          opacity: (showRefreshLoader) ? 1.0 : 0.0,
          child: const Center(
            child: Text(
              "Refreshing data ...",
            ),
          ),
        ),
        AnimatedOpacity(
          duration: d,
          opacity: (showRefreshLoader) ? 1.0 : 0.0,
          child: FxSpacing.height(16),
        ),
      ];
    });
  }

  Widget purchaseMembership() {
    return FxContainer.bordered(
      borderColor: Colors.deepPurpleAccent,
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(25),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FxText.titleMedium(
              "Upgrade your plan to Premium",
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
                wordSpacing: 2,
                fontSize: 12,
              ),
            ),
          ),
          // FxSpacing.width(30),
          InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const MembershipScreen()));
            },
            child: FxContainer.bordered(
              color: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              borderRadius: BorderRadius.circular(25),
              child: const Text(
                "Upgrade",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initPremiumMember() async {
    AndroidOptions a() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    var s = const FlutterSecureStorage();
    final r = await s.read(key: 'premium_member');

    if (r != null) {
      if (r.toString().toLowerCase() == "yes") {
        if (mounted) {
          setState(() {
            isPremiumMember = true;
          });
        }
      }
    }


  }

  buildWebsiteButton() {
    return FxContainer(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Flexible(
              child: Text(
                "Build your site in less than 2 minutes",
              ),
            ),
            FxSpacing.width(10),
            FxContainer.bordered(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20,
                ),
              ),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SiteTypeInputScreen()));
              },
              color: Constant.softColors.violet.color,
              child: Text(
                "Build Now",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
