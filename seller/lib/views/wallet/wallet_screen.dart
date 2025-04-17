import 'package:cool_alert/cool_alert.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/database/database.dart';
import 'package:seller/spinners.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/views/wallet/request_withdraw.dart';

import '../../app_constants.dart';
import '../../controllers/wallet_controller.dart';
import '../../models/coin.dart';

class WalletScreen extends StatefulWidget {
  final bool showBackButton;
  const WalletScreen({this.showBackButton = false, super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late ThemeData theme;
  late WalletController controller;
  String loadingTransaction = "Loading Transactions..";
  bool isTransactionsLoaded = false;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(WalletController());
    initData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<WalletController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: FxSpacing.fromLTRB(
                  15, FxSpacing.safeAreaTop(context) + 20, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (!isTransactionsLoaded)
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: SpinKitCircle(
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : const SizedBox.shrink(),
                  balance(),
                  FxSpacing.height(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.titleMedium(
                        "Balance",
                        fontWeight: 700,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FxSpacing.width(5),
                          FxContainer(
                            paddingAll: 8,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RequestWithdraw()));
                            },
                            color: theme.colorScheme.primaryContainer,
                            child: FxText.bodySmall(
                              '+Request',
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: 700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  FxSpacing.height(20),
                  coinsGrid(),
                  FxSpacing.height(20),
                  FxText.titleMedium(
                    "Transaction History",
                    fontWeight: 700,
                  ),
                  FxSpacing.height(20),
                  transactionList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ...(widget.showBackButton) ? [InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                CupertinoIcons.back,
                size: 16,
              ),
            ),
              FxSpacing.width(5),
            ] : [],
            FxContainer(
              width: 10,
              height: 24,
              color: theme.colorScheme.primaryContainer,
              borderRadiusAll: 2,
            ),
            FxSpacing.width(12),
            FxText.titleMedium(
              "Transaction History",
              fontWeight: 600,
            ),
          ],
        ),
        // FxSpacing.width(12),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FxContainer.roundBordered(
        //       onTap: () {},
        //       paddingAll: 8,
        //       color: theme.scaffoldBackgroundColor,
        //       child: const Icon(
        //         FeatherIcons.bell,
        //         size: 20,
        //       ),
        //     ),
        //   ],
        // ),
        // FxSpacing.width(10),
      ],
    );
  }

  Widget balance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleRow(),
            FxSpacing.height(12),
            Row(
              children: [
                FxText.titleLarge(
                  "Total: $rupee ${(ebanking + ewallet < 0) ? "----" : (ebanking + ewallet).toStringAsFixed(2)}",
                  fontWeight: 700,
                ),
              ],
            ),
            // FxText.titleSmall(
            //   "3.56%",
            //   color: theme.colorScheme.primary,
            //   fontWeight: 600,
            // ),
          ],
        ),
      ],
    );
  }

  Widget coinsGrid() {
    return GridView.builder(
      padding: FxSpacing.zero,
      shrinkWrap: true,
      itemCount: controller.coins.length,
      physics: const ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: controller.findAspectRatio(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return singleCoin(controller.coins[index]);
      },
    );
  }

  Widget singleCoin(Coin coin) {
    return Stack(
      children: [
        FxContainer(
          height: 170.0,
          width: double.maxFinite,
          onTap: () {
            // controller.goToSingleCoinScreen(coin);
          },
          paddingAll: 12,
          borderRadiusAll: Constant.containerRadius.xs,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                height: 32,
                width: 32,
                image: AssetImage(coin.image),
              ),
              FxSpacing.height(12),
              FxText.bodySmall(
                coin.name.toUpperCase(),
                fontWeight: 700,
              ),
              FxSpacing.height(2),
              FxText.bodySmall(
                (coin.price == -1) ? "-----" : (coin.price.toStringAsFixed(2)),
                xMuted: true,
                fontSize: 14,
              ),
            ],
          ),
        ),
        coin.tooltip,
      ],
    );
  }

  Widget transactionList() {
    return (isTransactionsLoaded)
        ? ((controller.transactions.isEmpty)
            ? const Center(child: Text("No transaction found."))
            : Column(
                children: [
                  ...getTransactions(),
                ],
              ))
        : Center(child: Text(loadingTransaction));
  }

  Future<void> initData(BuildContext context) async {
    Database dbConnection = Database();
    Spinners spn = Spinners(context: context);

    Map<dynamic, dynamic> postBody = {
      "module": "payment",
      "submodule": "utils",
      "functions":
          "ebanking,ewallet,income,expenditure,pending_request,transaction_history",
    };

    final res = await dbConnection.getData(postBody);
    if (res['status'] == 200) {
      if (mounted) {
        setState(() {
          ebanking = double.parse(res['data']['ebanking']['total'].toString());
          availableEbanking =
              double.parse(res['data']['ebanking']['available'].toString());
          ewallet =
              double.parse(res['data']['ewallet']['available'].toString());
          pendingRequest =
              double.parse(res['data']['pending_request']['amount'].toString());
          totalExpenditure =
              double.parse(res['data']['expenditure']['amount'].toString());
          totalIncome =
              double.parse(res['data']['income']['amount'].toString());

          controller.coins = [
            Coin(
              "Current E-Cash",
              eBankingImage,
              "THR",
              ebanking,
              DateTime.timestamp(),
              tooltip: Positioned(
                right: 3,
                child: ElTooltip(
                  color: theme.colorScheme.primaryContainer,
                  position: ElTooltipPosition.topStart,
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 16,
                  ),
                  content: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "Traditional cash earned through business orders, commissions, or other earning opportunities via our platform.",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Coin(
              "Available E-Cash",
              eBankingImage,
              "THR",
              availableEbanking,
              DateTime.timestamp(),
              tooltip: Positioned(
                right: 3,
                child: ElTooltip(
                  position: ElTooltipPosition.topEnd,
                  color: theme.colorScheme.primaryContainer,
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 16,
                  ),
                  content: Container(
                    width: 400,
                    child: Text(
                      "Traditional cash earned through business orders, commissions, or other earning opportunities via our platform.",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Coin("Pending Request", pendingImage, "THR", pendingRequest,
                DateTime.timestamp()),
            Coin(
              "E-Wallet",
              eWalletImage,
              "THR",
              ewallet,
              DateTime.timestamp(),
              tooltip: Positioned(
                right: 3,
                child: ElTooltip(
                  position: ElTooltipPosition.topStart,
                  color: theme.colorScheme.primaryContainer,
                  content: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "A digital wallet that includes credit points, cashback, coupons, vouchers, and more.",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
              ),
            ),
            Coin("Total Income", incomeImage, "THR", totalIncome,
                DateTime.timestamp()),
            Coin("Total Expenditure", expenditureImage, "THR", totalExpenditure,
                DateTime.timestamp()),
          ];

          List<Transaction> tsc = [];
          for (var row in res['data']['transaction_history']['data']) {
            tsc.add(Transaction(
                minString(row['description']),
                DateTime.parse(row['date'].toString()),
                row['image'],
                row['transact_from'],
                double.parse(row['amount'].toString()),
                row['nature'].toString()));
          }
          isTransactionsLoaded = true;
          controller.transactions = tsc;
        });
      }
    } else {
      spn.showAlert("Error",
          "Can not retrieve wallet information at the moment.", CoolAlertType.error);
    }
  }

  String beautifyNumber(double n) {
    String sign = "";
    if (n < 0) {
      n *= -1;
      sign = "-";
    }

    String ans = "";
    int cn = n.toInt(), commas = 0, firstComma = 0;
    String decimal = (n - cn).toString();
    // print(decimal);
    int i = 0;
    while (decimal[i] != ".") {
      i++;
    }

    decimal = decimal.substring(i + 1, decimal.length);
    // print(decimal);

    while (cn > 0) {
      int d = cn % 10;
      String c = "";
      if (firstComma == 3 || (firstComma == -1 && commas % 2 == 0)) {
        c = ",";
        firstComma = -1;
      }

      ans = "$d$c$ans";

      if (firstComma != -1) {
        firstComma++;
      }

      if (firstComma == -1) {
        commas++;
      }

      cn = cn ~/ 10;
    }

    if (ans.isEmpty) ans = "0";

    return "$sign$ans.$decimal";
  }

  String minString(String row, {int len = 25}) {
    String ans = row;
    if (row.length > len) {
      ans = "${row.substring(0, len - 2)}...";
    }
    return ans;
  }

  List<Widget> getTransactions() {
    List<Widget> ans = [];
    for (var transaction in controller.transactions) {
      ans.add(
        Row(
          children: [
            Image(
              height: 32,
              width: 32,
              image: transaction.image,
              errorBuilder: (BuildContext context, Object e, StackTrace? stk) {
                return const Image(
                  image: AssetImage(reloadImage),
                  height: 32,
                  width: 32,
                );
              },
            ),
            FxSpacing.width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodySmall(
                    transaction.title.toUpperCase(),
                    fontWeight: 700,
                    color: transaction.textColor,
                  ),
                  FxText.bodySmall(
                    "${transaction.dateTime.day}/${transaction.dateTime.month}/${transaction.dateTime.year}",
                    fontSize: 10,
                  ),
                ],
              ),
            ),
            FxSpacing.width(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FxText.bodySmall(
                  transaction.amountString,
                  fontWeight: 600,
                  fontSize: 14,
                  color: transaction.textColor,
                ),
                Image(
                  image: transaction.transactFrom,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      );
      ans.add(const Divider(
        height: 28,
      ));
    }
    return ans;
  }
}
