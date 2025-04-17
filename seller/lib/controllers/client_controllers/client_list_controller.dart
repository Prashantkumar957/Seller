import 'dart:async';

import 'package:flutx/flutx.dart';
import 'package:seller/models/contact_tile.dart';

class ClientListController extends FxController {

  List<ContactTile> clients = [];
  bool isClientListLoaded = false;

  @override
  void initState() {
    super.initState();
    loadClients();
  }


  Future<void> loadClients() async {
    clients = await ClientDataLoader.getClientDataList();
    isClientListLoaded = true;
    update();
  }



  @override
  String getTag() {
    return "Client List Controller";
  }
}