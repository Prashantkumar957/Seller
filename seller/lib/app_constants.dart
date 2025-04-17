const bool liveModeEnabled = false;

const String appName = "Seller App",
    appTitle = "Seller App",
    baseUrl = "https://1jammu.in/${(liveModeEnabled) ? "android_live" : "android"}/",
    appId = "5",
    reloadImage = "assets/placeholder/reload.png",
    placeholderImage = "assets/placeholder/loadingImage.gif",
    logoPlaceholderImage = "assets/placeholder/pending.png",
    rupee = "\u{20B9}",
    rs = "\u{20B9}",
    eWalletImage = "assets/placeholder/ewallet.png",
    eBankingImage = "assets/placeholder/ebanking.png",
    razorpayImage = "assets/placeholder/upi.png",
    avatarImage = "assets/images/profile/avatar_place.png",
    incomeImage = "assets/placeholder/income.png",
    expenditureImage = "assets/placeholder/expenditure.png",
    pendingImage = "assets/placeholder/pending.png",
    siteDomain = "wlai.org",
    vendorType = "5",
    marketplaceId = "5",
    productsMarketplaceId = "5",
    membershipMarketplaceId = "37",
    chatBotName = "Jamura",
    chatBotIcon = 'assets/placeholder/chatbot.png',
    razorpayTestKey = "rzp_test_pi2fEEfhC66GKs",
    siteName = "Wlai",
    proposalMarketplace = "49";

Map<String, String> guideFileDetails = {
  "url": "https://1jammu.in/android/guide.pdf",
  "name": "AppGuide.pdf",
  "extension": "pdf",
};

const List<int> doNotShowStockInfoInMarketplaces = [16];

Map<dynamic, dynamic> bankIcons = {
  "PUNB": "assets/placeholder/bank_logo/pnb.png",
  "PNB": "assets/placeholder/bank_logo/pnb.png",
  "SBIN": "assets/placeholder/bank_logo/sbin.png",
  "SBI": "assets/placeholder/bank_logo/sbin.png",
  "ICICI": "assets/placeholder/bank_logo/icici.png",
  "AXIS": "assets/placeholder/bank_logo/axis.png",
  "BOI": "assets/placeholder/bank_logo/boi.jpg",
  "CANARA": "assets/placeholder/bank_logo/canara.png",
  "KOTAK": "assets/placeholder/bank_logo/kotak.png",
  "NKMB": "assets/placeholder/bank_logo/kotak.png",
  "YES": "assets/placeholder/bank_logo/yes.png",
  "UNI": "assets/placeholder/bank_logo/uni.png",
};
