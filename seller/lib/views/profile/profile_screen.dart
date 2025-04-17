import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/controllers/profile/profile_controller.dart';
import 'package:seller/database/database.dart';
import 'package:seller/extensions/extensions.dart';
import 'package:seller/spinners.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/views/bank/bank_details.dart';
import 'package:seller/views/client_screens/client_list_screen.dart';
import 'package:seller/views/edit_profile.dart';
import 'package:seller/views/faq_question_screen.dart';
import 'package:seller/views/login_signup/login_screen.dart';
import 'package:seller/views/membership/membership_screen.dart';
import 'package:seller/views/wallet/wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool showUpdateMsg, showBackBtn;

  const ProfileScreen(
      {super.key, this.showUpdateMsg = false, this.showBackBtn = true});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late ProfileController controller;
  late OutlineInputBorder outlineInputBorder;
  late Map<dynamic, dynamic> profileData;
  bool isProfileDataLoaded = false;

  bool bankAccountError = false;

  @override
  void initState() {
    super.initState();
    initProfile();
    initDownloader();
    searchBankAccounts();
    theme = AppTheme.shoppingManagerTheme;
    customTheme = AppTheme.customTheme;
    controller = FxControllerStore.putOrFind(ProfileController());
    outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isProfileDataLoaded)
          ? ListView(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
              children: <Widget>[
                titleRow(),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfile()));
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(profileData['profile_pic']),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        FxSpacing.width(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  FxText.titleMedium(
                                    profileData['name'],
                                    fontWeight: 700,
                                    letterSpacing: 0,
                                  ),
                                  FxSpacing.width(4),
                                  (profileData['verify'].toString() == "1")
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.blue,
                                        )
                                      : const Text(""),
                                ],
                              ),
                              FxText.bodySmall(
                                profileData['email'],
                                fontWeight: 600,
                                letterSpacing: 0.3,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(
                            MdiIcons.chevronRight,
                            color: theme.colorScheme.onBackground,
                          ).autoDirection(),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FxContainer.bordered(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(showBackButton: true,)));
                          },
                          color: Constant.softColors.blue.color,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                MdiIcons.creditCardOutline,
                                color: Constant.softColors.blue.onColor,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: FxText.labelMedium(
                                  "Wallet",
                                  fontWeight: 700,
                                  color: Constant.softColors.blue.onColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FxSpacing.width(20),
                      Expanded(
                        child: FxContainer.bordered(
                          color: Constant.softColors.violet.color,
                          padding: const EdgeInsets.all(16),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MembershipScreen()));
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.card_membership,
                                color: Constant.softColors.violet.onColor,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: FxText.labelMedium(
                                  "Membership",
                                  fontWeight: 600,
                                  color: Constant.softColors.violet.onColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FxContainer.bordered(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ClientListScreen()));
                          },
                          color: Constant.softColors.green.color,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.people_outline,
                                color: Constant.softColors.blue.onColor,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: FxText.labelMedium(
                                  "Clients",
                                  fontWeight: 700,
                                  color: Constant.softColors.blue.onColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FxSpacing.width(20),
                      Expanded(
                        child: FxContainer(color: Colors.transparent,),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxSpacing.height(24),
                    other(),
                    FxSpacing.height(32),
                    account()
                  ],
                ),
              ],
            )
          : Center(
              child: SpinKitWaveSpinner(
                color: Colors.deepPurpleAccent,
                waveColor: Constant.softColors.violet.color,
              ),
            ),
    );
  }

  Widget titleRow() {
    return Row(
      children: [
        ...(widget.showBackBtn)
            ? [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.chevron_left),
                ),
                FxSpacing.width(8),
              ]
            : [],
        FxContainer(
          width: 10,
          height: 24,
          color: theme.colorScheme.primaryContainer,
          borderRadiusAll: 2,
        ),
        FxSpacing.width(8),
        FxText.titleMedium(
          "Profile",
          fontWeight: 600,
        ),
      ],
    );
  }

  Widget statistics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FxContainer(
                paddingAll: 12,
                child: Row(
                  children: [
                    FxContainer(
                        paddingAll: 10,
                        color: Constant.softColors.green.color,
                        child: Icon(
                          Icons.wifi,
                          size: 18,
                          color: Constant.softColors.green.onColor,
                        )),
                    FxSpacing.width(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodySmall(
                          'Client Sites',
                          fontWeight: 600,
                        ),
                        FxSpacing.height(4),
                        FxText.bodyMedium(
                          '114',
                          fontWeight: 600,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            FxSpacing.width(16),
            Expanded(
              child: FxContainer(
                paddingAll: 10,
                child: Row(
                  children: [
                    FxContainer(
                        paddingAll: 10,
                        color: Constant.softColors.blue.color,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                          color: Constant.softColors.blue.onColor,
                        )),
                    FxSpacing.width(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodySmall(
                          'Orders',
                          fontWeight: 600,
                        ),
                        FxSpacing.height(4),
                        FxText.bodyMedium(
                          '284',
                          fontWeight: 600,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        FxSpacing.height(16),
        Row(
          children: [
            Expanded(
              child: FxContainer(
                paddingAll: 12,
                child: Row(
                  children: [
                    FxContainer(
                      paddingAll: 10,
                      color: Constant.softColors.violet.color,
                      child: Icon(
                        Icons.wifi,
                        size: 18,
                        color: Constant.softColors.violet.onColor,
                      ),
                    ),
                    FxSpacing.width(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodySmall(
                          'My Sites',
                          fontWeight: 600,
                        ),
                        FxSpacing.height(4),
                        FxText.bodyMedium(
                          '489',
                          fontWeight: 600,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            FxSpacing.width(16),
            Expanded(child: Container()),
            // Expanded(
            //   child: FxContainer(
            //     paddingAll: 10,
            //     child: Row(
            //       children: [
            //         FxContainer(
            //             paddingAll: 10,
            //             color: Constant.softColors.pink.color,
            //             child: Icon(
            //               Icons.alt_route_outlined,
            //               size: 18,
            //               color: Constant.softColors.pink.onColor,
            //             )),
            //         FxSpacing.width(12),
            //         Row(
            //           children: [
            //             FxText.bodySmall(
            //               'View All',
            //               fontWeight: 600,
            //             ),
            //             FxSpacing.width(4),
            //             const Icon(
            //               FeatherIcons.chevronRight,
            //               size: 16,
            //             )
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          'Shop Status',
          fontWeight: 600,
          muted: true,
        ),
        FxSpacing.height(20),
        Row(
          children: [
            FxContainer(
              onTap: () {
                controller.changeShopStatus(ShopStatus.close);
              },
              color: controller.shopStatus == ShopStatus.close
                  ? theme.colorScheme.primaryContainer
                  : null,
              padding: FxSpacing.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Icon(Icons.work_off_outlined,
                      size: 20,
                      color: controller.shopStatus == ShopStatus.close
                          ? theme.colorScheme.onPrimaryContainer
                          : null),
                  FxSpacing.width(8),
                  FxText.bodySmall("Close",
                      color: controller.shopStatus == ShopStatus.close
                          ? theme.colorScheme.onPrimaryContainer
                          : null)
                ],
              ),
            ),
            FxSpacing.width(16),
            FxContainer(
              onTap: () {
                controller.changeShopStatus(ShopStatus.open);
              },
              color: controller.shopStatus == ShopStatus.open
                  ? theme.colorScheme.primaryContainer
                  : null,
              padding: FxSpacing.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Icon(Icons.work_outline,
                      size: 20,
                      color: controller.shopStatus == ShopStatus.open
                          ? theme.colorScheme.onPrimaryContainer
                          : null),
                  FxSpacing.width(8),
                  FxText.bodySmall("Open",
                      color: controller.shopStatus == ShopStatus.open
                          ? theme.colorScheme.onPrimaryContainer
                          : null)
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget other() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          'Activity',
          fontWeight: 600,
          muted: true,
        ),
        FxSpacing.height(20),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const WalletScreen()));
          },
          child: Row(
            children: [
              FxContainer(
                paddingAll: 8,
                color: Constant.softColors.blue.color,
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 20,
                  color: Constant.softColors.blue.onColor,
                ),
              ),
              FxSpacing.width(16),
              Expanded(child: FxText.bodyMedium('Payments')),
              FxSpacing.width(16),
              Icon(
                FeatherIcons.chevronRight,
                size: 18,
                color: theme.colorScheme.primary,
              )
            ],
          ),
        ),
        FxSpacing.height(20),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BankDetails()));
          },
          child: Row(
            children: [
              FxContainer(
                paddingAll: 8,
                color: Constant.softColors.pink.color,
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 20,
                  color: Constant.softColors.pink.onColor,
                ),
              ),
              FxSpacing.width(16),
              Expanded(
                child: Row(
                  children: [
                    FxText.bodyMedium(
                      'Bank Details',
                    ),
                    FxSpacing.width(10),
                    (bankAccountError)
                        ? Icon(
                            Icons.info_outline,
                            color: Colors.red,
                          )
                        : Text(""),
                  ],
                ),
              ),
              FxSpacing.width(16),
              Icon(
                FeatherIcons.chevronRight,
                size: 18,
                color: theme.colorScheme.primary,
              )
            ],
          ),
        ),
        FxSpacing.height(20),
        InkWell(
          onTap: () async {
            Spinners spn = Spinners(context: context);
            final dir = await getApplicationDocumentsDirectory();

            if (await File(dir.path + guideFileDetails['name']!).exists()) {
              OpenFile.open(dir.path + guideFileDetails['name']!);
            } else {
              await FlutterDownloader.registerCallback(DownloadClass.callback);
              final taskId = await FlutterDownloader.enqueue(
                url: guideFileDetails['url']!,
                headers: {},
                // optional: header send with url (auth token etc)
                savedDir: dir.path,
                showNotification: true,

                // show download progress in status bar (for Android)
                openFileFromNotification: true,
                saveInPublicStorage: true,
                // click on notification to open downloaded file (for Android)
                // fileName: guideFileDetails['name'],
              );
              spn.showAlert("Downloading started",
                  "See the download progress from the notification bar.", CoolAlertType.info);
            }
          },
          child: Row(
            children: [
              FxContainer(
                paddingAll: 8,
                color: Constant.softColors.green.color,
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Constant.softColors.green.onColor,
                ),
              ),
              FxSpacing.width(16),
              Expanded(child: FxText.bodyMedium('App Guide')),
              FxSpacing.width(16),
              const Icon(
                FeatherIcons.chevronRight,
                size: 20,
              )
            ],
          ),
        ),
        FxSpacing.height(20),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FAQQuestionScreen()));
          },
          child: Row(
            children: [
              FxContainer(
                paddingAll: 8,
                color: Constant.softColors.orange.color,
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Constant.softColors.orange.onColor,
                ),
              ),
              FxSpacing.width(16),
              Expanded(child: FxText.bodyMedium('FAQ\'s')),
              FxSpacing.width(16),
              const Icon(
                FeatherIcons.chevronRight,
                size: 20,
              )
            ],
          ),
        ),
        // FxSpacing.height(16),
        // Row(
        //   children: [
        //     FxContainer(
        //       paddingAll: 8,
        //       color: Constant.softColors.orange.color,
        //       child: Icon(
        //         Icons.privacy_tip_outlined,
        //         size: 20,
        //         color: Constant.softColors.orange.onColor,
        //       ),
        //     ),
        //     FxSpacing.width(16),
        //     Expanded(child: FxText.bodyMedium('Privacy')),
        //     FxSpacing.width(16),
        //     Row(
        //       children: [
        //         FxText.bodySmall(
        //           'Action Needed',
        //           color: theme.colorScheme.error,
        //           fontWeight: 600,
        //         ),
        //         FxSpacing.width(4),
        //         Icon(
        //           FeatherIcons.chevronRight,
        //           size: 18,
        //           color: theme.colorScheme.error,
        //         )
        //       ],
        //     )
        //   ],
        // ),
      ],
    );
  }

  Widget account() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FxText.bodySmall(
        //   'My Account',
        //   fontWeight: 600,
        //   xMuted: true,
        // ),
        // FxSpacing.height(8),
        // FxButton.text(
        //   padding: FxSpacing.zero,
        //   onPressed: () {},
        //   child: FxText.bodyMedium(
        //     'Switch to another account',
        //     color: theme.colorScheme.primary,
        //     fontWeight: 600,
        //   ),
        // ),
        FxSpacing.height(20),
        Center(
          child: FxButton(
            backgroundColor: theme.colorScheme.errorContainer,
            elevation: 0,
            borderRadiusAll: Constant.buttonRadius.small,
            onPressed: () async {
              await logout();
            },
            child: FxText(
              'Logout',
              color: theme.colorScheme.onErrorContainer,
              fontWeight: 600,
            ),
          ),
        ),
        FxSpacing.height(40),
      ],
    );
  }

  Future<void> logout() async {
    Spinners spn = Spinners(context: context);
    spn.showSpinner();
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: "SESSION_ID", value: null);
    await storage.write(key: "access_token", value: null);
    await storage.write(key: "validator", value: null);
    Database dbConnection = Database();
    Map<dynamic, dynamic> postBody = {
      "get_session_token": "true",
      "logout": "true",
    };
    final res = await dbConnection.getData(postBody);
    // print(res);
    spn.hideSpinner();
    if (res['status'] == 200) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
  }

  Future<void> loadFromLocal() async {
    AndroidOptions a() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    var s = FlutterSecureStorage(aOptions: a());
    final res = await s.read(key: 'user_data');
    if (res != null) {
      if (mounted) {
        setState(() {
          profileData = jsonDecode(res);
          if (widget.showUpdateMsg) {
            Spinners spn = Spinners(context: context);
            spn.showAlert("Success", "Profile has been updated", CoolAlertType.success);
          }
          print(jsonDecode(res));
          isProfileDataLoaded = true;
        });
      }
    }
  }

  Future<void> initProfile() async {
    loadFromLocal();
  }

  Future<void> searchBankAccounts() async {
    AndroidOptions a() => AndroidOptions(encryptedSharedPreferences: true);
    var st = FlutterSecureStorage(aOptions: a());
    final res = await st.read(key: "bank_accounts");
    if (res != null) {
      var data = jsonDecode(res);
      int x = 0;
      for (var r in data) {
        x++;
      }
      if (x == 0) {
        setState(() {
          bankAccountError = true;
        });
      }
    }
  }

  Future<void> initDownloader() async {
    if (!FlutterDownloader.initialized) {
      await FlutterDownloader.initialize(
          debug: true,
          // optional: set to false to disable printing logs to console (default: true)
          ignoreSsl:
              true // option: set to false to disable working with http links (default: false)
          );
    }
  }
}

class DownloadClass {
  static void callback(String id, int status, int dp) {
    print("Status $status");
    print("Progress $dp");
  }
}
