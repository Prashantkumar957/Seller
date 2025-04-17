import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/theme/app_theme.dart';

import '../controllers/full_app_controller.dart';

class ShoppingManagerFullApp extends StatefulWidget {
  final int screen;
  const ShoppingManagerFullApp({Key? key, this.screen = 0}) : super(key: key);

  @override
  _ShoppingManagerFullAppState createState() => _ShoppingManagerFullAppState();
}

class _ShoppingManagerFullAppState extends State<ShoppingManagerFullApp>
    with SingleTickerProviderStateMixin {
  late FullAppController controller;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(FullAppController(this, widget.screen));
    theme = AppTheme.shoppingManagerTheme;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FullAppController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (b, d) {
            CoolAlert.show(context: context, type: CoolAlertType.confirm, title: "Do you really want to close $appName ?", showCancelBtn: true, confirmBtnText: "Yes, Exit", cancelBtnText: "No", onConfirmBtnTap: () {
              SystemNavigator.pop();
            });
          },
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: controller.items,
                  ),
                ),
                FxContainer(
                  bordered: true,
                  enableBorderRadius: false,
                  border: Border(
                      top: BorderSide(
                          color: theme.dividerColor,
                          width: 1,
                          style: BorderStyle.solid)),
                  padding: EdgeInsets.only(bottom: 0, top: 8),
                  color: theme.scaffoldBackgroundColor,
                  child: TabBar(
                    controller: controller.tabController,
                    indicator: FxTabIndicator(
                        indicatorColor: theme.colorScheme.primary,
                        indicatorHeight: 3,
                        radius: 3,
                        indicatorStyle: FxTabIndicatorStyle.rectangle,
                        yOffset: -9),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: theme.colorScheme.primary,
                    labelColor: theme.colorScheme.primary,
                    tabs: buildTab(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < controller.navItems.length; i++) {
      bool selected = controller.currentIndex == i;
      tabs.add(
        Column(
          children: [
            Icon(controller.navItems[i].iconData,
                size: (controller.navItems[i].title == 'Home') ? 30 : 25,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onBackground),
            FxSpacing.height(3),
            Text(
              controller.navItems[i].title,
              style: TextStyle(
                fontSize: 8,
              ),
            ),
          ],
        ),
      );
    }
    return tabs;
  }
}
