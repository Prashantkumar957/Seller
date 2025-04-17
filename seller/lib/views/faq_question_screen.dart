import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seller/database/database.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/theme/constant.dart';

class FAQQuestionScreen extends StatefulWidget {
  @override
  _FAQQuestionScreenState createState() => _FAQQuestionScreenState();
}

class _FAQQuestionScreenState extends State<FAQQuestionScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  String adminEmail = "";

  bool dataLoaded = false;
  List<FAQ> faqs = [];
  List<bool> dataExpansionPanel = [];

  @override
  initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;

    loadFaq();
    loadAdminEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            FeatherIcons.chevronLeft,
            size: 20,
          ),
        ),
        title: FxText.titleMedium("FAQ", fontWeight: 600),
      ),
      body: (dataLoaded)
          ? ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: <Widget>[
                ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      dataExpansionPanel[index] = !isExpanded;
                    });
                  },
                  dividerColor: Colors.white,
                  animationDuration: Duration(milliseconds: 500),
                  children: loadFaqList(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        final Email email = Email(
                          body: '',
                          subject: '',
                          recipients: [adminEmail],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(email);
                      },
                      child: FxText.bodyLarge("Contact us",
                          color: theme.colorScheme.primary, fontWeight: 600),
                    ),
                  ),
                )
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

  void setData(data) {
    List<FAQ> content = [];
    List<bool> exp = [];
    for (var row in data) {
      exp.add(false);
      content.add(FAQ(row['question'], row['answer']));
    }

    setState(() {
      faqs = content;
      dataExpansionPanel = exp;
      dataLoaded = true;
    });
  }

  AndroidOptions androidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  Future<void> loadFromLocal() async {
    final st = FlutterSecureStorage(aOptions: androidOptions());
    final data = await st.read(key: 'faqs');

    if (data != null) {
      setData(jsonDecode(data));
    }
  }

  void loadFaq() async {
    loadFromLocal();
    Database db = Database();
    Map<String, dynamic> postBody = {
      "module": "faq",
      "get_faq": "true",
    };

    final data = await db.getData(postBody);
    if (data['status'] == 200) {

      final st = FlutterSecureStorage(aOptions: androidOptions());

      if (mounted) {
        setData(data['data']);
      }

      await st.write(key: 'faqs', value: jsonEncode(data['data']));
    } else {
      if (mounted) {
        CoolAlert.show(context: context, type: CoolAlertType.error, title: "Error", text: "Something went wrong",);
      }
    }
  }

  List<ExpansionPanel> loadFaqList() {
    List<ExpansionPanel> ans = [];
    for (int i = 0; i < faqs.length; i++) {
      ans.add(
        ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: Colors.grey.shade200,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: FxText.titleSmall(
                faqs[i].question,
                color: isExpanded
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onBackground,
                fontWeight: isExpanded ? 600 : 500,
              ),
            );
          },
          body: Container(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Center(
              child: FxText.bodyMedium(faqs[i].answer, fontWeight: 500),
            ),
          ),
          isExpanded: dataExpansionPanel[i],
        ),
      );
    }
    return ans;
  }

  Future<void> loadAdminEmail() async {
    AndroidOptions androidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    var st = FlutterSecureStorage(aOptions: androidOptions());
    var d = await st.read(key: 'admin_email');
    if (d != null) {
      setState(() {
        adminEmail = d;
      });
    }
  }
}

class FAQ {
  String question, answer;
  FAQ(this.question, this.answer);
}
