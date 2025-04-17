class BankDetailTile {
  bool isDefault, showDummyIcon;
  String accountNumber, accountHolder, bankName, ifsc, iconUrl;
  Map<dynamic, dynamic> allDetails;
  BankDetailTile(this.accountNumber, this.accountHolder, this.bankName,
      this.ifsc, this.isDefault, {this.iconUrl = "", this.showDummyIcon  = true, this.allDetails = const {}});
}
