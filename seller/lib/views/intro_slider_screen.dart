/*
* File : Shopping Onboarding
* Version : 1.0.0
* */

import 'package:seller/app_constants.dart';
import 'package:seller/theme/app_theme.dart';
import 'package:seller/theme/app_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';
import 'package:seller/views/login_signup/login_screen.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.shoppingManagerTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: AppTheme.textDirection,
              child: child!,
            );
          },
          home: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: theme.colorScheme.background,
              child: FxOnBoarding(
                pages: <PageViewModel>[
                  PageViewModel(
                    theme.colorScheme.background,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage(
                                'assets/placeholder/intro_slide_1.png',
                              ),
                              width: 300,
                              height: 320,
                            ),
                          ),
                          SizedBox(height: 30),
                          FxText.bodyLarge(
                            'Welcome to ${appName}!',
                            fontWeight: 700,
                            fontSize: 18,
                          ),
                          FxSpacing.height(5),
                          FxText.bodyLarge(
                            'Your Partner in Digital Entrepreneurship.',
                            fontWeight: 500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          FxText(
                            'Creating opportunities, transforming the way of doing business for aspiring digital entrepreneurs!',
                            fontWeight: 500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PageViewModel(
                    theme.colorScheme.background,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Center(
                              child: Image(
                            image: AssetImage(
                                'assets/placeholder/intro_slide_2.png'),
                            width: 300,
                            height: 320,
                          )),
                          SizedBox(height: 30),
                          FxText.bodyLarge(
                            'Stay ahead of competition!',
                            fontWeight: 700,
                            fontSize: 18,
                          ),
                          FxText.bodyLarge(
                            'Join the community of successful digital entrepreneurs.',
                            fontWeight: 500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(height: 16),
                          FxText.bodyMedium(
                            'Discover variety of business tools, applications and products to scale up your digital entrepreneurship journey!',
                            fontWeight: 500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PageViewModel(
                    theme.colorScheme.background,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage(
                                  'assets/placeholder/intro_slide_3.png'),
                              width: 300,
                              height: 320,
                            ),
                          ),
                          SizedBox(height: 30),
                          FxText.bodyLarge(
                            'Your Partner in Digital Journey!',
                            fontWeight: 700,
                            fontSize: 18,
                          ),
                          FxSpacing.height(5),
                          FxText.bodyLarge(
                            'Join the community of successful digital entrepreneurs.',
                            fontWeight: 500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(height: 16),
                          FxText.bodyMedium(
                            'Sign up today and take the first step towards achieving your business goals.',
                            fontWeight: 500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                unSelectedIndicatorColor:
                    theme.colorScheme.primary.withAlpha(150),
                selectedIndicatorColor: theme.colorScheme.primary,
                doneWidget: InkWell(
                  splashColor: theme.colorScheme.primary,
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: FxText.titleSmall("Sign Up".toUpperCase(),
                        fontWeight: 700, color: theme.colorScheme.primary),
                  ),
                ),
                skipWidget: InkWell(
                  splashColor: theme.colorScheme.primary,
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: FxText.titleSmall("Skip".toUpperCase(),
                        color: theme.colorScheme.primary,
                        fontWeight: 700,
                        letterSpacing: 0.6),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
