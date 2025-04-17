import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/views/dummy_screen.dart';
import 'package:seller/views/product_manager/product_manager_screen.dart';
import 'package:seller/views/profile/profile_screen.dart';

import '../views/home_screens/dashboard_screen.dart';

class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class FullAppController extends FxController {
  int currentIndex;
  int pages = 3;
  late TabController tabController;

  final TickerProvider tickerProvider;

  late List<NavItem> navItems;
  late List<Widget> items;

  FullAppController(this.tickerProvider, this.currentIndex) {
    tabController =
        TabController(length: pages, vsync: tickerProvider, initialIndex: currentIndex);

    navItems = [
      NavItem('Dashboard', Icons.dashboard_outlined),
      NavItem('Product', Icons.shopping_basket_outlined),
      // NavItem('Home', Icons.home_outlined),
      // NavItem('Orders', Icons.laptop_chromebook),
      NavItem('Profile', FeatherIcons.user),
    ];

    items = [
      const DashboardScreen(),
      const ProductManagerScreen(),
      // const DummyScreen("Home Screen"),
      // const DummyScreen("Orders Screen"),
      const ProfileScreen(showBackBtn: false,),
    ];
  }

  @override
  void initState() {
    super.initState();
    tabController.addListener(handleTabSelection);

    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
  }

  handleTabSelection() {
    currentIndex = tabController.index;
    update();
  }

  @override
  String getTag() {
    return "shopping_manager_full_app_controller";
  }
}
