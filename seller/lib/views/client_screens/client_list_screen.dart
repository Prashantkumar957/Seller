import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/controllers/client_controllers/client_list_controller.dart';
import 'package:seller/models/ContactTileStateful.dart';
import 'package:seller/theme/app_theme.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}



class _ClientListScreenState extends State<ClientListScreen> {

  late ClientListController controller;
  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(ClientListController());
    outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ClientListController>(controller: controller, theme: theme, builder: (controller) {



      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: FxSpacing.fromLTRB(
                10, FxSpacing.safeAreaTop(context) + 12, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleRow(),
                FxSpacing.height(16),
                search(),
                FxSpacing.height(15),
                ...(controller.isClientListLoaded) ? clientList() : [ContactTileStateful.getLoadingUI(context, itemCount: 6)],
              ],
            ),
          ),
        ),
      );
    });
  }


  List<Widget> clientList() {
    List<Widget> ls = [];
    for (var cl in controller.clients) {
      ls.add(ContactTileStateful(cl));
    }
    return ls;
  }


  Widget titleRow() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 14,
          ),
        ),
        FxSpacing.width(10),
        FxContainer(
          width: 10,
          height: 24,
          color: theme.colorScheme.primaryContainer,
          borderRadiusAll: 2,
        ),
        FxSpacing.width(8),
        FxText.titleMedium(
          "Clients",
          fontWeight: 600,
        ),
      ],
    );
  }

  Widget search() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      cursorColor: theme.colorScheme.primary,
      decoration: InputDecoration(
        hintText: "Search...",
        hintStyle: FxTextStyle.bodySmall(color: theme.colorScheme.onBackground),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        filled: true,
        fillColor: theme.cardTheme.color,
        prefixIcon: Icon(
          FeatherIcons.search,
          size: 16,
          color: theme.colorScheme.outline,
        ),
        isDense: true,
      ),
      // controller: controller.searchTE,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (v) {

      },
      onFieldSubmitted: (String? keyword) async {
        if (keyword == null) return;
        if (keyword.length < 3) {

          return;
        }
      },
    );
  }

}