import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/models/soft_buttons.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/views/login_signup/business_registration_screen.dart';
import 'package:seller/views/login_signup/user_registration_screen.dart';

class RegistrationTypeSelectionScreen extends StatefulWidget {
  const RegistrationTypeSelectionScreen({super.key});

  @override
  State<RegistrationTypeSelectionScreen> createState() =>
      _RegistrationTypeSelectionScreenState();
}

class _RegistrationTypeSelectionScreenState
    extends State<RegistrationTypeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            FxSpacing.height(80),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/background/login.webp",
                  ),
                  opacity: 0.7,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            FxSpacing.height(33),
            FxText.titleMedium(
              "Please select the account type ",
              fontWeight: 600,
            ),
            FxSpacing.height(23),
            SoftButtons(
              title: "Business",
              width: 180,
              prefixIcon: Icons.home_outlined,
              backgroundColor: Constant.softColors.violet.color.withOpacity(0.3),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessRegistrationScreen()));
              },
            ),
            FxSpacing.height(13),
            SoftButtons(
              title: "Individual",
              width: 180,
              prefixIcon: Icons.person_2_outlined,
              backgroundColor: Constant.softColors.violet.color.withOpacity(0.8),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserRegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
