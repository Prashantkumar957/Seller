import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import '../models/coin.dart';

double availableEbanking = -1, ewallet = -1, ebanking = -1, totalIncome = -1, totalExpenditure = -1, pendingRequest = -1;

class WalletController extends FxController {
  /*
  {
    "name" : "Tether",
    "image" : "assets/images/full_apps/nft/icons/tether.png",
    "code" : "THR",
    "price" : 74.48,
    "price_change" : -0.18,
    "percent_change" : -0.24,
    "date" : "2022-01-29T05:23:56.292678Z"
  }
   */

  List<Coin> coins = [
    Coin("Current E-Cash", eBankingImage, "THR", ebanking, DateTime.timestamp(), tooltip: Positioned(
      right: 3,
      child: ElTooltip(
        position: ElTooltipPosition.topStart,
        color: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.info_outline,
          color: Colors.grey,
          size: 16,
        ),
        content: Container(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            "Traditional cash earned through business orders, commissions, or other earning opportunities via our platform.",
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    ),),
    Coin("Available E-Cash", eBankingImage, "THR", availableEbanking,
        DateTime.timestamp(), tooltip: Positioned(
        right: 3,
        child: ElTooltip(
          color: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 16,
          ),
          content: Container(
            padding: EdgeInsets.only(left: 40),
            child: Container(
              padding: EdgeInsets.only(left: 40),
              child: Text(
                "Traditional cash earned through business orders, commissions, or other earning opportunities via our platform.",
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),),
    Coin("Pending Request", pendingImage, "THR", pendingRequest, DateTime.timestamp()),
    Coin("E-Wallet", eWalletImage, "THR", ewallet, DateTime.timestamp(), tooltip: Positioned(
      right: 3,
      child: ElTooltip(
        color: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.info_outline,
          color: Colors.grey,
          size: 16,
        ),
        content: Text(
          "A digital wallet that includes credit points, cashback, coupons, vouchers, and more.",
          style: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    ),),
    Coin("Total Income", incomeImage, "THR", totalIncome, DateTime.timestamp()),
    Coin("Total Expenditure", expenditureImage, "THR", totalExpenditure,
        DateTime.timestamp()),
  ];

  List<Transaction> transactions = [];

  double findAspectRatio() {
    double width = MediaQuery.of(context).size.width;
    return ((width - 72) / 3) / (133);
  }

  void goToSingleCoinScreen(Coin coin) {
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(
    //     builder: (context) => SingleCoinScreen(coin: coin),
    //   ),
    // );
  }

  @override
  String getTag() {
    return "home_controller";
  }
}

class Transaction {
  String title;
  DateTime dateTime;
  late ImageProvider image, transactFrom;
  late String amountString;
  double amount;
  Color textColor = Colors.black;
  String nature;
  Transaction(this.title, this.dateTime, String image, String transactFrom,
      this.amount, this.nature) {
    amountString = amount.toString();
    switch (nature.toUpperCase()) {
      case 'CREDIT' :
        amountString = "+$rupee $amountString";
        textColor = Colors.green;
        break;
      case 'DEBIT' :
        amountString = "-$rupee $amountString";
        textColor = Colors.red;
        break;
      case 'REQUEST':
        amountString = "$rupee $amountString";
        textColor = Colors.blue;
        break;
      case 'EXPIRED':
        amountString = "$rupee $amountString";
        textColor = Colors.black38;
        break;
      default:
        amountString = "$rupee $amountString";
    }

    this.image = NetworkImage(image);
    switch (transactFrom.toUpperCase()) {
      case "E-WALLET":
        this.transactFrom = const AssetImage(eWalletImage);
        break;
      case "E-BANKING":
        this.transactFrom = const AssetImage(eBankingImage);
        break;
      case "RAZORPAY":
        this.transactFrom = const AssetImage(razorpayImage);
        break;
      default:
        this.transactFrom = const AssetImage(eWalletImage);
    }
  }
}
